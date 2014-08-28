From: akpm@linux-foundation.org
Subject: + lib-string_helpers-move-documentation-to-c-file.patch added to
 -mm tree
Date: Thu, 28 Aug 2014 14:09:05 -0700
Message-ID: <53ff9a71.QSLEi9G0hwk3tzeh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:46067 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaH1VTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 17:19:12 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so398519iec.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 14:19:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib / string_helpers: move documentation to c-file
has been added to the -mm tree.  Its filename is
     lib-string_helpers-move-documentation-to-c-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-move-documentation-to-c-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-move-documentation-to-c-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib / string_helpers: move documentation to c-file

The introduced function string_escape_mem() is a kind of opposite to
string_unescape.  We have several users of such functionality each of them
created custom implementation.  The series contains clean up of test
suite, adding new call, and switching few users to use it via %*pE
specifier.

Test suite covers all of existing and most of potential use cases.


This patch (of 11):

The documentation of API belongs to c-file.  This patch moves it
accordingly.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |   34 ---------------------------
 lib/string_helpers.c           |   38 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 34 deletions(-)

diff -puN include/linux/string_helpers.h~lib-string_helpers-move-documentation-to-c-file include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpers-move-documentation-to-c-file
+++ a/include/linux/string_helpers.h
@@ -20,40 +20,6 @@ int string_get_size(u64 size, enum strin
 #define UNESCAPE_ANY		\
 	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
 
-/**
- * string_unescape - unquote characters in the given string
- * @src:	source buffer (escaped)
- * @dst:	destination buffer (unescaped)
- * @size:	size of the destination buffer (0 to unlimit)
- * @flags:	combination of the flags (bitwise OR):
- *	%UNESCAPE_SPACE:
- *		'\f' - form feed
- *		'\n' - new line
- *		'\r' - carriage return
- *		'\t' - horizontal tab
- *		'\v' - vertical tab
- *	%UNESCAPE_OCTAL:
- *		'\NNN' - byte with octal value NNN (1 to 3 digits)
- *	%UNESCAPE_HEX:
- *		'\xHH' - byte with hexadecimal value HH (1 to 2 digits)
- *	%UNESCAPE_SPECIAL:
- *		'\"' - double quote
- *		'\\' - backslash
- *		'\a' - alert (BEL)
- *		'\e' - escape
- *	%UNESCAPE_ANY:
- *		all previous together
- *
- * Returns amount of characters processed to the destination buffer excluding
- * trailing '\0'.
- *
- * Because the size of the output will be the same as or less than the size of
- * the input, the transformation may be performed in place.
- *
- * Caller must provide valid source and destination pointers. Be aware that
- * destination buffer will always be NULL-terminated. Source string must be
- * NULL-terminated as well.
- */
 int string_unescape(char *src, char *dst, size_t size, unsigned int flags);
 
 static inline int string_unescape_inplace(char *buf, unsigned int flags)
diff -puN lib/string_helpers.c~lib-string_helpers-move-documentation-to-c-file lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-move-documentation-to-c-file
+++ a/lib/string_helpers.c
@@ -168,6 +168,44 @@ static bool unescape_special(char **src,
 	return true;
 }
 
+/**
+ * string_unescape - unquote characters in the given string
+ * @src:	source buffer (escaped)
+ * @dst:	destination buffer (unescaped)
+ * @size:	size of the destination buffer (0 to unlimit)
+ * @flags:	combination of the flags (bitwise OR):
+ *	%UNESCAPE_SPACE:
+ *		'\f' - form feed
+ *		'\n' - new line
+ *		'\r' - carriage return
+ *		'\t' - horizontal tab
+ *		'\v' - vertical tab
+ *	%UNESCAPE_OCTAL:
+ *		'\NNN' - byte with octal value NNN (1 to 3 digits)
+ *	%UNESCAPE_HEX:
+ *		'\xHH' - byte with hexadecimal value HH (1 to 2 digits)
+ *	%UNESCAPE_SPECIAL:
+ *		'\"' - double quote
+ *		'\\' - backslash
+ *		'\a' - alert (BEL)
+ *		'\e' - escape
+ *	%UNESCAPE_ANY:
+ *		all previous together
+ *
+ * Description:
+ * The function unquotes characters in the given string.
+ *
+ * Because the size of the output will be the same as or less than the size of
+ * the input, the transformation may be performed in place.
+ *
+ * Caller must provide valid source and destination pointers. Be aware that
+ * destination buffer will always be NULL-terminated. Source string must be
+ * NULL-terminated as well.
+ *
+ * Return:
+ * The amount of the characters processed to the destination buffer excluding
+ * trailing '\0' is returned.
+ */
 int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
 {
 	char *out = dst;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

