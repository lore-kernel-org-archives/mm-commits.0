From: akpm@linux-foundation.org
Subject: [merged] thp-skip-transhuge-pages-in-ksm-for-now.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:45 -0800
Message-ID: <201101142250.p0EMoZEf005423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1ANWur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: skip transhuge pages in ksm for now
has been removed from the -mm tree.  Its filename was
     thp-skip-transhuge-pages-in-ksm-for-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: skip transhuge pages in ksm for now
From: Andrea Arcangeli <aarcange@redhat.com>

Skip transhuge pages in ksm for now.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/ksm.c~thp-skip-transhuge-pages-in-ksm-for-now mm/ksm.c
--- a/mm/ksm.c~thp-skip-transhuge-pages-in-ksm-for-now
+++ a/mm/ksm.c
@@ -430,7 +430,7 @@ static struct page *get_mergeable_page(s
 	page = follow_page(vma, addr, FOLL_GET);
 	if (IS_ERR_OR_NULL(page))
 		goto out;
-	if (PageAnon(page)) {
+	if (PageAnon(page) && !PageTransCompound(page)) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	} else {
@@ -1279,7 +1279,19 @@ next_mm:
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (!IS_ERR_OR_NULL(*page) && PageAnon(*page)) {
+			if (IS_ERR_OR_NULL(*page)) {
+				ksm_scan.address += PAGE_SIZE;
+				cond_resched();
+				continue;
+			}
+			if (PageTransCompound(*page)) {
+				put_page(*page);
+				ksm_scan.address &= HPAGE_PMD_MASK;
+				ksm_scan.address += HPAGE_PMD_SIZE;
+				cond_resched();
+				continue;
+			}
+			if (PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
@@ -1293,8 +1305,7 @@ next_mm:
 				up_read(&mm->mmap_sem);
 				return rmap_item;
 			}
-			if (!IS_ERR_OR_NULL(*page))
-				put_page(*page);
+			put_page(*page);
 			ksm_scan.address += PAGE_SIZE;
 			cond_resched();
 		}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

