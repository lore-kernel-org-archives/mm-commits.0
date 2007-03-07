From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:40:15 -0800
Message-ID: <200703070140.l271eF4Z015799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42317 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbXCGBkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:40:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     fix parsing of statistics type-attribute
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
add-for_each_substring-and-match_substring.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-add-for_each_substring-and-match_substring-exploitation.patch
statistics-infrastructure-fix-parsing-of-statistics-type-attribute.patch
statistics-infrastructure-exploitation-zfcp.patch
