From: akpm@linux-foundation.org
Subject: + lib-vsprintf-added-a-put_dec-test-and-benchmark-tool.patch added to -mm tree
Date: Thu, 24 Feb 2011 13:51:23 -0800
Message-ID: <201102242151.p1OLpNhf028712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab1BXVvl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 16:51:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mina86@mina86.com, jones@cs.uiowa.edu, vda.linux@googlemail.com


The patch titled
     lib: vsprintf: added a put_dec() test and benchmark tool
has been added to the -mm tree.  Its filename is
     lib-vsprintf-added-a-put_dec-test-and-benchmark-tool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: vsprintf: added a put_dec() test and benchmark tool
From: Michal Nazarewicz <mina86@mina86.com>

Add a test application for the put_dec() and family of functions that are
used by the previous two commits.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Douglas W. Jones <jones@cs.uiowa.edu>
Cc: Denis Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/put-dec/Makefile       |   16 
 tools/put-dec/put-dec-test.c |  927 +++++++++++++++++++++++++++++++++
 2 files changed, 943 insertions(+)

diff -puN /dev/null tools/put-dec/Makefile
--- /dev/null
+++ a/tools/put-dec/Makefile
@@ -0,0 +1,16 @@
+all: put-dec-test put-dec-test-s
+
+put-dec-test: put-dec-test.c
+	exec $(CC) -Wall -Wextra -O2 -o $@ $<
+
+put-dec-test.s: put-dec-test.c
+	exec $(CC) -Wall -Wextra -O2 -S -o $@ $<
+
+put-dec-test-s: put-dec-test.c
+	exec $(CC) -Wall -Wextra -Os -o $@ $<
+
+put-dec-test-s.s: put-dec-test.c
+	exec $(CC) -Wall -Wextra -Os -S -o $@ $<
+
+clean:
+	rm -f -- put-dec-test
diff -puN /dev/null tools/put-dec/put-dec-test.c
--- /dev/null
+++ a/tools/put-dec/put-dec-test.c
@@ -0,0 +1,927 @@
+/*
+ * put-dec-test.c -- Variaus put_dec*() functions implementation
+ *                   testing and benchmarking tool
+ * Written by                  Michal Nazarewicz <mina86@mina86.com>
+ * with helpful suggestions by Denys Vlasenko <vda.linux@googlemail.com>
+ */
+#define _BSD_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#if CHAR_BIT != 8
+#  error This code assumes CHAR_BIT == 8
+#endif
+
+
+#if 0
+#  define __helper  __attribute__((always_inline))
+#  define __8bit    __attribute__((always_inline))
+#else
+#  define __helper  __attribute__((noinline))
+#  define __8bit    __attribute__((noinline))
+#endif
+#define __put_dec __attribute__((noinline))
+
+
+#define do_div(n, base) ({			\
+		uint32_t __base = (base);	\
+		uint32_t __rem = (n) % __base;	\
+		(n) /= __base;			\
+		__rem;				\
+	})
+
+
+/****************************** Original versian ******************************/
+
+static __helper char *orig_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned d3, d2, d1, d0;
+	d1 = (q>>4) & 0xf;
+	d2 = (q>>8) & 0xf;
+	d3 = (q>>12);
+
+	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
+	q = (d0 * 0xcd) >> 11;
+	d0 = d0 - 10*q;
+	*buf++ = d0 + '0'; /* least significant digit */
+	d1 = q + 9*d3 + 5*d2 + d1;
+	if (d1 != 0) {
+		q = (d1 * 0xcd) >> 11;
+		d1 = d1 - 10*q;
+		*buf++ = d1 + '0'; /* next digit */
+
+		d2 = q + 2*d2;
+		if ((d2 != 0) || (d3 != 0)) {
+			q = (d2 * 0xd) >> 7;
+			d2 = d2 - 10*q;
+			*buf++ = d2 + '0'; /* next digit */
+
+			d3 = q + 4*d3;
+			if (d3 != 0) {
+				q = (d3 * 0xcd) >> 11;
+				d3 = d3 - 10*q;
+				*buf++ = d3 + '0';  /* next digit */
+				if (q != 0)
+					*buf++ = q + '0'; /* most sign. digit */
+			}
+		}
+	}
+
+	return buf;
+}
+/* Same with if's removed. Always emits five digits */
+static __helper char *orig_put_dec_full(char *buf, unsigned q)
+{
+	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
+	/* but anyway, gcc produces better code with full-sized ints */
+	unsigned d3, d2, d1, d0;
+	d1 = (q>>4) & 0xf;
+	d2 = (q>>8) & 0xf;
+	d3 = (q>>12);
+
+	/*
+	 * Possible ways to approx. divide by 10
+	 * gcc -O2 replaces multiply with shifts and adds
+	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+	 * (x * 0x67) >> 10:  1100111
+	 * (x * 0x34) >> 9:    110100 - same
+	 * (x * 0x1a) >> 8:     11010 - same
+	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 */
+	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
+	q = (d0 * 0xcd) >> 11;
+	d0 = d0 - 10*q;
+	*buf++ = d0 + '0';
+	d1 = q + 9*d3 + 5*d2 + d1;
+		q = (d1 * 0xcd) >> 11;
+		d1 = d1 - 10*q;
+		*buf++ = d1 + '0';
+
+		d2 = q + 2*d2;
+			q = (d2 * 0xd) >> 7;
+			d2 = d2 - 10*q;
+			*buf++ = d2 + '0';
+
+			d3 = q + 4*d3;
+				q = (d3 * 0xcd) >> 11; /* - shorter code */
+				/* q = (d3 * 0x67) >> 10; - would also work */
+				d3 = d3 - 10*q;
+				*buf++ = d3 + '0';
+					*buf++ = q + '0';
+
+	return buf;
+}
+
+static __put_dec char *orig_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return orig_put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = orig_put_dec_full(buf, rem);
+	}
+}
+
+
+
+/****************************** Modified versions ******************************/
+
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using code based on idea described at:
+ * http://www.cs.uiowa.edu/~jones/bcd/decimal.html (with permission
+ * from the author, Douglas W. Jones).
+ *
+ * The original code was designed for 8-bit ALus but since we can
+ * assume more capable hardware the code has been rewritten to use the
+ * following properties:
+ *
+ * n  =    1 * n0 +                   ( 0 <= n0 <= 1023 )
+ *      1024 * n1                     ( 0 <= n1 <=   97 )
+ * a0 = 0         + 4 * n1 + 1 * n0   ( 0 <= a0 <= 1412 )
+ * a1 = (a0 / 10) + 2 * n1            ( 0 <= a1 <=  335 )
+ * a2 = (a1 / 10) + 0 * n1            ( 0 <= a2 <=   33 )
+ * a3 = (a2 / 10) + 1 * n1            ( 0 <= a3 <=  100 )
+ * d0 = a0 % 10
+ * d1 = a1 % 10
+ * d2 = a2 % 10
+ * d3 = a3 % 10
+ * d4 = a3 / 10
+ *
+ * So instead of dividing the number into four nibles we divide it
+ * into two numbers: first one 10-bit and the other one 7-bit
+ * (argument is 17-bit number from 0 to 99999).
+ *
+ * Moreover, 1024, which is the value second part of the number needs
+ * to be multiplied by, has nice property that each digit is a power
+ * of two or zero -- this helps with multiplications.
+ *
+ * Possible ways to approx. divide by 10
+ * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+ * (x * 0x67) >> 10:  1100111
+ * (x * 0x34) >> 9:    110100 - same
+ * (x * 0x1a) >> 8:     11010 - same
+ * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+ */
+static __helper char *mod1_put_dec_full(char *buf, unsigned q)
+{
+	unsigned p, r;
+	p   = q >> 10;
+
+	q  &= 0x3ff;
+	q  += 4 * p;
+	r   = (q * 0x199A) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	r  += 2 * p;
+	q   = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q)  + '0';
+
+	/* q += 0; */
+	r   = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	r  += p;
+	q   = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + '0';
+
+	return buf;
+}
+
+static __helper char *mod1_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned p, r;
+	p   = q >> 10;
+
+	q  &= 0x3ff;
+	q  += 4 * p;
+	r   = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	r  += 2 * p;
+	if (r) {
+		q   = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		/* q += 0; */
+		if (q || p) {
+			r   = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			r  += p;
+			if (r) {
+				q   = (r * 0xcd) >> 11;
+				*buf++ = (r - 10 * q) + '0';
+
+				if (q)
+					*buf++ = q + '0';
+			}
+		}
+	}
+
+	return buf;
+}
+
+
+static __put_dec char *mod1_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return mod1_put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = mod1_put_dec_full(buf, rem);
+	}
+}
+
+
+static __put_dec char *mod2_put_dec(char *buf, unsigned long long num)
+{
+	if (!num) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	while (num >= 100000) {
+		unsigned rem;
+		rem = do_div(num, 100000);
+		buf = mod1_put_dec_full(buf, rem);
+	}
+
+	buf = mod1_put_dec_full(buf, num);
+	while (buf[-1] == '0')
+		--buf;
+	return buf;
+}
+
+
+
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using ideas described at
+ * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+ *
+ * '(num * 0xcccd) >> 19' is an approximation of 'num / 10' that gives
+ * correct results for num < 81920.  Because of this, we check at the
+ * beginning if we are dealing with a number that may cause trouble
+ * and if so, we make it smaller.
+ *
+ * (As a minor note, all operands are always 16 bit so this function
+ * should work well on hardware that cannot multiply 32 bit numbers).
+ *
+ * (Previous a code based on
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html> was used here,
+ * with permission from the author, Douglas W. Jones.)
+ *
+ * Other, possible ways to approx. divide by 10
+ * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+ * (x * 0x67) >> 10:  1100111
+ * (x * 0x34) >> 9:    110100 - same
+ * (x * 0x1a) >> 8:     11010 - same
+ * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+ */
+static __helper char *mod3_put_dec_full(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * (uint64_t)0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + '0';
+
+	return buf;
+}
+
+static __helper char *mod3_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned r;
+
+	if (q > 9999)
+		return mod3_put_dec_full(buf, q);
+
+	r      = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r)  + '0';
+
+	if (r) {
+		q   = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r      = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
+		}
+	}
+
+	return buf;
+}
+
+
+static __8bit char *mod3_put_dec_8bit(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q   = (r * 0xd) >> 7;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q)
+			*buf++ = q + '0';
+	}
+
+	return buf;
+}
+
+
+static __put_dec char *mod3_put_dec(char *buf, unsigned long long num)
+{
+	while (num >= 100000)
+		buf = mod3_put_dec_full(buf, do_div(num, 100000));
+	return mod3_put_dec_trunc(buf, num);
+}
+
+
+static __put_dec char *mod4_put_dec(char *buf, unsigned long long num)
+{
+	if (!num) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	while (num >= 100000) {
+		unsigned rem;
+		rem = do_div(num, 100000);
+		buf = mod3_put_dec_full(buf, rem);
+	}
+
+	buf = mod3_put_dec_full(buf, num);
+	while (buf[-1] == '0')
+		--buf;
+	return buf;
+}
+
+
+
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running.
+ *
+ * We optimize it for speed using ideas described at
+ * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+ *
+ * (Previous a code based on
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html> was used here,
+ * with permission from the author, Douglas W. Jones.)
+ *
+ * Other, possible ways to approx. divide by 10
+ * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+ * (x * 0x67) >> 10:  1100111
+ * (x * 0x34) >> 9:    110100 - same
+ * (x * 0x1a) >> 8:     11010 - same
+ * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+ */
+static __helper char *mod5_put_dec_full(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	*buf++ = r + '0';
+
+	return buf;
+}
+
+static __helper char *mod5_put_dec_trunc(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q      = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r      = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
+		}
+	}
+
+	return buf;
+}
+
+
+static __put_dec char *mod5_put_dec(char *buf, unsigned long long num)
+{
+	while (num >= 10000) {
+		unsigned rem;
+		rem = do_div(num, 10000);
+		buf = mod5_put_dec_full(buf, rem);
+	}
+	return mod5_put_dec_trunc(buf, num);
+}
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html>.
+ */
+static __put_dec char *mod6_put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q;
+
+	if (!n) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	d1  = (n >> 16) & 0xFFFF;
+	d2  = (n >> 32) & 0xFFFF;
+	d3  = (n >> 48) & 0xFFFF;
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+
+	buf = mod5_put_dec_full(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+		buf = mod5_put_dec_full(buf, d1 % 10000);
+		q   = d1 / 10000;
+
+		d2  = q + 4749 * d3 + 42 * d2;
+			buf = mod5_put_dec_full(buf, d2 % 10000);
+			q   = d2 / 10000;
+
+			d3  = q + 281 * d3;
+				buf = mod5_put_dec_full(buf, d3 % 10000);
+				q   = d3 / 10000;
+
+					buf = mod5_put_dec_trunc(buf, q);
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
+}
+
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html>.
+ */
+static __put_dec char *mod7_put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q;
+
+	if (!n) {
+		*buf++ = '0';
+		return buf;
+	}
+
+	d1  = (n >> 16) & 0xFFFF;
+	d2  = (n >> 32) & 0xFFFF;
+	d3  = (n >> 48) & 0xFFFF;
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+
+	buf = mod5_put_dec_full(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	if (d1) {
+		buf = mod5_put_dec_full(buf, d1 % 10000);
+		q   = d1 / 10000;
+
+		d2  = q + 4749 * d3 + 42 * d2;
+		if (d2) {
+			buf = mod5_put_dec_full(buf, d2 % 10000);
+			q   = d2 / 10000;
+
+			d3  = q + 281 * d3;
+			if (d3) {
+				buf = mod5_put_dec_full(buf, d3 % 10000);
+				q   = d3 / 10000;
+
+				if (q)
+					buf = mod5_put_dec_trunc(buf, q);
+			}
+		}
+	}
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
+}
+
+
+static __put_dec char *mod8_put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem = do_div(num, 100000000);
+
+		if (!num && rem < 10000)
+			return mod5_put_dec_trunc(buf, rem);
+		buf = mod5_put_dec_full(buf, rem % 10000);
+
+		if (!num)
+			return mod5_put_dec_trunc(buf, rem / 10000);
+		buf = mod5_put_dec_full(buf, rem / 10000);
+	}
+}
+
+
+
+/****************************** Main ******************************/
+
+static const struct put_dec_helper {
+	const char *name;
+	char *(*func)(char *buf, unsigned v);
+	unsigned inner;
+	unsigned outer;
+	int width;
+} put_dec_helpers[] = {
+	{ "orig_put_dec_full" , orig_put_dec_full , 100000,   1, 5 },
+	{ "mod1_put_dec_full" , mod1_put_dec_full , 100000,   1, 5 },
+	{ "mod3_put_dec_full" , mod3_put_dec_full , 100000,   1, 5 },
+	{ "mod5_put_dec_full" , mod5_put_dec_full ,  10000,  10, 4 },
+	{ "orig_put_dec_trunc", orig_put_dec_trunc, 100000,   1, 0 },
+	{ "mod1_put_dec_trunc", mod1_put_dec_trunc, 100000,   1, 0 },
+	{ "mod3_put_dec_trunc", mod3_put_dec_trunc, 100000,   1, 0 },
+	{ "mod5_put_dec_trunc", mod5_put_dec_trunc,  10000,  10, 0 },
+	{ "mod3_put_dec_8bit",  mod3_put_dec_8bit,     256, 500, 0 },
+	{ NULL, NULL, 0, 0, 0 }
+};
+
+static const struct put_dec {
+	const char *name;
+	char *(*func)(char *buf, unsigned long long v);
+} put_decs[] = {
+	{ "orig_put_dec" , orig_put_dec },
+	{ "mod1_put_dec" , mod1_put_dec },
+	{ "mod2_put_dec" , mod2_put_dec },
+	{ "mod3_put_dec" , mod3_put_dec },
+	{ "mod4_put_dec" , mod4_put_dec },
+	{ "mod5_put_dec" , mod5_put_dec },
+	{ "mod6_put_dec" , mod6_put_dec },
+	{ "mod7_put_dec" , mod7_put_dec },
+	{ "mod8_put_dec" , mod8_put_dec },
+	{ NULL, NULL }
+};
+
+
+/* 41 / 17 is around (a bit more then) log_10(256) */
+#define WIDTH (int)(sizeof(long long) * 41 / 17 + 1)
+static char buf_output[WIDTH + 1], buf_expected[WIDTH + 1];
+
+
+static bool load_random(const char *file);
+static void benchmark_helpers(unsigned long iterations);
+static void benchmark_put_dec(unsigned long iterations);
+static void show_sizes(char *app);
+static bool test_helpers(void);
+static bool test_put_dec_rand(void);
+static bool test_put_dec_range(unsigned long long range);
+
+
+int main(int argc, char **argv) {
+	unsigned long iterations;
+	unsigned long long range;
+	bool ret;
+
+	puts(">> Reading etropy...");
+	fflush(NULL);
+
+	if (!load_random("/dev/urandom"))
+		return 2;
+
+	iterations = 1000;
+	if (argc > 1)
+		iterations = atoi(argv[1]);
+
+	if (iterations) {
+		puts(">> Benchmarking...");
+		fflush(NULL);
+
+		benchmark_helpers(iterations);
+		benchmark_put_dec(iterations * 25000);
+	}
+
+	puts(">> Sizes");
+	show_sizes(*argv);
+
+	puts(">> Testing...");
+	fflush(NULL);
+
+	memset(buf_output, 77, sizeof buf_output);
+
+	range = 10*1000*1000;
+	if (argc > 2)
+		range = atoi(argv[2]);
+
+	ret = test_helpers();
+	ret = test_put_dec_rand() && ret;
+	if (range)
+		ret = test_put_dec_range(range) && ret;
+
+	printf(">> %s%*s\n",
+	       ret
+	     ? "Everything went fine"
+	     : "Some test failed, consult stderr",
+	       WIDTH, "");
+
+	return ret;
+}
+
+
+static bool test(const char *name, char *b, char *fmt, ...);
+static void stop(const char *name, struct timeval *start);
+
+static unsigned long long __random[1 << 20];
+static inline unsigned long long randll(unsigned n) {
+	return __random[n & ((sizeof __random / sizeof *__random) - 1)];
+}
+
+
+static bool load_random(const char *file)
+{
+	size_t left, pos;
+	bool ret = true;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		perror(file);
+		return false;
+	}
+
+	left = sizeof __random;
+	pos = 0;
+	do {
+		ssize_t r = read(fd, ((char *)__random) + pos, left);
+		if (r > 0) {
+			pos  += r;
+			left -= r;
+		} else if (r == 0) {
+			printf("%s: file too small\n", file);
+			ret = false;
+			break;
+		} else if (errno == EAGAIN || errno == EINTR) {
+			/* nothing */
+		} else {
+			perror(file);
+			ret = false;
+			break;
+		}
+	} while (left);
+
+	close(fd);
+	return ret;
+}
+
+
+static void benchmark_helpers(unsigned long iterations)
+{
+	const struct put_dec_helper *helper = put_dec_helpers;
+
+	printf("\thelpers (%lu iterations)\n", iterations * 100000);
+	fflush(NULL);
+
+	do {
+		char *(*func)(char *buf, unsigned v);
+		struct timeval start;
+		unsigned long o;
+		unsigned inner;
+
+		func = helper->func;
+		o = helper->outer * iterations;
+		inner = helper->inner;
+		gettimeofday(&start, NULL);
+
+		do {
+			unsigned i = inner;
+			do {
+				func(buf_output, i);
+			} while (--i);
+		} while (--o);
+
+		stop(helper->name, &start);
+		++helper;
+	} while (helper->name);
+
+	fflush(NULL);
+}
+
+static void benchmark_put_dec(unsigned long iterations)
+{
+	const struct put_dec *pd = put_decs;
+
+	printf("\tput_dec (%lu iterations)\n", iterations);
+	fflush(NULL);
+
+	do {
+		char *(*func)(char *buf, unsigned long long v);
+		struct timeval start;
+		unsigned long i;
+
+		func = pd->func;
+		i = iterations;
+		gettimeofday(&start, NULL);
+
+		do {
+			func(buf_output, randll(--i));
+		} while (i);
+
+		stop(pd->name, &start);
+		++pd;
+	} while (pd->name);
+
+	fflush(NULL);
+}
+
+static void show_sizes(char *app)
+{
+	setenv("APP", app, 1);
+	printf("\tobjdump -t '%s' | grep -F _put_dec | cut -f 2-\n", app);
+	fflush(NULL);
+	system("objdump -t \"$APP\" | grep -F _put_dec | cut -f 2-");
+}
+
+static bool test_helpers(void)
+{
+	const struct put_dec_helper *helper = put_dec_helpers;
+	bool ret = true;
+
+	puts("\thelpers");
+	fflush(NULL);
+
+	do {
+		unsigned i = helper->inner;
+
+		do {
+			--i;
+
+			ret = test(helper->name, helper->func(buf_output, i),
+				   "%0*u", helper->width, i) && ret;
+		} while (i);
+
+		++helper;
+	} while (helper->name);
+
+	fflush(NULL);
+
+	return ret;
+}
+
+static bool __test_put_dec(unsigned long long v, bool print)
+{
+	const struct put_dec *pd = put_decs;
+	bool ret = true;
+
+	sprintf(buf_expected, "%llu", v);
+
+	if (print) {
+		printf("\ttesting: %*s\r", WIDTH, buf_expected);
+		fflush(NULL);
+	}
+
+	do {
+		ret = test(pd->name, pd->func(buf_output, v), NULL) && ret;
+		++pd;
+	} while (pd->name);
+
+	return ret;
+}
+
+static bool test_put_dec_rand(void)
+{
+	size_t i = sizeof __random / sizeof *__random;
+	bool ret = true;
+
+	printf("\tput_dec, %zu random numbers\n", i);
+	fflush(NULL);
+
+	do {
+		--i;
+		ret = __test_put_dec(randll(i), !(i & 0xffff)) && ret;
+	} while (i);
+
+	return ret;
+}
+
+static bool test_put_dec_range(unsigned long long range)
+{
+	unsigned long long edge = 1;
+	bool ret = true;
+
+	printf("\tput_dec, %llu numbers around the \"edges\"%10s\n", range, "");
+	fflush(NULL);
+
+	do {
+		unsigned long long i = 2 * range, v = edge - range;
+		do {
+			ret = __test_put_dec(v, !(i & 0xffff)) && ret;
+			++v;
+		} while (--i);
+
+		edge <<= 16;
+	} while (edge);
+
+	return ret;
+}
+
+
+static bool test(const char *name, char *b, char *fmt, ...)
+{
+	char *a = buf_output;
+	va_list ap;
+	bool ret;
+
+	*b-- = '\0';
+	while (a < b) {
+		char tmp = *a;
+		*a = *b;
+		*b = tmp;
+		++a;
+		--b;
+	}
+
+	if (fmt) {
+		va_start(ap, fmt);
+		vsprintf(buf_expected, fmt, ap);
+		va_end(ap);
+	}
+
+	ret = !strcmp(buf_output, buf_expected);
+	if (!ret)
+		fprintf(stderr, "%-20s: expecting %*s got %*s\n",
+			name, WIDTH, buf_expected, WIDTH, buf_output);
+
+	memset(buf_output, 77, sizeof buf_output);
+
+	return ret;
+}
+
+static void stop(const char *name, struct timeval *start)
+{
+	struct timeval stop;
+	gettimeofday(&stop, NULL);
+
+	stop.tv_sec -= start->tv_sec;
+	if (stop.tv_usec < start->tv_usec) {
+		--stop.tv_sec;
+		stop.tv_usec += 1000000;
+	}
+	stop.tv_usec -= start->tv_usec;
+
+	fflush(NULL);
+	printf("%-20s: %3lu.%06lus\n", name,
+	       (unsigned long)stop.tv_sec, (unsigned long)stop.tv_usec);
+}
_

Patches currently in -mm which might be from mina86@mina86.com are

lib-vsprintf-optimised-put_dec-function.patch
lib-vsprintf-added-a-put_dec-test-and-benchmark-tool.patch

