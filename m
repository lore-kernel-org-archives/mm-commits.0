From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migratec-migrate-pg_readahead-flag.patch added to
 -mm tree
Date: Thu, 13 Feb 2020 18:57:02 -0800
Message-ID: <20200214025702.eluMnK_Zb%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNC5D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:57:03 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/migrate.c: migrate PG_readahead flag
has been added to the -mm tree.  Its filename is
     mm-migratec-migrate-pg_readahead-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-migrate-pg_readahead-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-migrate-pg_readahead-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
+	 * PG_readahead share the same bit with PG_reclaim, the above
+	 * end_page_writeback() may clear PG_readahead mistakenly, so set
+	 * the bit after that.
+	 */
+	if (PageReadahead(page))
+		SetPageReadahead(newpage);
+
 	copy_page_owner(page, newpage);
 
 	mem_cgroup_migrate(page, newpage);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
mm-vmpressure-use-mem_cgroup_is_root-api.patch
mm-migratec-migrate-pg_readahead-flag.patch
