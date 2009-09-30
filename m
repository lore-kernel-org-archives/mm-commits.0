From: akpm@linux-foundation.org
Subject: + mn10300-fix-kernel-build-failures-when-using-gcc-4x.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:10:36 -0700
Message-ID: <200909302310.n8UNAbpl022874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbZI3XKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msalter@redhat.com, dhowells@redhat.com


The patch titled
     mn10300: fix kernel build failures when using gcc-4.x
has been added to the -mm tree.  Its filename is
     mn10300-fix-kernel-build-failures-when-using-gcc-4x.patch

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
Subject: mn10300: fix kernel build failures when using gcc-4.x
From: Mark Salter <msalter@redhat.com>

Fix some build failures when using gcc-4.x for MN10300.

Firstly, __get_user() fails to build because the pointer points to a const and
__gu_val ends up being read-only:

In file included from include/linux/mempolicy.h:62,
                 from init/main.c:50:
include/linux/pagemap.h: In function 'fault_in_pages_readable':
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
make[1]: *** [init/main.o] Error 1

Secondly, gcc-4 doesn't allow casts of lvalues:

  UPD     include/linux/compile.h
arch/mn10300/kernel/rtc.c: In function 'calibrate_clock':
arch/mn10300/kernel/rtc.c:170: error: lvalue required as left operand of assignment
arch/mn10300/kernel/rtc.c:172: error: lvalue required as left operand of assignment
make[1]: *** [arch/mn10300/kernel/rtc.o] Error 1

These are seen with gcc 4.2.1.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/uaccess.h             |   73 ++++++++-------
 arch/mn10300/unit-asb2303/include/unit/clock.h |    6 -
 arch/mn10300/unit-asb2305/include/unit/clock.h |    6 -
 3 files changed, 45 insertions(+), 40 deletions(-)

diff -puN arch/mn10300/include/asm/uaccess.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x arch/mn10300/include/asm/uaccess.h
--- a/arch/mn10300/include/asm/uaccess.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x
+++ a/arch/mn10300/include/asm/uaccess.h
@@ -129,42 +129,47 @@ extern int fixup_exception(struct pt_reg
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct *)(x))
 
-#define __get_user_nocheck(x, ptr, size)	\
-({						\
-	__typeof(*(ptr)) __gu_val;		\
-	unsigned long __gu_addr;		\
-	int __gu_err;				\
-	__gu_addr = (unsigned long) (ptr);	\
-	switch (size) {				\
-	case 1:  __get_user_asm("bu"); break;	\
-	case 2:  __get_user_asm("hu"); break;	\
-	case 4:  __get_user_asm(""  ); break;	\
-	default: __get_user_unknown(); break;	\
-	}					\
-	x = (__typeof__(*(ptr))) __gu_val;	\
-	__gu_err;				\
+#define __get_user_nocheck(x, ptr, size)				\
+({									\
+	unsigned long __gu_addr;					\
+	int __gu_err;							\
+	__gu_addr = (unsigned long) (ptr);				\
+	switch (size) {							\
+	case 1: {							\
+		unsigned char __gu_val;					\
+		__get_user_asm("bu");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	case 2: {							\
+		unsigned short __gu_val;				\
+		__get_user_asm("hu");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	case 4: {							\
+		unsigned int __gu_val;					\
+		__get_user_asm("");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	default:							\
+		__get_user_unknown();					\
+		break;							\
+	}								\
+	__gu_err;							\
 })
 
-#define __get_user_check(x, ptr, size)			\
-({							\
-	__typeof__(*(ptr)) __gu_val;			\
-	unsigned long __gu_addr;			\
-	int __gu_err;					\
-	__gu_addr = (unsigned long) (ptr);		\
-	if (likely(__access_ok(__gu_addr,size))) {	\
-		switch (size) {				\
-		case 1:  __get_user_asm("bu"); break;	\
-		case 2:  __get_user_asm("hu"); break;	\
-		case 4:  __get_user_asm(""  ); break;	\
-		default: __get_user_unknown(); break;	\
-		}					\
-	}						\
-	else {						\
-		__gu_err = -EFAULT;			\
-		__gu_val = 0;				\
-	}						\
-	x = (__typeof__(*(ptr))) __gu_val;		\
-	__gu_err;					\
+#define __get_user_check(x, ptr, size)					\
+({									\
+	int _e;								\
+	if (likely(__access_ok((unsigned long) (ptr), (size))))		\
+		_e = __get_user_nocheck((x), (ptr), (size));		\
+	else {								\
+		_e = -EFAULT;						\
+		(x) = (__typeof__(x))0;					\
+	}								\
+	_e;								\
 })
 
 #define __get_user_asm(INSN)					\
diff -puN arch/mn10300/unit-asb2303/include/unit/clock.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x arch/mn10300/unit-asb2303/include/unit/clock.h
--- a/arch/mn10300/unit-asb2303/include/unit/clock.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x
+++ a/arch/mn10300/unit-asb2303/include/unit/clock.h
@@ -20,9 +20,9 @@ extern unsigned long mn10300_ioclk;	/* I
 extern unsigned long mn10300_iobclk;
 extern unsigned long mn10300_tsc_per_HZ;
 
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+#define MN10300_IOCLK		mn10300_ioclk
 /* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+/* #define MN10300_IOBCLK	mn10300_iobclk */
 
 #else /* !CONFIG_MN10300_RTC */
 
@@ -35,7 +35,7 @@ extern unsigned long mn10300_tsc_per_HZ;
 #define MN10300_TSCCLK		MN10300_IOCLK
 
 #ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
 #else /* !CONFIG_MN10300_RTC */
 #define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
 #endif /* !CONFIG_MN10300_RTC */
diff -puN arch/mn10300/unit-asb2305/include/unit/clock.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x arch/mn10300/unit-asb2305/include/unit/clock.h
--- a/arch/mn10300/unit-asb2305/include/unit/clock.h~mn10300-fix-kernel-build-failures-when-using-gcc-4x
+++ a/arch/mn10300/unit-asb2305/include/unit/clock.h
@@ -20,9 +20,9 @@ extern unsigned long mn10300_ioclk;	/* I
 extern unsigned long mn10300_iobclk;
 extern unsigned long mn10300_tsc_per_HZ;
 
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+#define MN10300_IOCLK		mn10300_ioclk
 /* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+/* #define MN10300_IOBCLK	mn10300_iobclk */
 
 #else /* !CONFIG_MN10300_RTC */
 
@@ -35,7 +35,7 @@ extern unsigned long mn10300_tsc_per_HZ;
 #define MN10300_TSCCLK		MN10300_IOCLK
 
 #ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
 #else /* !CONFIG_MN10300_RTC */
 #define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
 #endif /* !CONFIG_MN10300_RTC */
_

Patches currently in -mm which might be from msalter@redhat.com are

mn10300-fix-kernel-build-failures-when-using-gcc-4x.patch

