From: akpm@linux-foundation.org
Subject: + add-an-inlined-version-of-iter_div_u64_rem.patch added to -mm tree
Date: Thu, 15 May 2008 16:03:30 -0700
Message-ID: <200805152303.m4FN3UGM015046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbYEOXFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, andi@firstfloor.org, hancockr@shaw.ca, jeremy.fitzhardinge@citrix.com, johnstul@us.ibm.com, lists@nerdbynature.de, mingo@elte.hu, segher@kernel.crashing.org, tglx@linutronix.de


The patch titled
     add an inlined version of iter_div_u64_rem
has been added to the -mm tree.  Its filename is
     add-an-inlined-version-of-iter_div_u64_rem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add an inlined version of iter_div_u64_rem
From: Jeremy Fitzhardinge <jeremy@goop.org>

iter_div_u64_rem is used in the x86-64 vdso, which cannot call other
kernel code.  For this case, provide the always_inlined version,
__iter_div_u64_rem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math64.h |   19 +++++++++++++++++++
 lib/div64.c            |   15 +--------------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff -puN include/linux/math64.h~add-an-inlined-version-of-iter_div_u64_rem include/linux/math64.h
--- a/include/linux/math64.h~add-an-inlined-version-of-iter_div_u64_rem
+++ a/include/linux/math64.h
@@ -83,4 +83,23 @@ static inline s64 div_s64(s64 dividend, 
 
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
 
+static __always_inline u32
+__iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
+{
+	u32 ret = 0;
+
+	while (dividend >= divisor) {
+		/* The following asm() prevents the compiler from
+		   optimising this loop into a modulo operation.  */
+		asm("" : "+rm"(dividend));
+
+		dividend -= divisor;
+		ret++;
+	}
+
+	*remainder = dividend;
+
+	return ret;
+}
+
 #endif /* _LINUX_MATH64_H */
diff -puN lib/div64.c~add-an-inlined-version-of-iter_div_u64_rem lib/div64.c
--- a/lib/div64.c~add-an-inlined-version-of-iter_div_u64_rem
+++ a/lib/div64.c
@@ -105,19 +105,6 @@ EXPORT_SYMBOL(div64_u64);
  */
 u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 {
-	u32 ret = 0;
-
-	while (dividend >= divisor) {
-		/* The following asm() prevents the compiler from
-		   optimising this loop into a modulo operation.  */
-		asm("" : "+rm"(dividend));
-
-		dividend -= divisor;
-		ret++;
-	}
-
-	*remainder = dividend;
