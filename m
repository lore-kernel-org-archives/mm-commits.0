From: akpm@linux-foundation.org
Subject: + mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch
 added to -mm tree
Date: Thu, 16 Jun 2016 15:22:38 -0700
Message-ID: <576326ae.Ic6rgCKKhddTThMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcFPWWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, riel@redhat.com, sergey.senozhatsky.work@gmail.com, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix locking inconsistency in collapse_huge_page
has been added to the -mm tree.  Its filename is
     mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix locking inconsistency in collapse_huge_page

After creating revalidate vma function, locking inconsistency occured
due to directing the code path to wrong label. This patch directs
to correct label and fix the inconsistency.

Related commit that caused inconsistency:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=da4360877094368f6dfe75bbe804b0f0a5d575b0

Link: http://lkml.kernel.org/r/1464956884-4644-1-git-send-email-ebru.akagunduz@gmail.com
Link: http://lkml.kernel.org/r/1466021202-61880-4-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-locking-inconsistency-in-collapse_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-locking-inconsistency-in-collapse_huge_page
+++ a/mm/huge_memory.c
@@ -2488,13 +2488,18 @@ static void collapse_huge_page(struct mm
 
 	down_read(&mm->mmap_sem);
 	result = hugepage_vma_revalidate(mm, address);
-	if (result)
-		goto out;
+	if (result) {
+		mem_cgroup_cancel_charge(new_page, memcg, true);
+		up_read(&mm->mmap_sem);
+		goto out_nolock;
+	}
 
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
-		goto out;
+		mem_cgroup_cancel_charge(new_page, memcg, true);
+		up_read(&mm->mmap_sem);
+		goto out_nolock;
 	}
 
 	/*
@@ -2503,8 +2508,9 @@ static void collapse_huge_page(struct mm
 	 * label out. Continuing to collapse causes inconsistency.
 	 */
 	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+		mem_cgroup_cancel_charge(new_page, memcg, true);
 		up_read(&mm->mmap_sem);
-		goto out;
+		goto out_nolock;
 	}
 
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch

