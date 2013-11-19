From: akpm@linux-foundation.org
Subject: + lib-parserc-add-match_wildcard-function.patch added to -mm tree
Date: Tue, 19 Nov 2013 15:34:19 -0800
Message-ID: <528bf57b.GuafqX8ip9SEafAi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KSXeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:34:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jbaron@akamai.com, changbin.du@gmail.com

Subject: + lib-parserc-add-match_wildcard-function.patch added to -mm tree
To: changbin.du@gmail.com,jbaron@akamai.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:34:19 -0800


The patch titled
     Subject: lib/parser.c: add match_wildcard function
has been added to the -mm tree.  Its filename is
     lib-parserc-add-match_wildcard-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-parserc-add-match_wildcard-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-parserc-add-match_wildcard-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Du, Changbin" <changbin.du@gmail.com>
Subject: lib/parser.c: add match_wildcard function

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

lib-parserc-add-match_wildcard-function.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch

