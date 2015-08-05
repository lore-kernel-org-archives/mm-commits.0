From: akpm@linux-foundation.org
Subject: + lib-string_helpers-rename-esc-arg-to-only.patch added to -mm
 tree
Date: Wed, 05 Aug 2015 13:45:06 -0700
Message-ID: <55c275d2.A6WtAQZCQH/QOZfl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbHEUpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 16:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: rename "esc" arg to "only"
has been added to the -mm tree.  Its filename is
     lib-string_helpers-rename-esc-arg-to-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-rename-esc-arg-to-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-rename-esc-arg-to-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib/string_helpers: rename "esc" arg to "only"

To further clarify the purpose of the "esc" argument, rename it to "only"
to reflect that it is a limit, not a list of additional characters to
escape.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |   14 +++++++-------
 lib/string_helpers.c           |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/string_helpers.h~lib-string_helpers-rename-esc-arg-to-only include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpers-rename-esc-arg-to-only
+++ a/include/linux/string_helpers.h
@@ -48,24 +48,24 @@ static inline int string_unescape_any_in
 #define ESCAPE_HEX		0x20
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
-		unsigned int flags, const char *esc);
+		unsigned int flags, const char *only);
 
 static inline int string_escape_mem_any_np(const char *src, size_t isz,
-		char *dst, size_t osz, const char *esc)
+		char *dst, size_t osz, const char *only)
 {
-	return string_escape_mem(src, isz, dst, osz, ESCAPE_ANY_NP, esc);
+	return string_escape_mem(src, isz, dst, osz, ESCAPE_ANY_NP, only);
 }
 
 static inline int string_escape_str(const char *src, char *dst, size_t sz,
-		unsigned int flags, const char *esc)
+		unsigned int flags, const char *only)
 {
-	return string_escape_mem(src, strlen(src), dst, sz, flags, esc);
+	return string_escape_mem(src, strlen(src), dst, sz, flags, only);
 }
 
 static inline int string_escape_str_any_np(const char *src, char *dst,
-		size_t sz, const char *esc)
+		size_t sz, const char *only)
 {
-	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, esc);
+	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, only);
 }
 
 #endif
diff -puN lib/string_helpers.c~lib-string_helpers-rename-esc-arg-to-only lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-rename-esc-arg-to-only
+++ a/lib/string_helpers.c
@@ -432,8 +432,8 @@ static bool escape_hex(unsigned char c,
  *		all previous together
  *	%ESCAPE_HEX:
  *		'\xHH' - byte with hexadecimal value HH (2 digits)
- * @esc:	NULL-terminated string containing characters used to limit
- *		the selected escape class. If characters are included in @esc
+ * @only:	NULL-terminated string containing characters used to limit
+ *		the selected escape class. If characters are included in @only
  *		that would not normally be escaped by the classes selected
  *		in @flags, they will be copied to @dst unescaped.
  *
@@ -442,7 +442,7 @@ static bool escape_hex(unsigned char c,
  * in the following sequence.
  *	1. The character is matched to the printable class, if asked, and in
  *	   case of match it passes through to the output.
- *	2. The character is not matched to the one from @esc string and thus
+ *	2. The character is not matched to the one from @only string and thus
  *	   must go as-is to the output.
  *	3. The character is checked if it falls into the class given by @flags.
  *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
@@ -460,11 +460,11 @@ static bool escape_hex(unsigned char c,
  * dst for a '\0' terminator if and only if ret < osz.
  */
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
-		      unsigned int flags, const char *esc)
+		      unsigned int flags, const char *only)
 {
 	char *p = dst;
 	char *end = p + osz;
-	bool is_dict = esc && *esc;
+	bool is_dict = only && *only;
 
 	while (isz--) {
 		unsigned char c = *src++;
@@ -473,7 +473,7 @@ int string_escape_mem(const char *src, s
 		 * Apply rules in the following sequence:
 		 *	- the character is printable, when @flags has
 		 *	  %ESCAPE_NP bit set
-		 *	- the @esc string is supplied and does not contain a
+		 *	- the @only string is supplied and does not contain a
 		 *	  character under question
 		 *	- the character doesn't fall into a class of symbols
 		 *	  defined by given @flags
@@ -481,7 +481,7 @@ int string_escape_mem(const char *src, s
 		 * output buffer.
 		 */
 		if ((flags & ESCAPE_NP && isprint(c)) ||
-		    (is_dict && !strchr(esc, c))) {
+		    (is_dict && !strchr(only, c))) {
 			/* do nothing */
 		} else {
 			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
user_ns-use-correct-check-for-single-threadedness.patch
capabilities-ambient-capabilities.patch
capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
clk_register_clkdev-handle-callers-needing-format-string.patch
scripts-spellingtxt-adding-misspelled-word-for-check.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
lib-vsprintf-add-%pt-format-specifier.patch
lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch
lib-string_helpers-rename-esc-arg-to-only.patch
test_user_copy-check-legit-kernel-accesses.patch
test_user_copy-check-unchecked-accessors.patch
test_user_copy-check-__clear_user-clear_user.patch
test_user_copy-check-__copy_in_user-copy_in_user.patch
test_user_copy-check-__copy_tofrom_user_inatomic.patch
test_user_copy-check-user-string-accessors.patch
test_user_copy-check-user-checksum-functions.patch
sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch
linux-next.patch

