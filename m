From: akpm@linux-foundation.org
Subject: +
 mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch added to -mm tree
Date: Mon, 16 Sep 2013 15:46:47 -0700
Message-ID: <52378a57.3oCTyleSSV5w4aQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3IPWqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Sep 2013 18:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, jmarchan@redhat.com

Subject: + mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch added to -mm tree
To: jmarchan@redhat.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Mon, 16 Sep 2013 15:46:47 -0700


The patch titled
     Subject: mm/compaction.c: update comment about zone lock in isolate_freepages_block
has been added to the -mm tree.  Its filename is
     mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: mm/compaction.c: update comment about zone lock in isolate_freepages_block

Since commit f40d1e4 ("mm: compaction: acquire the zone->lock as late as
possible"), isolate_freepages_block() takes the zone->lock itself.  The
function description however still states that the zone->lock must be
held.

This patch removes this outdated statement.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -235,10 +235,9 @@ static bool suitable_migration_target(st
 }
 
 /*
- * Isolate free pages onto a private freelist. Caller must hold zone->lock.
- * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
- * pages inside of the pageblock (even though it may still end up isolating
- * some pages).
+ * Isolate free pages onto a private freelist. If @strict is true, will abort
+ * returning 0 on any invalid PFNs or non-free pages inside of the pageblock
+ * (even though it may still end up isolating some pages).
  */
 static unsigned long isolate_freepages_block(struct compact_control *cc,
 				unsigned long blockpfn,
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-compactionc-update-comment-about-zone-lock-in-isolate_freepages_block.patch

