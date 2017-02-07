From: akpm@linux-foundation.org
Subject: +
 mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch added to -mm tree
Date: Tue, 07 Feb 2017 13:23:25 -0800
Message-ID: <589a3acd.0zO0BTkcsIvA70y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754736AbdBGVaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 16:30:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix
has been added to the -mm tree.  Its filename is
     mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix

remove unwanted ppc change, per Aneesh

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix
+++ a/arch/powerpc/mm/pgtable.c
@@ -186,7 +186,12 @@ static pte_t set_access_flags_filter(pte
 void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte)
 {
-	VM_WARN_ON(pte_present(*ptep));
+	/*
+	 * When handling numa faults, we already have the pte marked
+	 * _PAGE_PRESENT, but we can be sure that it is not in hpte.
+	 * Hence we can use set_pte_at for them.
+	 */
+	VM_WARN_ON(pte_present(*ptep) && !pte_protnone(*ptep));
 
 	/*
 	 * Add the pte bit when tryint set a pte
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

