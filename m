From: akpm@linux-foundation.org
Subject: [merged]
 mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:27:25 -0800
Message-ID: <58b48bad.6hqlpvm0TBHh/ync%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdB0U2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, michaele@au1.ibm.com, mikey@neuling.org, paulus@samba.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/autonuma: let architecture override how the write bit should be stashed in a protnone pte.
has been removed from the -mm tree.  Its filename was
     mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[aneesh.kumar@linux.vnet.ibm.com: don't mark pte saved write in case of dirty_accountable]
  Link: http://lkml.kernel.org/r/1487942884-16517-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
[aneesh.kumar@linux.vnet.ibm.com: v3]
  Link: http://lkml.kernel.org/r/1487498625-10891-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
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
 mm/huge_memory.c              |    6 +++---
 mm/memory.c                   |    2 +-
 mm/mprotect.c                 |    2 +-
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
@@ -1426,7 +1426,7 @@ int do_huge_pmd_numa_page(struct vm_faul
 	}
 
 	/* See similar comment in do_numa_page for explanation */
-	if (!pmd_write(pmd))
+	if (!pmd_savedwrite(pmd))
 		flags |= TNF_NO_GROUP;
 
 	/*
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
@@ -99,7 +99,7 @@ static unsigned long change_pte_range(st
 			ptent = ptep_modify_prot_start(mm, addr, pte);
 			ptent = pte_modify(ptent, newprot);
 			if (preserve_write)
-				ptent = pte_mkwrite(ptent);
+				ptent = pte_mk_savedwrite(ptent);
 
 			/* Avoid taking write faults for known dirty pages */
 			if (dirty_accountable && pte_dirty(ptent) &&
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


