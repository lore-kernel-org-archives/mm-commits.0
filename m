Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35505CDB465
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 16:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbjJSQrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345017AbjJSQqy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 12:46:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F2111B
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 09:46:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14931C433C7;
        Thu, 19 Oct 2023 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697734012;
        bh=F6hZkF/SMe+aN9Vra5AztpB/BuMuVw9GCbI5T0JJbYI=;
        h=Date:To:From:Subject:From;
        b=oGizeahruBhecXnzntMN2LVjjYSQRhVZxWPzpIKMH47rJly2xjTSYK+sgcEQ5eY33
         WiJbBEvK2Gwm+b+BMb+x50aa8dRsOrqoagty4GbuY8Gdg0HO2YGr6AYvvQhdwaj4yn
         1E+VB1M/2vNI1FprPKpxnSPIO0qcFDDl6fnv1AH4=
Date:   Thu, 19 Oct 2023 09:46:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        senozhatsky@chromium.org, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        konradybcio@kernel.org, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, 21cnbao@gmail.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch added to mm-unstable branch
Message-Id: <20231019164652.14931C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: batch TLB flushes when restoring vmemmap
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: batch TLB flushes when restoring vmemmap
Date: Wed, 18 Oct 2023 19:31:10 -0700

Update the internal hugetlb restore vmemmap code path such that TLB
flushing can be batched.  Use the existing mechanism of passing the
VMEMMAP_REMAP_NO_TLB_FLUSH flag to indicate flushing should not be
performed for individual pages.  The routine
hugetlb_vmemmap_restore_folios is the only user of this new mechanism, and
it will perform a global flush after all vmemmap is restored.

Link: https://lkml.kernel.org/r/20231019023113.345257-9-mike.kravetz@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/mm/hugetlb_vmemmap.c~hugetlb-batch-tlb-flushes-when-restoring-vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -461,18 +461,19 @@ out:
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
  * @reuse:	reuse address.
+ * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse)
+			       unsigned long reuse, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= 0,
+		.flags		= flags,
 	};
 
 	/* See the comment in the vmemmap_remap_free(). */
@@ -494,17 +495,7 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
-/**
- * hugetlb_vmemmap_restore - restore previously optimized (by
- *			     hugetlb_vmemmap_optimize()) vmemmap pages which
- *			     will be reallocated and remapped.
- * @h:		struct hstate.
- * @head:	the head page whose vmemmap pages will be restored.
- *
- * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
- * negative error code otherwise.
- */
-int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+static int __hugetlb_vmemmap_restore(const struct hstate *h, struct page *head, unsigned long flags)
 {
 	int ret;
 	unsigned long vmemmap_start = (unsigned long)head, vmemmap_end;
@@ -525,7 +516,7 @@ int hugetlb_vmemmap_restore(const struct
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
 	if (!ret) {
 		ClearHPageVmemmapOptimized(head);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
@@ -535,6 +526,21 @@ int hugetlb_vmemmap_restore(const struct
 }
 
 /**
+ * hugetlb_vmemmap_restore - restore previously optimized (by
+ *				hugetlb_vmemmap_optimize()) vmemmap pages which
+ *				will be reallocated and remapped.
+ * @h:		struct hstate.
+ * @head:	the head page whose vmemmap pages will be restored.
+ *
+ * Return: %0 if @head's vmemmap pages have been reallocated and remapped,
+ * negative error code otherwise.
+ */
+int hugetlb_vmemmap_restore(const struct hstate *h, struct page *head)
+{
+	return __hugetlb_vmemmap_restore(h, head, 0);
+}
+
+/**
  * hugetlb_vmemmap_restore_folios - restore vmemmap for every folio on the list.
  * @h:			hstate.
  * @folio_list:		list of folios.
@@ -557,7 +563,8 @@ long hugetlb_vmemmap_restore_folios(cons
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			ret = hugetlb_vmemmap_restore(h, &folio->page);
+			ret = __hugetlb_vmemmap_restore(h, &folio->page,
+						VMEMMAP_REMAP_NO_TLB_FLUSH);
 			if (ret)
 				break;
 			restored++;
@@ -567,6 +574,8 @@ long hugetlb_vmemmap_restore_folios(cons
 		list_move(&folio->lru, non_hvo_folios);
 	}
 
+	if (restored)
+		flush_tlb_all();
 	if (!ret)
 		ret = restored;
 	return ret;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

