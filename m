From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migratec-migrate-pg_readahead-flag-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2020 18:42:28 -0700
Message-ID: <20200407014228.NlZCq-Z7P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGBm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-migratec-migrate-pg_readahead-flag-fix
has been removed from the -mm tree.  Its filename was
     mm-migratec-migrate-pg_readahead-flag-fix.patch

This patch was dropped because it was folded into mm-migratec-migrate-pg_readahead-flag.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migratec-migrate-pg_readahead-flag-fix

tweak comment

Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migratec-migrate-pg_readahead-flag-fix
+++ a/mm/migrate.c
@@ -648,9 +648,9 @@ void migrate_page_states(struct page *ne
 		end_page_writeback(newpage);
 
 	/*
-	 * PG_readahead share the same bit with PG_reclaim, the above
-	 * end_page_writeback() may clear PG_readahead mistakenly, so set
-	 * the bit after that.
+	 * PG_readahead shares the same bit with PG_reclaim.  The above
+	 * end_page_writeback() may clear PG_readahead mistakenly, so set the
+	 * bit after that.
 	 */
 	if (PageReadahead(page))
 		SetPageReadahead(newpage);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-migratec-migrate-pg_readahead-flag.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
