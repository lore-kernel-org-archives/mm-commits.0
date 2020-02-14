From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migratec-migrate-pg_readahead-flag-fix.patch added
 to -mm tree
Date: Thu, 13 Feb 2020 18:57:04 -0800
Message-ID: <20200214025704.5moYdotiz%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNC5F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:57:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-migratec-migrate-pg_readahead-flag-fix
has been added to the -mm tree.  Its filename is
     mm-migratec-migrate-pg_readahead-flag-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-migrate-pg_readahead-flag-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-migrate-pg_readahead-flag-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
