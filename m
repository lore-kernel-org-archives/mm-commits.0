From: akpm@linux-foundation.org
Subject: +
 mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch added to -mm tree
Date: Tue, 14 Feb 2017 16:20:17 -0800
Message-ID: <58a39ec1.bxq3atJBESsCGgMr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdBOAUS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 19:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, michaele@au1.ibm.com, mikey@neuling.org, paulus@samba.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/autonuma: let architecture override how the write bit should be stashed in a protnone pte.
has been added to the -mm tree.  Its filename is
     mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/autonuma: let architecture override how the write bit should be stashed in a protnone pte.

Patch series "Numabalancing preserve write fix", v2.

This patch series address an issue w.r.t THP migration and autonuma
preserve write feature. migrate_misplaced_transhuge_page() cannot deal with
concurrent modification of the page. It does a page copy without
following the migration pte sequence. IIUC, this was done to keep the
migration simpler and at the time of implemenation we didn't had THP
page cache which would have required a more elaborate migration scheme.
That means thp autonuma migration expect the protnone with saved write
to be done such that both kernel and user cannot update
the page content. This patch series enables archs like ppc64 to do that.
We are good with the hash translation mode with the current code,
because we never create a hardware page table entry for a protnone pte. 


This patch (of 2):

Autonuma preserves the write permission across numa fault to avoid taking
a writefault after a numa fault (Commit: b191f9b106ea " mm: numa: preserve
PTE write permissions across a NUMA hinting fault").  Architecture can
implement protnone in different ways and some may choose to implement that
by clearing Read/ Write/Exec bit of pte.  Setting the write bit on such
pte can result in wrong behaviour.  Fix this up by allowing arch to
override how to save the write bit on a protnone pte.

Link: http://lkml.kernel.org/r/1487050314-3892-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   16 ++++++++++++++++
 mm/huge_memory.c              |    4 ++--
 mm/memory.c                   |    2 +-
 mm/mprotect.c                 |    4 ++--
 4 files changed, 21 insertions(+), 5 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte
+++ a/include/asm-generic/pgtable.h
@@ -225,6 +225,22 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
+#ifndef pte_savedwrite
+#define pte_savedwrite pte_write
+#endif
+
+#ifndef pte_mk_savedwrite
+#define pte_mk_savedwrite pte_mkwrite
+#endif
+
+#ifndef pmd_savedwrite
+#define pmd_savedwrite pmd_write
+#endif
+
+#ifndef pmd_mk_savedwrite
+#define pmd_mk_savedwrite pmd_mkwrite
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
diff -puN mm/huge_memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte mm/huge_memory.c
--- a/mm/huge_memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte
+++ a/mm/huge_memory.c
@@ -1489,7 +1489,7 @@ int do_huge_pmd_numa_page(struct vm_faul
 	goto out;
 clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
-	was_writable = pmd_write(pmd);
+	was_writable = pmd_savedwrite(pmd);
 	pmd = pmd_modify(pmd, vma->vm_page_prot);
 	pmd = pmd_mkyoung(pmd);
 	if (was_writable)
@@ -1744,7 +1744,7 @@ int change_huge_pmd(struct vm_area_struc
 			entry = pmdp_huge_get_and_clear_notify(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
 			if (preserve_write)
-				entry = pmd_mkwrite(entry);
+				entry = pmd_mk_savedwrite(entry);
 			ret = HPAGE_PMD_NR;
 			set_pmd_at(mm, addr, pmd, entry);
 			BUG_ON(vma_is_anonymous(vma) && !preserve_write &&
diff -puN mm/memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte mm/memory.c
--- a/mm/memory.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte
+++ a/mm/memory.c
@@ -3401,7 +3401,7 @@ static int do_numa_page(struct vm_fault
 	int target_nid;
 	bool migrated = false;
 	pte_t pte;
-	bool was_writable = pte_write(vmf->orig_pte);
+	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
 
 	/*
diff -puN mm/mprotect.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte mm/mprotect.c
--- a/mm/mprotect.c~mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte
+++ a/mm/mprotect.c
@@ -99,13 +99,13 @@ static unsigned long change_pte_range(st
 			ptent = ptep_modify_prot_start(mm, addr, pte);
 			ptent = pte_modify(ptent, newprot);
 			if (preserve_write)
-				ptent = pte_mkwrite(ptent);
+				ptent = pte_mk_savedwrite(ptent);
 
 			/* Avoid taking write faults for known dirty pages */
 			if (dirty_accountable && pte_dirty(ptent) &&
 					(pte_soft_dirty(ptent) ||
 					 !(vma->vm_flags & VM_SOFTDIRTY))) {
-				ptent = pte_mkwrite(ptent);
+				ptent = pte_mk_savedwrite(ptent);
 			}
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
 			pages++;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch

