From: akpm@linux-foundation.org
Subject: + mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch added to -mm tree
Date: Mon, 13 May 2013 16:09:18 -0700
Message-ID: <20130513230918.858A331C2A9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37084 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab3EMXJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:09:19 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so90334ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:09:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, hughd@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
has been added to the -mm tree.  Its filename is
     mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch

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
Subject: mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

We should not use set_pmd_at to update pmd_t with pgtable_t pointer. 
set_pmd_at is used to set pmd with huge pte entries and architectures like
ppc64, clear few flags from the pte when saving a new entry.  Without this
change we observe bad pte errors like below on ppc64 with THP enabled.

BUG: Bad page map in process ld mm=0xc000001ee39f4780 pte:7fc3f37848000001 pmd:c000001ec0000000

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer
+++ a/mm/huge_memory.c
@@ -2325,7 +2325,12 @@ static void collapse_huge_page(struct mm
 		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd_at(mm, address, pmd, _pmd);
+		/*
+		 * We can only use set_pmd_at when establishing
+		 * hugepmds and never for establishing regular pmds that
+		 * points to regular pagetables. Use pmd_populate for that
+		 */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock_write(vma->anon_vma);
 		goto out;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch

