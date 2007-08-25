From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-prerequisite-parser-fix.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:54 -0700
Message-ID: <200708250518.l7P5IsGE031917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbXHYF3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     small lib/parser.c cleanup
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-prerequisite-parser-fix.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: small lib/parser.c cleanup
From: Martin Peschke <mp3@de.ibm.com>

simplifying code by using available string duplication function

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff -puN lib/parser.c~statistics-infrastructure-prerequisite-parser-fix lib/parser.c
--- a/lib/parser.c~statistics-infrastructure-prerequisite-parser-fix
+++ a/lib/parser.c
@@ -126,11 +126,9 @@ static int match_number(substring_t *s, 
 	char *buf;
 	int ret;
 
-	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	buf = match_strdup(s);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, s->from, s->to - s->from);
-	buf[s->to - s->from] = '\0';
 	*result = simple_strtol(buf, &endp, base);
 	ret = 0;
 	if (endp == buf)
@@ -155,11 +153,9 @@ int match_s64(substring_t *s, s64 *resul
 	char *buf;
 	int ret;
 
-	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	buf = match_strdup(s);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, s->from, s->to - s->from);
-	buf[s->to - s->from] = '\0';
 	*result = simple_strtoll(buf, &endp, base);
 	ret = 0;
 	if (endp == buf)
_

Patches currently in -mm which might be from mp3@de.ibm.com are
