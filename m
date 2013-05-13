From: akpm@linux-foundation.org
Subject: + mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch added to -mm tree
Date: Mon, 13 May 2013 16:14:04 -0700
Message-ID: <20130513231404.DACC131C276@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39218 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3EMXOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:14:06 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so334338qae.3
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:14:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au


The patch titled
     Subject: mm/THP: withdraw the pgtable after pmdp related operations
has been added to the -mm tree.  Its filename is
     mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch

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
Subject: mm/THP: withdraw the pgtable after pmdp related operations

For architectures like ppc64 we look at deposited pgtable when calling
pmdp_get_and_clear.  So do the pgtable_trans_huge_withdraw after finishing
pmdp related operations.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations
+++ a/mm/huge_memory.c
@@ -1360,9 +1360,15 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
-		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
+		/*
+		 * For architectures like ppc64 we look at deposited pgtable
+		 * when calling pmdp_get_and_clear. So do the
+		 * pgtable_trans_huge_withdraw after finishing pmdp related
+		 * operations.
+		 */
 		orig_pmd = pmdp_get_and_clear(tlb->mm, addr, pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			tlb->mm->nr_ptes--;
 			spin_unlock(&tlb->mm->page_table_lock);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

