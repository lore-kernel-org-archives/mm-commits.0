From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:45 -0700
Message-ID: <200708250518.l7P5Ijqj031905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbXHYFSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix parsing of statistics type-attribute
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: fix parsing of statistics type-attribute
From: Martin Peschke <mp3@de.ibm.com>

Without this fix the the statistics user interface accepted, for example:

	echo name=my_stats type=utilisa > definition

while it should only accept:

	echo name=my_stats type=utilisation > definition

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/statistic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/statistic.c~statistics-infrastructure-fix-parsing-of-statistics-type-attribute lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-fix-parsing-of-statistics-type-attribute
+++ a/lib/statistic.c
@@ -506,7 +506,8 @@ static int statistic_parse_match(struct 
 		len = (args[0].to - args[0].from);
 		for (type = 0; type < STAT_NONE; type++) {
 			disc = &statistic_discs[type];
-			if (unlikely(strncmp(disc->name, args[0].from, len)))
+			if (strlen(disc->name) != len ||
+			    strncmp(disc->name, args[0].from, len))
 				continue;
 			return statistic_parse_single(stat, info, def, type);
 		}
_

Patches currently in -mm which might be from mp3@de.ibm.com are
