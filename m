From: akpm@linux-foundation.org
Subject: + lib-string_helpersc-change-semantics-of-string_escape_mem.patch tentatively added to -mm tree
Date: Wed, 04 Mar 2015 13:26:03 -0800
Message-ID: <54f7786b.YUfK0ILKyAumUS9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbCDV0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c: change semantics of string_escape_mem
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-change-semantics-of-string_escape_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-change-semantics-of-string_escape_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-change-semantics-of-string_escape_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string_helpers.c: change semantics of string_escape_mem

The current semantics of string_escape_mem are inadequate for one of its
current users, vsnprintf().  If that is to honour its contract, it must
know how much space would be needed for the entire escaped buffer, and
string_escape_mem provides no way of obtaining that (short of allocating a
large enough buffer (~4 times input string) to let it play with, and
that's definitely a big no-no inside vsnprintf).

So change the semantics for string_escape_mem to be more snprintf-like:
Return the size of the output that would be generated if the destination
buffer was big enough, but of course still only write to the part of dst
it is allowed to, and (contrary to snprintf) don't do '\0'-termination. 
It is then up to the caller to detect whether output was truncated and to
append a '\0' if desired.  Also, we must output partial escape sequences,
otherwise a call such as snprintf(buf, 3, "%1pE", "\123") would cause
printf to write a \0 to buf[2] but leaving buf[0] and buf[1] with whatever
they previously contained.

This also fixes a bug in the escaped_string() helper function, which used
to unconditionally pass a length of "end-buf" to string_escape_mem();
since the latter doesn't check osz for being insanely large, it would
happily write to dst.  For example, kasprintf(GFP_KERNEL, "something and
then %pE", ...); is an easy way to trigger an oops.

In test-string_helpers.c, the -ENOMEM test is replaced with testing for
getting the expected return value even if the buffer is too small.  We
also ensure that nothing is written (by relying on a NULL pointer deref)
if the output size is 0 by passing NULL - this has to work for
kasprintf("%pE") to work.

In net/sunrpc/cache.c, I think qword_add still has the same semantics. 
Someone should definitely double-check this.

In fs/proc/array.c, I made the minimum possible change, but longer-term it
should stop poking around in seq_file internals.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c                |    4 +-
 include/linux/string_helpers.h |    8 ++---
 lib/string_helpers.c           |   49 ++++---------------------------
 lib/test-string_helpers.c      |   40 ++++++++++++-------------
 lib/vsprintf.c                 |    8 +++--
 net/sunrpc/cache.c             |    8 +++--
 6 files changed, 44 insertions(+), 73 deletions(-)

diff -puN fs/proc/array.c~lib-string_helpersc-change-semantics-of-string_escape_mem fs/proc/array.c
--- a/fs/proc/array.c~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/fs/proc/array.c
@@ -99,8 +99,8 @@ static inline void task_name(struct seq_
 	buf = m->buf + m->count;
 
 	/* Ignore error for now */
-	string_escape_str(tcomm, &buf, m->size - m->count,
-			  ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+	buf += string_escape_str(tcomm, buf, m->size - m->count,
+				 ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
 
 	m->count = buf - m->buf;
 	seq_putc(m, '\n');
diff -puN include/linux/string_helpers.h~lib-string_helpersc-change-semantics-of-string_escape_mem include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/include/linux/string_helpers.h
@@ -47,22 +47,22 @@ static inline int string_unescape_any_in
 #define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
 #define ESCAPE_HEX		0x20
 
-int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
+int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *esc);
 
 static inline int string_escape_mem_any_np(const char *src, size_t isz,
-		char **dst, size_t osz, const char *esc)
+		char *dst, size_t osz, const char *esc)
 {
 	return string_escape_mem(src, isz, dst, osz, ESCAPE_ANY_NP, esc);
 }
 
-static inline int string_escape_str(const char *src, char **dst, size_t sz,
+static inline int string_escape_str(const char *src, char *dst, size_t sz,
 		unsigned int flags, const char *esc)
 {
 	return string_escape_mem(src, strlen(src), dst, sz, flags, esc);
 }
 
-static inline int string_escape_str_any_np(const char *src, char **dst,
+static inline int string_escape_str_any_np(const char *src, char *dst,
 		size_t sz, const char *esc)
 {
 	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, esc);
diff -puN lib/string_helpers.c~lib-string_helpersc-change-semantics-of-string_escape_mem lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/lib/string_helpers.c
@@ -274,11 +274,6 @@ static bool escape_space(unsigned char c
 		return false;
 	}
 
-	if (out + 2 > end) {
-		*dst = out + 2;
-		return true;
-	}
-
 	if (out < end)
 		*out = '\\';
 	++out;
@@ -309,11 +304,6 @@ static bool escape_special(unsigned char
 		return false;
 	}
 
-	if (out + 2 > end) {
-		*dst = out + 2;
-		return true;
-	}
-
 	if (out < end)
 		*out = '\\';
 	++out;
@@ -332,11 +322,6 @@ static bool escape_null(unsigned char c,
 	if (c)
 		return false;
 
-	if (out + 2 > end) {
-		*dst = out + 2;
-		return true;
-	}
-
 	if (out < end)
 		*out = '\\';
 	++out;
@@ -352,11 +337,6 @@ static bool escape_octal(unsigned char c
 {
 	char *out = *dst;
 
-	if (out + 4 > end) {
-		*dst = out + 4;
-		return true;
-	}
-
 	if (out < end)
 		*out = '\\';
 	++out;
@@ -378,11 +358,6 @@ static bool escape_hex(unsigned char c,
 {
 	char *out = *dst;
 
-	if (out + 4 > end) {
-		*dst = out + 4;
-		return true;
-	}
-
 	if (out < end)
 		*out = '\\';
 	++out;
@@ -449,20 +424,17 @@ static bool escape_hex(unsigned char c,
  * it if needs.
  *
  * Return:
- * The amount of the characters processed to the destination buffer, or
- * %-ENOMEM if the size of buffer is not enough to put an escaped character is
- * returned.
- *
- * Even in the case of error @dst pointer will be updated to point to the byte
- * after the last processed character.
+ * The total size of the escaped output that would be generated for
+ * the given input and flags. To check whether the output was
+ * truncated, compare the return value to osz. There is room left in
+ * dst for a '\0' terminator if and only if ret < osz.
  */
-int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
+int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		      unsigned int flags, const char *esc)
 {
-	char *p = *dst;
+	char *p = dst;
 	char *end = p + osz;
 	bool is_dict = esc && *esc;
-	int ret;
 
 	while (isz--) {
 		unsigned char c = *src++;
@@ -502,13 +474,6 @@ int string_escape_mem(const char *src, s
 		escape_passthrough(c, &p, end);
 	}
 
-	if (p > end) {
-		*dst = end;
-		return -ENOMEM;
-	}
-
-	ret = p - *dst;
-	*dst = p;
-	return ret;
+	return p - dst;
 }
 EXPORT_SYMBOL(string_escape_mem);
diff -puN lib/test-string_helpers.c~lib-string_helpersc-change-semantics-of-string_escape_mem lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/lib/test-string_helpers.c
@@ -260,16 +260,28 @@ static __init const char *test_string_fi
 	return NULL;
 }
 
+static __init void
+test_string_escape_overflow(const char *in, int p, unsigned int flags, const char *esc,
+			    int q_test, const char *name)
+{
+	int q_real;
+
+	q_real = string_escape_mem(in, p, NULL, 0, flags, esc);
+	if (q_real != q_test)
+		pr_warn("Test '%s' failed: flags = %u, osz = 0, expected %d, got %d\n",
+			name, flags, q_test, q_real);
+}
+
 static __init void test_string_escape(const char *name,
 				      const struct test_string_2 *s2,
 				      unsigned int flags, const char *esc)
 {
-	int q_real = 512;
-	char *out_test = kmalloc(q_real, GFP_KERNEL);
-	char *out_real = kmalloc(q_real, GFP_KERNEL);
+	size_t out_size = 512;
+	char *out_test = kmalloc(out_size, GFP_KERNEL);
+	char *out_real = kmalloc(out_size, GFP_KERNEL);
 	char *in = kmalloc(256, GFP_KERNEL);
-	char *buf = out_real;
 	int p = 0, q_test = 0;
+	int q_real;
 
 	if (!out_test || !out_real || !in)
 		goto out;
@@ -301,29 +313,19 @@ static __init void test_string_escape(co
 		q_test += len;
 	}
 
-	q_real = string_escape_mem(in, p, &buf, q_real, flags, esc);
+	q_real = string_escape_mem(in, p, out_real, out_size, flags, esc);
 
 	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test,
 			      q_test);
+
+	test_string_escape_overflow(in, p, flags, esc, q_test, name);
+
 out:
 	kfree(in);
 	kfree(out_real);
 	kfree(out_test);
 }
 
-static __init void test_string_escape_nomem(void)
-{
-	char *in = "\eb \\C\007\"\x90\r]";
-	char out[64], *buf = out;
-	int rc = -ENOMEM, ret;
-
-	ret = string_escape_str_any_np(in, &buf, strlen(in), NULL);
-	if (ret == rc)
-		return;
-
-	pr_err("Test 'escape nomem' failed: got %d instead of %d\n", ret, rc);
-}
-
 static int __init test_string_helpers_init(void)
 {
 	unsigned int i;
@@ -342,8 +344,6 @@ static int __init test_string_helpers_in
 	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
 		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
 
-	test_string_escape_nomem();
-
 	return -EINVAL;
 }
 module_init(test_string_helpers_init);
diff -puN lib/vsprintf.c~lib-string_helpersc-change-semantics-of-string_escape_mem lib/vsprintf.c
--- a/lib/vsprintf.c~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/lib/vsprintf.c
@@ -1235,8 +1235,12 @@ char *escaped_string(char *buf, char *en
 
 	len = spec.field_width < 0 ? 1 : spec.field_width;
 
-	/* Ignore the error. We print as many characters as we can */
-	string_escape_mem(addr, len, &buf, end - buf, flags, NULL);
+	/*
+	 * string_escape_mem() writes as many characters as it can to
+	 * the given buffer, and returns the total size of the output
+	 * had the buffer been big enough.
+	 */
+	buf += string_escape_mem(addr, len, buf, buf < end ? end - buf : 0, flags, NULL);
 
 	return buf;
 }
diff -puN net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem
+++ a/net/sunrpc/cache.c
@@ -1068,12 +1068,14 @@ void qword_add(char **bpp, int *lp, char
 {
 	char *bp = *bpp;
 	int len = *lp;
-	int ret;
+	int ret, written;
 
 	if (len < 0) return;
 
-	ret = string_escape_str(str, &bp, len, ESCAPE_OCTAL, "\\ \n\t");
-	if (ret < 0 || ret == len)
+	ret = string_escape_str(str, bp, len, ESCAPE_OCTAL, "\\ \n\t");
+	written = min(ret, len);
+	bp += written;
+	if (ret >= len)
 		len = -1;
 	else {
 		len -= ret;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

