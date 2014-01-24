From: akpm@linux-foundation.org
Subject: [merged] lib-parserc-add-match_wildcard-function.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:00:47 -0800
Message-ID: <52e2b85f.6Qv+wQPQeQyvosKR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jbaron@akamai.com, changbin.du@gmail.com

Subject: [merged] lib-parserc-add-match_wildcard-function.patch removed from -mm tree
To: changbin.du@gmail.com,jbaron@akamai.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:47 -0800


The patch titled
     Subject: lib/parser.c: add match_wildcard() function
has been removed from the -mm tree.  Its filename was
     lib-parserc-add-match_wildcard-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Du, Changbin" <changbin.du@gmail.com>
Subject: lib/parser.c: add match_wildcard() function

match_wildcard function is a simple implementation of wildcard
matching algorithm. It only supports two usual wildcardes:
    '*' - matches zero or more characters
    '?' - matches one character
This algorithm is safe since it is non-recursive.

Signed-off-by: Du, Changbin <changbin.du@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/parser.h |    1 
 lib/parser.c           |   51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff -puN include/linux/parser.h~lib-parserc-add-match_wildcard-function include/linux/parser.h
--- a/include/linux/parser.h~lib-parserc-add-match_wildcard-function
+++ a/include/linux/parser.h
@@ -29,5 +29,6 @@ int match_token(char *, const match_tabl
 int match_int(substring_t *, int *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
+bool match_wildcard(const char *pattern, const char *str);
 size_t match_strlcpy(char *, const substring_t *, size_t);
 char *match_strdup(const substring_t *);
diff -puN lib/parser.c~lib-parserc-add-match_wildcard-function lib/parser.c
--- a/lib/parser.c~lib-parserc-add-match_wildcard-function
+++ a/lib/parser.c
@@ -193,6 +193,56 @@ int match_hex(substring_t *s, int *resul
 }
 
 /**
+ * match_wildcard: - parse if a string matches given wildcard pattern
+ * @pattern: wildcard pattern
+ * @str: the string to be parsed
+ *
+ * Description: Parse the string @str to check if matches wildcard
+ * pattern @pattern. The pattern may contain two type wildcardes:
+ *   '*' - matches zero or more characters
+ *   '?' - matches one character
+ * If it's matched, return true, else return false.
+ */
+bool match_wildcard(const char *pattern, const char *str)
+{
+	const char *s = str;
+	const char *p = pattern;
+	bool star = false;
+
+	while (*s) {
+		switch (*p) {
+		case '?':
+			s++;
+			p++;
+			break;
+		case '*':
+			star = true;
+			str = s;
+			if (!*++p)
+				return true;
+			pattern = p;
+			break;
+		default:
+			if (*s == *p) {
+				s++;
+				p++;
+			} else {
+				if (!star)
+					return false;
+				str++;
+				s = str;
+				p = pattern;
+			}
+			break;
+		}
+	}
+
+	if (*p == '*')
+		++p;
+	return !*p;
+}
+
+/**
  * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
  * @dest: where to copy to
  * @src: &substring_t to copy
@@ -235,5 +285,6 @@ EXPORT_SYMBOL(match_token);
 EXPORT_SYMBOL(match_int);
 EXPORT_SYMBOL(match_octal);
 EXPORT_SYMBOL(match_hex);
+EXPORT_SYMBOL(match_wildcard);
 EXPORT_SYMBOL(match_strlcpy);
 EXPORT_SYMBOL(match_strdup);
_

Patches currently in -mm which might be from changbin.du@gmail.com are

origin.patch

