From: akpm@linux-foundation.org
Subject: + make-div64_u64-precise-on-32bit-platforms.patch added to -mm tree
Date: Thu, 21 Oct 2010 12:22:38 -0700
Message-ID: <201010211922.o9LJMc59030986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772Ab0JUTXW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 15:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: behlendorf1@llnl.gov, bwoodard@llnl.gov, jeremy@goop.org, mgrondona@llnl.gov, oleg@redhat.com


The patch titled
     div64_u64(): improve precision on 32bit platforms
has been added to the -mm tree.  Its filename is
     make-div64_u64-precise-on-32bit-platforms.patch

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
Subject: div64_u64(): improve precision on 32bit platforms
From: Brian Behlendorf <behlendorf1@llnl.gov>

The current implementation of div64_u64 for 32bit systems returns an
approximately correct result when the divisor exceeds 32bits.  Since doing
64bit division using 32bit hardware is a long since solved problem we just
use one of the existing proven methods.

Additionally, add a div64_s64 function to correctly handle doing signed
64bit division.

Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++
 include/linux/math64.h |   12 ++++++++
 lib/div64.c            |   54 +++++++++++++++++++++++++++++++--------
 3 files changed, 60 insertions(+), 11 deletions(-)

diff -puN include/linux/kernel.h~make-div64_u64-precise-on-32bit-platforms include/linux/kernel.h
--- a/include/linux/kernel.h~make-div64_u64-precise-on-32bit-platforms
+++ a/include/linux/kernel.h
@@ -173,6 +173,11 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+#define abs64(x) ({				\
+		s64 __x = (x);			\
+		(__x < 0) ? -__x : __x;		\
+	})
+
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
 #else
diff -puN include/linux/math64.h~make-div64_u64-precise-on-32bit-platforms include/linux/math64.h
--- a/include/linux/math64.h~make-div64_u64-precise-on-32bit-platforms
+++ a/include/linux/math64.h
@@ -35,6 +35,14 @@ static inline u64 div64_u64(u64 dividend
 	return dividend / divisor;
 }
 
+/**
+ * div64_s64 - signed 64bit divide with 64bit divisor
+ */
+static inline s64 div64_s64(s64 dividend, s64 divisor)
+{
+	return dividend / divisor;
+}
+
 #elif BITS_PER_LONG == 32
 
 #ifndef div_u64_rem
@@ -53,6 +61,10 @@ extern s64 div_s64_rem(s64 dividend, s32
 extern u64 div64_u64(u64 dividend, u64 divisor);
 #endif
 
+#ifndef div64_s64
+extern s64 div64_s64(s64 dividend, s64 divisor);
+#endif
+
 #endif /* BITS_PER_LONG */
 
 /**
diff -puN lib/div64.c~make-div64_u64-precise-on-32bit-platforms lib/div64.c
--- a/lib/div64.c~make-div64_u64-precise-on-32bit-platforms
+++ a/lib/div64.c
@@ -77,26 +77,58 @@ s64 div_s64_rem(s64 dividend, s32 diviso
 EXPORT_SYMBOL(div_s64_rem);
 #endif
 
-/* 64bit divisor, dividend and result. dynamic precision */
+/**
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
+ * @dividend:	64bit dividend
+ * @divisor:	64bit divisor
+ *
+ * This implementation is a modified version of the algorithm proposed
+ * by the book 'Hacker's Delight'.  The original source and full proof
+ * can be found here and is available for use without restriction.
+ *
+ * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c'
+ */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
 {
-	u32 high, d;
+	u32 high = divisor >> 32;
+	u64 quot;
 
-	high = divisor >> 32;
-	if (high) {
-		unsigned int shift = fls(high);
-
-		d = divisor >> shift;
-		dividend >>= shift;
-	} else
-		d = divisor;
+	if (high == 0) {
+		quot = div_u64(dividend, divisor);
+	} else {
+		int n = 1 + fls(high);
+		quot = div_u64(dividend >> n, divisor >> n);
+
+		if (quot != 0)
+			quot--;
+		if ((dividend - quot * divisor) >= divisor)
+			quot++;
+	}
 
-	return div_u64(dividend, d);
+	return quot;
 }
 EXPORT_SYMBOL(div64_u64);
 #endif
 
+/**
+ * div64_s64 - signed 64bit divide with 64bit divisor
+ * @dividend:	64bit dividend
+ * @divisor:	64bit divisor
+ */
+#ifndef div64_s64
+s64 div64_s64(s64 dividend, s64 divisor)
+{
+	s64 quot, t;
+
+	quot = div64_u64(abs64(dividend), abs64(divisor));
+	t = (dividend ^ divisor) >> 63;
+
+	return (quot ^ t) - t;
+}
+EXPORT_SYMBOL(div64_s64);
+#endif
+
 #endif /* BITS_PER_LONG == 32 */
 
 /*
_

Patches currently in -mm which might be from behlendorf1@llnl.gov are

make-div64_u64-precise-on-32bit-platforms.patch
lib-div64c-document-that-div64_u64-is-not-precise-on-32bit-platforms.patch

