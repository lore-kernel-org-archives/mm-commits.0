From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 35/67] mm: pagewalk: allow walking without vma
Date: Mon, 03 Feb 2020 17:35:50 -0800
Message-ID: <20200204013550._5CR33Gg1%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgBDBfy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:35:54 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com

From: Steven Price <steven.price@arm.com>
Subject: mm: pagewalk: allow walking without vma

Since 48684a65b4e3: "mm: pagewalk: fix misbehavior of walk_page_range for
vma(VM_PFNMAP)", page_table_walk() will report any kernel area as a hole,
because it lacks a vma.

This means each arch has re-implemented page table walking when needed,
for example in the per-arch ptdump walker.

Remove the requirement to have a vma in the generic code and add a new
function walk_page_range_novma() which ignores the VMAs and simply walks
the page tables.

Link: http://lkml.kernel.org/r/20191218162402.45610-13-steven.price@arm.com
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

 include/linux/pagewalk.h |    5 ++++
 mm/pagewalk.c            |   40 +++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 8 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-allow-walking-without-vma
+++ a/include/linux/pagewalk.h
@@ -73,6 +73,7 @@ enum page_walk_action {
  * @mm:		mm_struct representing the target process of page table walk
  * @vma:	vma currently walked (NULL if walking outside vmas)
  * @action:	next action to perform (see enum page_walk_action)
+ * @no_vma:	walk ignoring vmas (vma will always be NULL)
  * @private:	private data for callbacks' usage
  *
  * (see the comment on walk_page_range() for more details)
@@ -82,12 +83,16 @@ struct mm_walk {
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum page_walk_action action;
+	bool no_vma;
 	void *private;
 };
 
 int walk_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
+			  unsigned long end, const struct mm_walk_ops *ops,
+			  void *private);
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
--- a/mm/pagewalk.c~mm-pagewalk-allow-walking-without-vma
+++ a/mm/pagewalk.c
@@ -39,7 +39,7 @@ static int walk_pmd_range(pud_t *pud, un
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) || !walk->vma) {
+		if (pmd_none(*pmd) || (!walk->vma && !walk->no_vma)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, walk);
 			if (err)
@@ -65,13 +65,16 @@ again:
 		 * Check this here so we only break down trans_huge
 		 * pages when we _need_ to
 		 */
-		if (walk->action == ACTION_CONTINUE ||
+		if ((!walk->vma && (pmd_leaf(*pmd) || !pmd_present(*pmd))) ||
+		    walk->action == ACTION_CONTINUE ||
 		    !(ops->pte_entry))
 			continue;
 
-		split_huge_pmd(walk->vma, pmd, addr);
-		if (pmd_trans_unstable(pmd))
-			goto again;
+		if (walk->vma) {
+			split_huge_pmd(walk->vma, pmd, addr);
+			if (pmd_trans_unstable(pmd))
+				goto again;
+		}
 
 		err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
@@ -93,7 +96,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	do {
  again:
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) || !walk->vma) {
+		if (pud_none(*pud) || (!walk->vma && !walk->no_vma)) {
 			if (ops->pte_hole)
 				err = ops->pte_hole(addr, next, walk);
 			if (err)
@@ -111,11 +114,13 @@ static int walk_pud_range(p4d_t *p4d, un
 		if (walk->action == ACTION_AGAIN)
 			goto again;
 
-		if (walk->action == ACTION_CONTINUE ||
+		if ((!walk->vma && (pud_leaf(*pud) || !pud_present(*pud))) ||
+		    walk->action == ACTION_CONTINUE ||
 		    !(ops->pmd_entry || ops->pte_entry))
 			continue;
 
-		split_huge_pud(walk->vma, pud, addr);
+		if (walk->vma)
+			split_huge_pud(walk->vma, pud, addr);
 		if (pud_none(*pud))
 			goto again;
 
@@ -389,6 +394,25 @@ int walk_page_range(struct mm_struct *mm
 	return err;
 }
 
+int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
+			  unsigned long end, const struct mm_walk_ops *ops,
+			  void *private)
+{
+	struct mm_walk walk = {
+		.ops		= ops,
+		.mm		= mm,
+		.private	= private,
+		.no_vma		= true
+	};
+
+	if (start >= end || !walk.mm)
+		return -EINVAL;
+
+	lockdep_assert_held(&walk.mm->mmap_sem);
+
+	return __walk_page_range(start, end, &walk);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
_
