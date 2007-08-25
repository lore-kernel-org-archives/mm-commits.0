From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-prerequisite-parser.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:57 -0700
Message-ID: <200708250518.l7P5IvpC031923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbXHYFbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure - prerequisite: parser enhancement
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-prerequisite-parser.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure - prerequisite: parser enhancement
From: Martin Peschke <mp3@de.ibm.com>

Add a match_* derivate for 64 bit operands to the parser library.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/parser.h |    1 +
 lib/parser.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/parser.h~statistics-infrastructure-prerequisite-parser include/linux/parser.h
--- a/include/linux/parser.h~statistics-infrastructure-prerequisite-parser
+++ a/include/linux/parser.h
@@ -31,3 +31,4 @@ int match_octal(substring_t *, int *resu
 int match_hex(substring_t *, int *result);
 void match_strcpy(char *, const substring_t *);
 char *match_strdup(const substring_t *);
+int match_s64(substring_t *, s64 *result, int);
diff -puN lib/parser.c~statistics-infrastructure-prerequisite-parser lib/parser.c
--- a/lib/parser.c~statistics-infrastructure-prerequisite-parser
+++ a/lib/parser.c
@@ -140,6 +140,35 @@ static int match_number(substring_t *s, 
 }
 
 /**
+ * match_s64: scan a number in the given base from a substring_t
+ * @s: substring to be scanned
+ * @result: resulting integer on success
+ * @base: base to use when converting string
+ *
+ * Description: Given a &substring_t and a base, attempts to parse the substring
+ * as a number in that base. On success, sets @result to the s64 represented
+ * by the string and returns 0. Returns either -ENOMEM or -EINVAL on failure.
+ */
+int match_s64(substring_t *s, s64 *result, int base)
+{
+	char *endp;
+	char *buf;
+	int ret;
+
+	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memcpy(buf, s->from, s->to - s->from);
+	buf[s->to - s->from] = '\0';
+	*result = simple_strtoll(buf, &endp, base);
+	ret = 0;
+	if (endp == buf)
+		ret = -EINVAL;
+	kfree(buf);
+	return ret;
+}
+
+/**
  * match_int: - scan a decimal representation of an integer from a substring_t
  * @s: substring_t to be scanned
  * @result: resulting integer on success
@@ -218,3 +247,4 @@ EXPORT_SYMBOL(match_octal);
 EXPORT_SYMBOL(match_hex);
 EXPORT_SYMBOL(match_strcpy);
 EXPORT_SYMBOL(match_strdup);
+EXPORT_SYMBOL(match_s64);
_

Patches currently in -mm which might be from mp3@de.ibm.com are
