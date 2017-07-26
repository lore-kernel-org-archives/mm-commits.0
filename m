From: akpm@linux-foundation.org
Subject: +
 hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch added to -mm tree
Date: Wed, 26 Jul 2017 15:17:56 -0700
Message-ID: <59791514.SeyESZwj47Mb+pA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mike.kravetz@oracle.com, nyc@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: use pagevec_lookup_range() in remove_inode_hugepages()
has been added to the -mm tree.  Its filename is
     hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: hugetlbfs: use pagevec_lookup_range() in remove_inode_hugepages()

We want only pages from given range in remove_inode_hugepages().  Use
pagevec_lookup_range() instead of pagevec_lookup().

Link: http://lkml.kernel.org/r/20170726114704.7626-8-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages
+++ a/fs/hugetlbfs/inode.c
@@ -403,7 +403,6 @@ static void remove_inode_hugepages(struc
 	struct pagevec pvec;
 	pgoff_t next, index;
 	int i, freed = 0;
-	long lookup_nr = PAGEVEC_SIZE;
 	bool truncate_op = (lend == LLONG_MAX);
 
 	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
@@ -412,30 +411,17 @@ static void remove_inode_hugepages(struc
 	next = start;
 	while (next < end) {
 		/*
-		 * Don't grab more pages than the number left in the range.
-		 */
-		if (end - next < lookup_nr)
-			lookup_nr = end - next;
-
-		/*
 		 * When no more pages are found, we are done.
 		 */
-		if (!pagevec_lookup(&pvec, mapping, &next, lookup_nr))
+		if (!pagevec_lookup_range(&pvec, mapping, &next, end - 1,
+					  PAGEVEC_SIZE))
 			break;
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
 			u32 hash;
 
-			/*
-			 * The page (index) could be beyond end.  This is
-			 * only possible in the punch hole case as end is
-			 * max page offset in the truncate case.
-			 */
 			index = page->index;
-			if (index >= end)
-				break;
