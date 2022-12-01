Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B57CC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiLAACD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiLAAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE5688B5E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8616661E6D
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF373C4347C;
        Thu,  1 Dec 2022 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852847;
        bh=QKLmCz4QZ6wcV7ektF13h7aRuMmhdA+D+n2PYDq94mE=;
        h=Date:To:From:Subject:From;
        b=AwYUt9hKezKnTHNge+p1Dthn0hqeqvjx83aVlQv4n3Ji8/8foX3wD8/uSpYGQ4eeN
         HZRZI4HQYVyolhhxIJTgAa19gwBAjbMTGpJt6ZDthAK11qQbuSwtuGMuekyZu7bJnv
         R6Qf9CbtfrCu6q7J5oqCADDhOew0pnXlHuKxUSdE=
Date:   Wed, 30 Nov 2022 16:00:47 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-compile-in-pte-markers.patch removed from -mm tree
Message-Id: <20221201000047.BF373C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: always compile in pte markers
has been removed from the -mm tree.  Its filename was
     mm-always-compile-in-pte-markers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: always compile in pte markers
Date: Sun, 30 Oct 2022 17:41:50 -0400

Patch series "mm: Use pte marker for swapin errors".

This series uses the pte marker to replace the swapin error swap entry,
then we save one more swap entry slot for swap devices.  A new pte marker
bit is defined.


This patch (of 2):

The PTE markers code is tiny and now it's enabled for most of the
distributions.  It's fine to keep it as-is, but to make a broader use of
it (e.g.  replacing read error swap entry) it needs to be there always
otherwise we need special code path to take care of !PTE_MARKER case.

It'll be easier just make pte marker always exist.  Use this chance to
extend its usage to anonymous too by simply touching up some of the old
comments, because it'll be used for anonymous pages in the follow up
patches.

Link: https://lkml.kernel.org/r/20221030214151.402274-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221030214151.402274-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h    |   10 +++-------
 include/linux/swapops.h |   31 -------------------------------
 mm/Kconfig              |    7 -------
 mm/memory.c             |    7 +++----
 4 files changed, 6 insertions(+), 49 deletions(-)

--- a/include/linux/swap.h~mm-always-compile-in-pte-markers
+++ a/include/linux/swap.h
@@ -60,17 +60,13 @@ static inline int current_is_kswapd(void
 			     SWP_MIGRATION_NUM + SWP_DEVICE_NUM + \
 			     SWP_PTE_MARKER_NUM)
 /*
- * PTE markers are used to persist information onto PTEs that are mapped with
- * file-backed memories.  As its name "PTE" hints, it should only be applied to
- * the leaves of pgtables.
+ * PTE markers are used to persist information onto PTEs that otherwise
+ * should be a none pte.  As its name "PTE" hints, it should only be
+ * applied to the leaves of pgtables.
  */
-#ifdef CONFIG_PTE_MARKER
 #define SWP_PTE_MARKER_NUM 1
 #define SWP_PTE_MARKER     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
 			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
-#else
-#define SWP_PTE_MARKER_NUM 0
-#endif
 
 /*
  * Unaddressable device memory support. See include/linux/hmm.h and
--- a/include/linux/swapops.h~mm-always-compile-in-pte-markers
+++ a/include/linux/swapops.h
@@ -412,8 +412,6 @@ typedef unsigned long pte_marker;
 #define  PTE_MARKER_UFFD_WP  BIT(0)
 #define  PTE_MARKER_MASK     (PTE_MARKER_UFFD_WP)
 
-#ifdef CONFIG_PTE_MARKER
-
 static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
 {
 	return swp_entry(SWP_PTE_MARKER, marker);
@@ -434,32 +432,6 @@ static inline bool is_pte_marker(pte_t p
 	return is_swap_pte(pte) && is_pte_marker_entry(pte_to_swp_entry(pte));
 }
 
-#else /* CONFIG_PTE_MARKER */
-
-static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
-{
-	/* This should never be called if !CONFIG_PTE_MARKER */
-	WARN_ON_ONCE(1);
-	return swp_entry(0, 0);
-}
-
-static inline bool is_pte_marker_entry(swp_entry_t entry)
-{
-	return false;
-}
-
-static inline pte_marker pte_marker_get(swp_entry_t entry)
-{
-	return 0;
-}
-
-static inline bool is_pte_marker(pte_t pte)
-{
-	return false;
-}
-
-#endif /* CONFIG_PTE_MARKER */
-
 static inline pte_t make_pte_marker(pte_marker marker)
 {
 	return swp_entry_to_pte(make_pte_marker_entry(marker));
@@ -477,9 +449,6 @@ static inline pte_t make_pte_marker(pte_
  * memory, kernel-only memory (including when the system is during-boot),
  * non-ram based generic file-system.  It's fine to be used even there, but the
  * extra pte marker check will be pure overhead.
- *
- * For systems configured with !CONFIG_PTE_MARKER this will be automatically
- * optimized to pte_none().
  */
 static inline int pte_none_mostly(pte_t pte)
 {
--- a/mm/Kconfig~mm-always-compile-in-pte-markers
+++ a/mm/Kconfig
@@ -1107,17 +1107,10 @@ config HAVE_ARCH_USERFAULTFD_MINOR
 	help
 	  Arch has userfaultfd minor fault support
 
-config PTE_MARKER
-	bool
-
-	help
-	  Allows to create marker PTEs for file-backed memory.
-
 config PTE_MARKER_UFFD_WP
 	bool "Userfaultfd write protection support for shmem/hugetlbfs"
 	default y
 	depends on HAVE_ARCH_USERFAULTFD_WP
-	select PTE_MARKER
 
 	help
 	  Allows to create marker PTEs for userfaultfd write protection
--- a/mm/memory.c~mm-always-compile-in-pte-markers
+++ a/mm/memory.c
@@ -3662,11 +3662,10 @@ static vm_fault_t handle_pte_marker(stru
 	unsigned long marker = pte_marker_get(entry);
 
 	/*
-	 * PTE markers should always be with file-backed memories, and the
-	 * marker should never be empty.  If anything weird happened, the best
-	 * thing to do is to kill the process along with its mm.
+	 * PTE markers should never be empty.  If anything weird happened,
+	 * the best thing to do is to kill the process along with its mm.
 	 */
-	if (WARN_ON_ONCE(vma_is_anonymous(vmf->vma) || !marker))
+	if (WARN_ON_ONCE(!marker))
 		return VM_FAULT_SIGBUS;
 
 	if (pte_marker_entry_uffd_wp(entry))
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

