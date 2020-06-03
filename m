From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 074/131] mm/hugetlb: avoid unnecessary check on
 pud and pmd entry in huge_pte_offset
Date: Wed, 03 Jun 2020 16:00:53 -0700
Message-ID: <20200603230053.3WZ4_914g%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXA4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:56 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jgg@mellanox.com, linux-mm@kvack.org, lixinhai.lxh@gmail.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, punit.agrawal@arm.com, torvalds@linux-foundation.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/hugetlb: avoid unnecessary check on pud and pmd entry in huge_pte_offset

When huge_pte_offset() is called, the parameter sz can only be PUD_SIZE or
PMD_SIZE.  If sz is PUD_SIZE and code can reach pud, then *pud must be
none, or normal hugetlb entry, or non-present (migration or hwpoisoned)
hugetlb entry, and we can directly return pud.  When sz is PMD_SIZE, pud
must be none or present, and if code can reach pmd, we can directly return
pmd.

So after this patch the code is simplified by first check on the parameter
sz, and avoid unnecessary checks in current code.  Same semantics of
existing code is maintained.

More details about relevant commits:
commit 9b19df292c66 ("mm/hugetlb.c: make huge_pte_offset() consistent
and document behaviour") changed the code path for pud and pmd handling,
see comments about why this patch intends to change it.
...
	pud = pud_offset(p4d, addr);
	if (sz != PUD_SIZE && pud_none(*pud)) // [1]
		return NULL;
	/* hugepage or swap? */
	if (pud_huge(*pud) || !pud_present(*pud)) // [2]
		return (pte_t *)pud;

	pmd = pmd_offset(pud, addr);
	if (sz != PMD_SIZE && pmd_none(*pmd)) // [3]
		return NULL;
	/* hugepage or swap? */
	if (pmd_huge(*pmd) || !pmd_present(*pmd)) // [4]
		return (pte_t *)pmd;

	return NULL; // [5]
...
[1]: this is necessary, return NULL for sz == PMD_SIZE;
[2]: if sz == PUD_SIZE, all valid values of pud entry will cause return;
[3]: dead code, sz != PMD_SIZE never true;
[4]: all valid values of pmd entry will cause return;
[5]: dead code, because of check in [4].

Now, this patch combines [1] and [2] for pud, and combines [3], [4] and
[5] for pmd, so avoid unnecessary checks.

I don't try to catch any invalid values in page table entry, as that will
be checked by caller and avoid extra branch in this function.  Also no
assert on sz must equal PUD_SIZE or PMD_SIZE, since this function only
call for hugetlb mapping.

For commit 3c1d7e6ccb64 ("mm/hugetlb: fix a addressing exception caused by
huge_pte_offset"), since we don't read the entry more than once now,
variable pud_entry and pmd_entry are not needed.

Link: http://lkml.kernel.org/r/1587794313-16849-1-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Cc: Longpeng <longpeng2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-unnecessary-check-on-pud-and-pmd-entry-in-huge_pte_offset
+++ a/mm/hugetlb.c
@@ -5469,8 +5469,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
  * huge_pte_offset() - Walk the page table to resolve the hugepage
  * entry at address @addr
  *
- * Return: Pointer to page table or swap entry (PUD or PMD) for
- * address @addr, or NULL if a p*d_none() entry is encountered and the
+ * Return: Pointer to page table entry (PUD or PMD) for
+ * address @addr, or NULL if a !p*d_present() entry is encountered and the
  * size @sz doesn't match the hugepage size at this level of the page
  * table.
  */
@@ -5479,8 +5479,8 @@ pte_t *huge_pte_offset(struct mm_struct
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
-	pud_t *pud, pud_entry;
-	pmd_t *pmd, pmd_entry;
+	pud_t *pud;
+	pmd_t *pmd;
 
 	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
@@ -5490,22 +5490,16 @@ pte_t *huge_pte_offset(struct mm_struct
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	pud_entry = READ_ONCE(*pud);
-	if (sz != PUD_SIZE && pud_none(pud_entry))
-		return NULL;
-	/* hugepage or swap? */
-	if (pud_huge(pud_entry) || !pud_present(pud_entry))
+	if (sz == PUD_SIZE)
+		/* must be pud huge, non-present or none */
 		return (pte_t *)pud;
