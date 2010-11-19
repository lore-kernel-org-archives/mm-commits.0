From: akpm@linux-foundation.org
Subject: + mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch added to -mm tree
Date: Fri, 19 Nov 2010 11:43:46 -0800
Message-ID: <201011191943.oAJJhkSi030939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488Ab0KSToa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 14:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsterba@suse.cz, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com


The patch titled
     mm: remove call to find_vma in pagewalk for non-hugetlbfs
has been added to the -mm tree.  Its filename is
     mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch

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
Subject: mm: remove call to find_vma in pagewalk for non-hugetlbfs
From: David Sterba <dsterba@suse.cz>

Commit d33b9f45 ("mm: hugetlb: fix hugepage memory leak in
walk_page_range()") introduces a check if a vma is a hugetlbfs one and
later in 5dc37642 ("mm hugetlb: add hugepage support to pagemap") it is
moved under #ifdef CONFIG_HUGETLB_PAGE but a needless find_vma call is
left behind and its result is not used anywhere else in the function.

The side-effect of caching vma for @addr inside walk->mm is neither
utilized in walk_page_range() nor in called functions.

Signed-off-by: David Sterba <dsterba@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/pagewalk.c~mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs mm/pagewalk.c
--- a/mm/pagewalk.c~mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs
+++ a/mm/pagewalk.c
@@ -139,7 +139,6 @@ int walk_page_range(unsigned long addr, 
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
-	struct vm_area_struct *vma;
 
 	if (addr >= end)
 		return err;
@@ -149,15 +148,17 @@ int walk_page_range(unsigned long addr, 
 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
+		struct vm_area_struct *uninitialized_var(vma);
+
 		next = pgd_addr_end(addr, end);
 
+#ifdef CONFIG_HUGETLB_PAGE
 		/*
 		 * handle hugetlb vma individually because pagetable walk for
 		 * the hugetlb page is dependent on the architecture and
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
 		vma = find_vma(walk->mm, addr);
-#ifdef CONFIG_HUGETLB_PAGE
 		if (vma && is_vm_hugetlb_page(vma)) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
_

Patches currently in -mm which might be from dsterba@suse.cz are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch

