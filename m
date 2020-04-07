From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 016/166] mm/migrate.c: migrate PG_readahead flag
Date: Mon, 06 Apr 2020 20:04:21 -0700
Message-ID: <20200407030421.GxP-BOXEa%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDEX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:23 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org, yang.shi@linux.alibaba.com

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/migrate.c: migrate PG_readahead flag

Currently the migration code doesn't migrate PG_readahead flag. 
Theoretically this would incur slight performance loss as the application
might have to ramp its readahead back up again.  Even though such problem
happens, it might be hidden by something else since migration is typically
triggered by compaction and NUMA balancing, any of which should be more
noticeable.

Migrate the flag after end_page_writeback() since it may clear PG_reclaim
flag, which is the same bit as PG_readahead, for the new page.

[akpm@linux-foundation.org: tweak comment]
Link: http://lkml.kernel.org/r/1581640185-95731-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c~mm-migratec-migrate-pg_readahead-flag
+++ a/mm/migrate.c
@@ -647,6 +647,14 @@ void migrate_page_states(struct page *ne
 	if (PageWriteback(newpage))
 		end_page_writeback(newpage);
 
+	/*
+	 * PG_readahead shares the same bit with PG_reclaim.  The above
+	 * end_page_writeback() may clear PG_readahead mistakenly, so set the
+	 * bit after that.
+	 */
+	if (PageReadahead(page))
+		SetPageReadahead(newpage);
+
 	copy_page_owner(page, newpage);
 
 	mem_cgroup_migrate(page, newpage);
_
