From: akpm@linux-foundation.org
Subject: + hugetlb-properly-account-rss.patch added to -mm tree
Date: Fri, 28 Jun 2013 15:03:29 -0700
Message-ID: <51ce0831.zcGXknzzYRqaZcxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3F1WDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 18:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joern@logfs.org

Subject: + hugetlb-properly-account-rss.patch added to -mm tree
To: joern@logfs.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 15:03:29 -0700


The patch titled
     Subject: hugetlb: properly account rss
has been added to the -mm tree.  Its filename is
     hugetlb-properly-account-rss.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joern Engel <joern@logfs.org>
Subject: hugetlb: properly account rss

When moving a program from mmap'ing small pages to mmap'ing huge pages, a
remarkable drop in rss ensues.  For some reason hugepages were never
accounted for in rss, which in my book is a clear bug.  Sadly this bug has
been present in hugetlbfs since it was merged back in 2002.  There is
every chance existing programs depend on hugepages not being counted as
rss.

I think the correct solution is to fix the bug and wait for someone to
complain.  It is just as likely that noone cares - as evidenced by the
fact that noone seems to have noticed for ten years.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-properly-account-rss mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-properly-account-rss
+++ a/mm/hugetlb.c
@@ -1191,6 +1191,7 @@ static struct page *alloc_huge_page(stru
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, pages_per_huge_page(h));
 	return page;
 }
 
@@ -2439,6 +2440,9 @@ again:
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
+		/* -pages_per_huge_page(h) wouldn't get sign-extended */
+		add_mm_counter(vma->vm_mm, MM_ANONPAGES, -1 << h->order);
+
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush)
_

Patches currently in -mm which might be from joern@logfs.org are

linux-next.patch
hugetlb-properly-account-rss.patch
mmap-allow-map_hugetlb-for-hugetlbfs-files-v2.patch
nilfs2-implement-calculation-of-free-inodes-count.patch
nilfs2-use-atomic64_t-type-for-inodes_count-and-blocks_count-fields-in-nilfs_root-struct.patch
selftests-exit-1-on-failure.patch
self-test-fix-make-clean.patch
selftests-add-hugetlbfstest.patch

