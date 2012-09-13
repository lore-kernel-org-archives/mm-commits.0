From: akpm@linux-foundation.org
Subject: + mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch added to -mm tree
Date: Thu, 13 Sep 2012 12:06:53 -0700
Message-ID: <20120913190654.AC36B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33848 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2IMTG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 15:06:58 -0400
Received: by eekd4 with SMTP id d4so211903eek.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:06:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, aarcange@redhat.com, arnd@arndb.de, cmetcalf@tilera.com, gerald.schaefer@de.ibm.com, kirill@shutemov.name, mhocko@suse.cz, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm: thp: fix the pmd_clear() arguments in pmdp_get_and_clear()
has been added to the -mm tree.  Its filename is
     mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: thp: fix the pmd_clear() arguments in pmdp_get_and_clear()

The CONFIG_TRANSPARENT_HUGEPAGE implementation of pmdp_get_and_clear()
calls pmd_clear() with 3 arguments instead of 1.

This happens only for !__HAVE_ARCH_PMDP_GET_AND_CLEAR which doesn't seem
to happen because x86 defines this and it uses pmd_update.

[mhocko@suse.cz: changelog addition]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear
+++ a/include/asm-generic/pgtable.h
@@ -87,7 +87,7 @@ static inline pmd_t pmdp_get_and_clear(s
 				       pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
-	pmd_clear(mm, address, pmdp);
+	pmd_clear(pmdp);
 	return pmd;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
mm-introduce-have_arch_transparent_hugepage.patch

