From: akpm@linux-foundation.org
Subject: + mincore-do-nested-page-table-walks.patch added to -mm tree
Date: Wed, 24 Mar 2010 14:29:47 -0700
Message-ID: <201003242129.o2OLTljR028067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab0CXVaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 17:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com


The patch titled
     mincore: do nested page table walks
has been added to the -mm tree.  Its filename is
     mincore-do-nested-page-table-walks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mincore: do nested page table walks
From: Johannes Weiner <hannes@cmpxchg.org>

Do page table walks with the well-known nested loops we use in several
other places already.

This avoids doing full page table walks after every pte range and also
allows to handle unmapped areas bigger than one pte range in one go.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   75 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff -puN mm/mincore.c~mincore-do-nested-page-table-walks mm/mincore.c
--- a/mm/mincore.c~mincore-do-nested-page-table-walks
+++ a/mm/mincore.c
@@ -144,6 +144,60 @@ static void mincore_pte_range(struct vm_
 	pte_unmap_unlock(ptep - 1, ptl);
 }
 
+static void mincore_pmd_range(struct vm_area_struct *vma, pud_t *pud,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pmd_t *pmd;
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pte_range(vma, pmd, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pmd++, addr = next, addr != end);
+}
+
+static void mincore_pud_range(struct vm_area_struct *vma, pgd_t *pgd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pud_t *pud;
+
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pmd_range(vma, pud, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pud++, addr = next, addr != end);
+}
+
+static void mincore_page_range(struct vm_area_struct *vma,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec)
+{
+	unsigned long next;
+	pgd_t *pgd;
+
+	pgd = pgd_offset(vma->vm_mm, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			mincore_unmapped_range(vma, addr, next, vec);
+		else
+			mincore_pud_range(vma, pgd, addr, next, vec);
+		vec += (next - addr) >> PAGE_SHIFT;
+	} while (pgd++, addr = next, addr != end);
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -151,9 +205,6 @@ static void mincore_pte_range(struct vm_
  */
 static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
 	struct vm_area_struct *vma;
 	unsigned long end;
 
@@ -170,21 +221,11 @@ static long do_mincore(unsigned long add
 
 	end = pmd_addr_end(addr, end);
 
-	pgd = pgd_offset(vma->vm_mm, addr);
-	if (pgd_none_or_clear_bad(pgd))
-		goto none_mapped;
-	pud = pud_offset(pgd, addr);
-	if (pud_none_or_clear_bad(pud))
-		goto none_mapped;
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none_or_clear_bad(pmd))
-		goto none_mapped;
