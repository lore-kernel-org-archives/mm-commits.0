Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF006C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 21:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiKBVGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 17:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiKBVGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 17:06:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373B6DFD7
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 14:06:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C655961C39
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 21:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251DDC433D6;
        Wed,  2 Nov 2022 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667423188;
        bh=ER0tB5oSwriyyzn9cpnjAnxMRVosIjNCGKtPLFCDckw=;
        h=Date:To:From:Subject:From;
        b=LH1fh8koOgYvqWPqIZwPU9pTIzu7WJm9fSXsqLsEYjoFkejAYmfHtNYagREwhEnm1
         lqN3UNyGAbi6WeoWyK4NxPLS1wXOTrqlG3ocN/X7hdrN4NZjHPoyA9Zkhm9VA+EN3T
         3Qt2yWw20KpKSCv4r+vJWLzpEsolU+OwhN/y5uZc=
Date:   Wed, 02 Nov 2022 14:06:27 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-always-compile-in-pte-markers.patch added to mm-unstable branch
Message-Id: <20221102210628.251DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: always compile in pte markers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-always-compile-in-pte-markers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-always-compile-in-pte-markers.patch

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
@@ -3672,11 +3672,10 @@ static vm_fault_t handle_pte_marker(stru
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

partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch
selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

