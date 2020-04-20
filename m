From: akpm@linux-foundation.org
Subject: + khugepaged-add-self-test-fix.patch added to -mm tree
Date: Mon, 20 Apr 2020 14:41:43 -0700
Message-ID: <20200420214143.hn1sIhZMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgDTVlo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 17:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: khugepaged: fix several spelling mistakes
has been added to the -mm tree.  Its filename is
     khugepaged-add-self-test-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-add-self-test-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-add-self-test-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: selftests: khugepaged: fix several spelling mistakes

There a are several spelling mistakes in various messages. Fix these.

There are three spelling mistakes in various messages. Fix these.

Link: http://lkml.kernel.org/r/20200420084241.65433-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-add-self-test-fix
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -534,7 +534,7 @@ static void collapse_max_ptes_none(void)
 	p = alloc_mapping();
 
 	fill_memory(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
-	if (wait_for_scan("Do not collapse with max_ptes_none exeeded", p))
+	if (wait_for_scan("Do not collapse with max_ptes_none exceeded", p))
 		fail("Timeout");
 	else if (check_huge(p))
 		fail("Fail");
@@ -573,7 +573,7 @@ static void collapse_swapin_single_pte(v
 		goto out;
 	}
 
-	if (wait_for_scan("Collapse with swaping in single PTE entry", p))
+	if (wait_for_scan("Collapse with swapping in single PTE entry", p))
 		fail("Timeout");
 	else if (check_huge(p))
 		success("OK");
@@ -604,7 +604,7 @@ static void collapse_max_ptes_swap(void)
 		goto out;
 	}
 
-	if (wait_for_scan("Do not collapse with max_ptes_swap exeeded", p))
+	if (wait_for_scan("Do not collapse with max_ptes_swap exceeded", p))
 		fail("Timeout");
 	else if (check_huge(p))
 		fail("Fail");
@@ -651,14 +651,14 @@ static void collapse_single_pte_entry_co
 		fail("Fail");
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 
-	printf("Split huge page leaving single PTE mapping compount page...");
+	printf("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
 	if (!check_huge(p))
 		success("OK");
 	else
 		fail("Fail");
 
-	if (wait_for_scan("Collapse PTE table with single PTE mapping compount page", p))
+	if (wait_for_scan("Collapse PTE table with single PTE mapping compound page", p))
 		fail("Timeout");
 	else if (check_huge(p))
 		success("OK");
@@ -682,7 +682,7 @@ static void collapse_full_of_compound(vo
 	else
 		fail("Fail");
 
-	printf("Split huge page leaving single PTE page table full of compount pages...");
+	printf("Split huge page leaving single PTE page table full of compound pages...");
 	madvise(p, page_size, MADV_NOHUGEPAGE);
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	if (!check_huge(p))
_

Patches currently in -mm which might be from colin.king@canonical.com are

khugepaged-add-self-test-fix.patch
es-khugepaged-introduce-max_ptes_shared-tunable-fix.patch
