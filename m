From: akpm@linux-foundation.org
Subject: + introduce-explicit-signed-unsigned-64bit-divide.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:34:13 -0700
Message-ID: <200803142034.m2EKYDOv018085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYCNUfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     introduce explicit signed/unsigned 64bit divide
has been added to the -mm tree.  Its filename is
     introduce-explicit-signed-unsigned-64bit-divide.patch

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
Subject: introduce explicit signed/unsigned 64bit divide
From: Roman Zippel <zippel@linux-m68k.org>

The current do_div doesn't explicitly say that it's unsigned and the signed
counterpart is missing, which is e.g.  needed when dealing with time values.

This introduces 64bit signed/unsigned divide functions which also attempts to
cleanup the somewhat awkward calling API, which often requires the use of
temporary variables for the dividend.  To avoid the need for temporary
variables everywhere for the remainder, each divide variant also provides a
version which doesn't return the remainder.

Each architecture can now provide optimized versions of these function,
otherwise generic fallback implementations will be used.

As an example I provided an alternative for the current x86 divide, which
avoids the asm casts and using an union allows gcc to generate better code. 
It also avoids the upper divde in a few more cases, where the result is known
(i.e.  upper quotient is zero).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/div64.h |   20 ++++++++++
 include/linux/math64.h  |   72 ++++++++++++++++++++++++++++++++++++++
 lib/div64.c             |   23 +++++++++++-
 3 files changed, 113 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/div64.h~introduce-explicit-signed-unsigned-64bit-divide include/asm-x86/div64.h
--- a/include/asm-x86/div64.h~introduce-explicit-signed-unsigned-64bit-divide
+++ a/include/asm-x86/div64.h
@@ -50,6 +50,26 @@ div_ll_X_l_rem(long long divs, long div,
 
 }
 
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	union {
+		u64 v64;
+		u32 v32[2];
+	} d = { dividend };
+	u32 upper;
+
+	upper = d.v32[1];
+	d.v32[1] = 0;
+	if (upper >= divisor) {
+		d.v32[1] = upper / divisor;
+		upper %= divisor;
+	}
+	asm ("divl %2" : "=a" (d.v32[0]), "=d" (*remainder) :
+		"rm" (divisor), "0" (d.v32[0]), "1" (upper));
+	return d.v64;
+}
+#define div_u64_rem	div_u64_rem
+
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 
 #else
diff -puN /dev/null include/linux/math64.h
--- /dev/null
+++ a/include/linux/math64.h
@@ -0,0 +1,72 @@
+#ifndef _LINUX_MATH64_H
+#define _LINUX_MATH64_H
+
+#include <linux/types.h>
+#include <asm/div64.h>
+
+#if BITS_PER_LONG == 64
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
+ * div_s64_rem - signed 64bit divide with 32bit divisor with remainder
+ */
+static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+#elif BITS_PER_LONG == 32
+
+#ifndef div_u64_rem
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = do_div(dividend, divisor);
+	return dividend;
+}
+#endif
+
+#ifndef div_s64_rem
+extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
+#endif
+
+#endif /* BITS_PER_LONG */
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+#ifndef div_u64
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	u32 remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+#endif
+
+/**
+ * div_s64 - signed 64bit divide with 32bit divisor
+ */
+#ifndef div_s64
+static inline s64 div_s64(s64 dividend, s32 divisor)
+{
+	s32 remainder;
+	return div_s64_rem(dividend, divisor, &remainder);
+}
+#endif
+
+#endif /* _LINUX_MATH64_H */
diff -puN lib/div64.c~introduce-explicit-signed-unsigned-64bit-divide lib/div64.c
--- a/lib/div64.c~introduce-explicit-signed-unsigned-64bit-divide
+++ a/lib/div64.c
@@ -16,9 +16,8 @@
  * assembly versions such as arch/ppc/lib/div64.S and arch/sh/lib/div64.S.
  */
 
-#include <linux/types.h>
 #include <linux/module.h>
-#include <asm/div64.h>
+#include <linux/math64.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
@@ -58,6 +57,26 @@ uint32_t __attribute__((weak)) __div64_3
 
 EXPORT_SYMBOL(__div64_32);
 
+#ifndef div_s64_rem
+s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
+{
+	u64 quotient;
+
+	if (dividend < 0) {
+		quotient = div_u64_rem(-dividend, abs(divisor), (u32 *)remainder);
+		*remainder = -*remainder;
+		if (divisor > 0)
+			quotient = -quotient;
+	} else {
+		quotient = div_u64_rem(dividend, abs(divisor), (u32 *)remainder);
+		if (divisor < 0)
+			quotient = -quotient;
+	}
+	return quotient;
+}
+EXPORT_SYMBOL(div_s64_rem);
+#endif
+
 /* 64bit divisor, dividend and result. dynamic precision */
 uint64_t div64_64(uint64_t dividend, uint64_t divisor)
 {
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
git-x86.patch
git-watchdog.patch
m68k-replace-remaining-__function__-occurences.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
introduce-explicit-signed-unsigned-64bit-divide.patch
convert-a-few-do_div-user.patch
rename-div64_64-to-div64_u64.patch
rename-div64_64-to-div64_u64-mm.patch
remove-div_long_long_rem.patch

