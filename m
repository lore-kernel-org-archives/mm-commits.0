From: akpm@linux-foundation.org
Subject: + mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix.patch added to -mm tree
Date: Wed, 19 Jan 2011 11:35:07 -0800
Message-ID: <201101191935.p0JJZ8ee031279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1ASTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 14:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
From: Johannes Weiner <hannes@cmpxchg.org>

There is also the one in compact_finished(), here is an update:

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
+++ a/mm/compaction.c
@@ -406,6 +406,10 @@ static int compact_finished(struct zone 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
+	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix.patch

