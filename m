From: akpm@linux-foundation.org
Subject: + statistics-infrastructure-prerequisite-parser-fix.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:38:06 -0800
Message-ID: <200703070138.l271c65E015687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbXCGBic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mp3@de.ibm.com


The patch titled
     small lib/parser.c cleanup
has been added to the -mm tree.  Its filename is
     statistics-infrastructure-prerequisite-parser-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

statistics-infrastructure-prerequisite-list.patch
statistics-infrastructure-prerequisite-parser.patch
statistics-infrastructure-prerequisite-parser-fix.patch
statistics-infrastructure-prerequisite-timestamp.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-documentation.patch
statistics-infrastructure.patch
statistics-infrastructure-exploitation-zfcp.patch
add-for_each_substring-and-match_substring.patch
add-for_each_substring-and-match_substring-exploitation.patch
