From: akpm@linux-foundation.org
Subject: [patch 055/162] mm, migrate: increment fail count on ENOMEM
Date: Fri, 20 May 2016 16:59:05 -0700
Message-ID: <573fa4c9.jW31icRtS1+Mp/r/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbcETX7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, mgorman@techsingularity.net, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, migrate: increment fail count on ENOMEM

If page migration fails due to -ENOMEM, nr_failed should still be
incremented for proper statistics.

This was encountered recently when all page migration vmstats showed 0,
and inferred that migrate_pages() was never called, although in reality
the first page migration failed because compaction_alloc() failed to find
a migration target.

This patch increments nr_failed so the vmstat is properly accounted on
ENOMEM.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1605191510230.32658@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/migrate.c~mm-migrate-increment-fail-count-on-enomem mm/migrate.c
--- a/mm/migrate.c~mm-migrate-increment-fail-count-on-enomem
+++ a/mm/migrate.c
@@ -1171,6 +1171,7 @@ int migrate_pages(struct list_head *from
 
 			switch(rc) {
 			case -ENOMEM:
+				nr_failed++;
 				goto out;
 			case -EAGAIN:
 				retry++;
_
