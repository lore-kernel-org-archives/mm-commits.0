Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB300C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjDLUO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDLUOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:14:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1312E3C21
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91AE963232
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE675C433D2;
        Wed, 12 Apr 2023 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681330463;
        bh=3nHtL+BhrpGNtx6HYWjiwsS9TC6wQrX1Cr433z83baY=;
        h=Date:To:From:Subject:From;
        b=RYnV4FO7SGSxhCMVLV7CVZnHvkvc0ArEyhyIvlqzrukIAi90YIfLu/9hC+mvFtDJO
         tet631+v2XgtsPd841D1JsGiBWXJZArOf/Byy1FQkasbCzuANSl4ikErCg7mtbjdi7
         tqirdFxdesUuUFtpOJ4yGJezFhuDXZTLdEOj5w+o=
Date:   Wed, 12 Apr 2023 13:14:22 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, mhocko@suse.com,
        pasha.tatashin@soleen.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch added to mm-unstable branch
Message-Id: <20230412201422.EE675C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: provide stronger vmemmap allocation guarantees
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb_vmemmap-provide-stronger-vmemmap-allocation-guarantees.patch

