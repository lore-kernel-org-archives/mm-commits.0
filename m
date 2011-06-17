From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-migratec-dont-account-swapcache-as-shmem.patch removed from -mm tree
Date: Fri, 17 Jun 2011 12:17:22 -0700
Message-ID: <201106171917.p5HJHDTL028164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab1FQTR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 15:17:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/migrate.c: don't account swapcache as shmem
has been removed from the -mm tree.  Its filename was
     mm-migratec-dont-account-swapcache-as-shmem.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/migrate.c: don't account swapcache as shmem
From: Andrea Arcangeli <aarcange@redhat.com>

swapcache will reach the below code path in migrate_page_move_mapping,
and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
NR_SHMEM.

This can make the NR_SHMEM counter underflow.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migratec-dont-account-swapcache-as-shmem mm/migrate.c
--- a/mm/migrate.c~mm-migratec-dont-account-swapcache-as-shmem
+++ a/mm/migrate.c
@@ -288,7 +288,7 @@ static int migrate_page_move_mapping(str
 	 */
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-	if (PageSwapBacked(page)) {
+	if (mapping != &swapper_space && PageSwapBacked(page)) {
 		__dec_zone_page_state(page, NR_SHMEM);
 		__inc_zone_page_state(newpage, NR_SHMEM);
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
pagewalk-fix-walk_page_range-dont-check-find_vma-result-properly.patch
pagewalk-dont-look-up-vma-if-walk-hugetlb_entry-is-unused.patch
pagewalk-add-locking-rule-comments.patch
pagewalk-add-locking-rule-comments-fix.patch
pagewalk-fix-code-comment-for-thp.patch

