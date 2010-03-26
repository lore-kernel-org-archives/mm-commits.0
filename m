From: akpm@linux-foundation.org
Subject: + pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:32:03 -0700
Message-ID: <201003262132.o2QLW3De021749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab0CZVcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, mpm@selenic.com


The patch titled
     pagemap: add #ifdefs CONFIG_HUGETLB_PAGE on code walking hugetlb vma
has been added to the -mm tree.  Its filename is
     pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma.patch

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
Subject: pagemap: add #ifdefs CONFIG_HUGETLB_PAGE on code walking hugetlb vma
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

If !CONFIG_HUGETLB_PAGE, pagemap_hugetlb_range() is never called.  So put
it (and its calling function) into #ifdef block.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/task_mmu.c~pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma
+++ a/fs/proc/task_mmu.c
@@ -652,6 +652,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	return err;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
 {
 	u64 pme = 0;
@@ -695,6 +696,7 @@ static int pagemap_hugetlb_range(pte_t *
 
 	return err;
 }
+#endif /* HUGETLB_PAGE */
 
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
@@ -788,7 +790,9 @@ static ssize_t pagemap_read(struct file 
 
 	pagemap_walk.pmd_entry = pagemap_pte_range;
 	pagemap_walk.pte_hole = pagemap_pte_hole;
+#ifdef CONFIG_HUGETLB_PAGE
 	pagemap_walk.hugetlb_entry = pagemap_hugetlb_range;
+#endif
 	pagemap_walk.mm = mm;
 	pagemap_walk.private = &pm;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
pagemap-add-ifdefs-config_hugetlb_page-on-code-walking-hugetlb-vma.patch

