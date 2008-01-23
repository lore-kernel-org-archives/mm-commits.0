From: akpm@linux-foundation.org
Subject: + fix-hugepages-leak-due-to-pagetable-page-sharing.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:05:47 -0800
Message-ID: <200801232105.m0NL5dIi026437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYAWVG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:06:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lwoodman@redhat.com, agl@us.ibm.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     fix hugepages leak due to pagetable page sharing
has been added to the -mm tree.  Its filename is
     fix-hugepages-leak-due-to-pagetable-page-sharing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix hugepages leak due to pagetable page sharing
From: Larry Woodman <lwoodman@redhat.com>

The shared page table code for hugetlb memory on x86 and x86_64
is causing a leak.  When a user of hugepages exits using this code
the system leaks some of the hugepages.

-------------------------------------------------------
Part of /proc/meminfo just before database startup:
HugePages_Total:  5500
HugePages_Free:   5500
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

Just before shutdown:
HugePages_Total:  5500
HugePages_Free:   4475
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

After shutdown:
HugePages_Total:  5500
HugePages_Free:   4988
HugePages_Rsvd:
0 Hugepagesize:     2048 kB
----------------------------------------------------------

The problem occurs durring a fork, in copy_hugetlb_page_range().  It
locates the dst_pte using huge_pte_alloc().  Since huge_pte_alloc() calls
huge_pmd_share() it will share the pmd page if can, yet the main loop in
copy_hugetlb_page_range() does a get_page() on every hugepage.  This is a
violation of the shared hugepmd pagetable protocol and creates additional
referenced to the hugepages causing a leak when the unmap of the VMA
occurs.  We can skip the entire replication of the ptes when the hugepage
pagetables are shared.  The attached patch skips copying the ptes and the
get_page() calls if the hugetlbpage pagetable is shared.

Signed-off-by: Larry Woodman <lwoodman@redhat.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/hugetlb.c~fix-hugepages-leak-due-to-pagetable-page-sharing mm/hugetlb.c
--- a/mm/hugetlb.c~fix-hugepages-leak-due-to-pagetable-page-sharing
+++ a/mm/hugetlb.c
@@ -699,6 +699,11 @@ int copy_hugetlb_page_range(struct mm_st
 		dst_pte = huge_pte_alloc(dst, addr);
 		if (!dst_pte)
 			goto nomem;
+
+		/* if the pagetables are shared dont copy or take references */
+		if(dst_pte == src_pte)
+			continue;
+
 		spin_lock(&dst->page_table_lock);
 		spin_lock(&src->page_table_lock);
 		if (!pte_none(*src_pte)) {
_

Patches currently in -mm which might be from lwoodman@redhat.com are

fix-hugepages-leak-due-to-pagetable-page-sharing.patch
fix-hugepages-leak-due-to-pagetable-page-sharing-checkpatch-fixes.patch
include-count-of-pagecache-pages-in-show_mem-output.patch
