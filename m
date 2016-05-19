From: akpm@linux-foundation.org
Subject: + mm-migrate-increment-fail-count-on-enomem.patch added to -mm
 tree
Date: Thu, 19 May 2016 15:30:54 -0700
Message-ID: <573e3e9e.rPw9imPxsrVQUKB6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbcESWaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 18:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, migrate: increment fail count on ENOMEM
has been added to the -mm tree.  Its filename is
     mm-migrate-increment-fail-count-on-enomem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-increment-fail-count-on-enomem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-increment-fail-count-on-enomem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size.patch
mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch
mm-migrate-increment-fail-count-on-enomem.patch

