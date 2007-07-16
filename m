From: akpm@linux-foundation.org
Subject: - vsprintfc-optimizing-part-2-base-10-conversion-speedup-v2.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:33 -0700
Message-ID: <200707162059.l6GKxX8Z002436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762693AbXGPVPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jones@cs.uiowa.edu, mm-commits@vger.kernel.org


The patch titled
     vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
has been removed from the -mm tree.  Its filename was
     vsprintfc-optimizing-part-2-base-10-conversion-speedup-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
From: Denis Vlasenko <vda.linux@googlemail.com>

Optimize integer-to-string conversion in vsprintf.c for base 10.  This is
by far the most used conversion, and in some use cases it impacts
performance.  For example, top reads /proc/$PID/stat for every process, and
with 4000 processes decimal conversion alone takes noticeable time.

Using code from

http://www.cs.uiowa.edu/~jones/bcd/decimal.html
(with permission from the author, Douglas W. Jones)

binary-to-decimal-string conversion is done in groups of five digits at
once, using only additions/subtractions/shifts (with -O2; -Os throws in
some multiply instructions).

On i386 arch gcc 4.1.2 -O2 generates ~500 bytes of code.

This patch is run tested. Userspace benchmark/test is also attached.
I tested it on PIII and AMD64 and new code is generally ~2.5 times
faster. On AMD64:

# ./vsprintf_verify-O2
Original decimal conv: .......... 151 ns per iteration
Patched decimal conv:  .......... 62 ns per iteration
Testing correctness
12895992590592 ok...        [Ctrl-C]
# ./vsprintf_verify-O2
Original decimal conv: .......... 151 ns per iteration
Patched decimal conv:  .......... 62 ns per iteration
Testing correctness
26025406464 ok...        [Ctrl-C]

More realistic test: top from busybox project was modified to
report how many us it took to scan /proc (this does not account
any processing done after that, like sorting process list),
and then I test it with 4000 processes:

#!/bin/sh
i=4000
while test $i != 0; do
    sleep 30 &
    let i--
done
busybox top -b -n3 >/dev/null

on unpatched kernel:

top: 4120 processes took 102864 microseconds to scan
top: 4120 processes took 91757 microseconds to scan
top: 4120 processes took 92517 microseconds to scan
top: 4120 processes took 92581 microseconds to scan

on patched kernel:

top: 4120 processes took 75460 microseconds to scan
top: 4120 processes took 66451 microseconds to scan
top: 4120 processes took 67267 microseconds to scan
top: 4120 processes took 67618 microseconds to scan

The speedup comes from much faster generation of /proc/PID/stat
by sprintf() calls inside the kernel.

Signed-off-by: Douglas W Jones <jones@cs.uiowa.edu>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |  108 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~vsprintfc-optimizing-part-2-base-10-conversion-speedup-v2 lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintfc-optimizing-part-2-base-10-conversion-speedup-v2
+++ a/lib/vsprintf.c
@@ -135,6 +135,103 @@ static int skip_atoi(const char **s)
 	return i;
 }
 
+/* Decimal conversion is by far the most typical, and is used
+ * for /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running. We optimize it for speed
+ * using code from
+ * http://www.cs.uiowa.edu/~jones/bcd/decimal.html
+ * (with permission from the author, Douglas W. Jones). */
+
+/* Formats correctly any integer in [0,99999].
+ * Outputs from one to five digits depending on input.
+ * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
+static char* put_dec_trunc(char *buf, unsigned q)
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
+					*buf++ = q + '0';  /* most sign. digit */
+			}
+		}
+	}
+	return buf;
+}
+/* Same with if's removed. Always emits five digits */
+static char* put_dec_full(char *buf, unsigned q)
+{
+	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
+	/* but anyway, gcc produces better code with full-sized ints */
+	unsigned d3, d2, d1, d0;
+	d1 = (q>>4) & 0xf;
+	d2 = (q>>8) & 0xf;
+	d3 = (q>>12);
+
+	/* Possible ways to approx. divide by 10 */
+	/* gcc -O2 replaces multiply with shifts and adds */
+	// (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+	// (x * 0x67) >> 10:  1100111
+	// (x * 0x34) >> 9:    110100 - same
+	// (x * 0x1a) >> 8:     11010 - same
+	// (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+
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
+	return buf;
+}
+/* No inlining helps gcc to use registers better */
+static noinline char* put_dec(char *buf, unsigned long long num)
+{
+	while (1) {
+		unsigned rem;
+		if (num < 100000)
+			return put_dec_trunc(buf, num);
+		rem = do_div(num, 100000);
+		buf = put_dec_full(buf, rem);
+	}
+}
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
@@ -182,6 +279,11 @@ static char *number(char *buf, char *end
 	i = 0;
 	if (num == 0)
 		tmp[i++] = '0';
+	/* Generic code, for any base:
+	else do {
+		tmp[i++] = digits[do_div(num,base)];
+	} while (num != 0);
+	*/
 	else if (base != 10) { /* 8 or 16 */
 		int mask = base - 1;
 		int shift = 3;
@@ -190,9 +292,9 @@ static char *number(char *buf, char *end
 			tmp[i++] = digits[((unsigned char)num) & mask];
 			num >>= shift;
 		} while (num);
-	} else do { /* generic code, works for any base */
-		tmp[i++] = digits[do_div(num,10 /*base*/)];
-	} while (num);
+	} else { /* base 10 */
+		i = put_dec(tmp, num) - tmp;
+	}
 
 	/* printing 100 using %2d gives "100", not "00" */
 	if (i > precision)
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
