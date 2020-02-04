From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 36/67] mm: pagewalk: don't lock PTEs for
 walk_page_range_novma()
Date: Mon, 03 Feb 2020 17:35:54 -0800
Message-ID: <20200204013554.8rQSlPVKa%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgBDBf6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:35:58 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com

From: Steven Price <steven.price@arm.com>
Subject: mm: pagewalk: don't lock PTEs for walk_page_range_novma()

walk_page_range_novma() can be used to walk page tables or the kernel or
for firmware.  These page tables may contain entries that are not backed
by a struct page and so it isn't (in general) possible to take the PTE
lock for the pte_entry() callback.  So update walk_pte_range() to only
take the lock when no_vma==false by splitting out the inner loop to a
separate function and add a comment explaining the difference to
walk_page_range_novma().

Link: http://lkml.kernel.org/r/20191218162402.45610-14-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-dont-lock-ptes-for-walk_page_range_novma
+++ a/mm/pagewalk.c
@@ -4,15 +4,12 @@
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
 
-static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			  struct mm_walk *walk)
+static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
 {
-	pte_t *pte;
-	int err = 0;
 	const struct mm_walk_ops *ops = walk->ops;
-	spinlock_t *ptl;
+	int err = 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (;;) {
 		err = ops->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
 		if (err)
@@ -22,8 +19,26 @@ static int walk_pte_range(pmd_t *pmd, un
 			break;
 		pte++;
 	}
+	return err;
+}
+
+static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			  struct mm_walk *walk)
+{
+	pte_t *pte;
+	int err = 0;
+	spinlock_t *ptl;
+
+	if (walk->no_vma) {
+		pte = pte_offset_map(pmd, addr);
+		err = walk_pte_range_inner(pte, addr, end, walk);
+		pte_unmap(pte);
+	} else {
+		pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+		err = walk_pte_range_inner(pte, addr, end, walk);
+		pte_unmap_unlock(pte, ptl);
+	}
 
-	pte_unmap_unlock(pte, ptl);
 	return err;
 }
 
@@ -394,6 +409,12 @@ int walk_page_range(struct mm_struct *mm
 	return err;
 }
 
+/*
+ * Similar to walk_page_range() but can walk any page tables even if they are
+ * not backed by VMAs. Because 'unusual' entries may be walked this function
+ * will also not lock the PTEs for the pte_entry() callback. This is useful for
+ * walking the kernel pages tables or page tables for firmware.
+ */
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  void *private)
_
