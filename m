Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A21C77B60
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 23:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjD1XKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 19:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346876AbjD1XKs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 19:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917C64C07
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 16:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 308A163447
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 23:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C93DC433D2;
        Fri, 28 Apr 2023 23:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682723438;
        bh=paM15O7BYIsYtM/tWdH80vFz8mnYGVth5f5hlAr8Ig0=;
        h=Date:To:From:Subject:From;
        b=bpIj6eFq0shHJgmeUKYoj16EgLROgsor8Gms0OL6IhwKJNFfz06UEKE30nvzyZaXY
         oyxrU8UXSdwRfjZrzJ3OAajvoOJMrOL11UvoYYnwhChHixNC/9Y7KEoD97rg1RYgEg
         KWPfASZ6ADLvLJuYFdPOp/uH8zTd3eZQBlUlq/5s=
Date:   Fri, 28 Apr 2023 16:10:37 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, mhocko@suse.com,
        pasha.tatashin@soleen.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch removed from -mm tree
Message-Id: <20230428231038.7C93DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: provide stronger vmemmap allocation guarantees
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: hugetlb_vmemmap: provide stronger vmemmap allocation guarantees
Date: Wed, 12 Apr 2023 19:59:39 +0000

HugeTLB pages have a struct page optimizations where struct pages for tail
pages are freed.  However, when HugeTLB pages are destroyed, the memory
for struct pages (vmemmap) needs to be allocated again.

Currently, __GFP_NORETRY flag is used to allocate the memory for vmemmap,
but given that this flag makes very little effort to actually reclaim
memory the returning of huge pages back to the system can be problem. 
Lets use __GFP_RETRY_MAYFAIL instead.  This flag is also performs graceful
reclaim without causing ooms, but at least it may perform a few retries,
and will fail only when there is genuinely little amount of unused memory
in the system.

Link: https://lkml.kernel.org/r/20230412195939.1242462-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees
+++ a/mm/hugetlb_vmemmap.c
@@ -384,8 +384,9 @@ static int vmemmap_remap_free(unsigned l
 }
 
 static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   gfp_t gfp_mask, struct list_head *list)
+				   struct list_head *list)
 {
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_THISNODE;
 	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
 	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
@@ -413,12 +414,11 @@ out:
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
  * @reuse:	reuse address.
- * @gfp_mask:	GFP flag for allocating vmemmap pages.
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse, gfp_t gfp_mask)
+			       unsigned long reuse)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
@@ -430,7 +430,7 @@ static int vmemmap_remap_alloc(unsigned
 	/* See the comment in the vmemmap_remap_free(). */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	if (alloc_vmemmap_page_list(start, end, gfp_mask, &vmemmap_pages))
+	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
 	mmap_read_lock(&init_mm);
@@ -476,8 +476,7 @@ int hugetlb_vmemmap_restore(const struct
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse,
-				  GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse);
 	if (!ret) {
 		ClearHPageVmemmapOptimized(head);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


