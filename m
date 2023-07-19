Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF0DC0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 20:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjGSUDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjGSUDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 16:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75AC1FD9
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 13:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 536256181D
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 20:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE86C433CB;
        Wed, 19 Jul 2023 20:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689797008;
        bh=7FX44G4fnJbGjdSFkJI/LGlsblIkYR5WrA+tzD6OB2E=;
        h=Date:To:From:Subject:From;
        b=dOeTUjHd1DXJPNMjRlX1IewSrwMZaqZiD7l7lB7tRqTcY1EO+N8mVaxZNdxIq395J
         Pw8lDhk6wwaoQOmfEoelfRa1w1c57RYOEW75JTEq2XdkHFTa2zpHVEF5/YfM2FnHJy
         CtRlEFrSiWBor/D5RpbgvjNF3IbupRMftYrbvHYA=
Date:   Wed, 19 Jul 2023 13:03:27 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sudeep.holla@arm.com, skhan@linuxfoundation.org,
        rostedt@goodmis.org, mingo@redhat.com, mhiramat@kernel.org,
        mark.rutland@arm.com, lpieralisi@kernel.org, hpa@zytor.com,
        dlatypov@google.com, davidgow@google.com,
        dave.hansen@linux.intel.com, brendan.higgins@linux.dev,
        bp@alien8.de, bhelgaas@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-smccc-replace-custom-count_args-concatenate-implementations.patch added to mm-nonmm-unstable branch
Message-Id: <20230719200328.ABE86C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: smccc: replace custom COUNT_ARGS() & CONCATENATE() implementations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm64-smccc-replace-custom-count_args-concatenate-implementations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-smccc-replace-custom-count_args-concatenate-implementations.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: arm64: smccc: replace custom COUNT_ARGS() & CONCATENATE() implementations
Date: Wed, 19 Jul 2023 00:11:46 +0300

Replace custom implementation of the macros from args.h.

Link: https://lkml.kernel.org/r/20230718211147.18647-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/arm-smccc.h |   69 ++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

--- a/include/linux/arm-smccc.h~arm64-smccc-replace-custom-count_args-concatenate-implementations
+++ a/include/linux/arm-smccc.h
@@ -5,6 +5,7 @@
 #ifndef __LINUX_ARM_SMCCC_H
 #define __LINUX_ARM_SMCCC_H
 
+#include <linux/args.h>
 #include <linux/init.h>
 #include <uapi/linux/const.h>
 
@@ -413,31 +414,26 @@ asmlinkage void __arm_smccc_hvc(unsigned
 
 #endif
 
-#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
+#define __constraint_read_2	"r" (arg0)
+#define __constraint_read_3	__constraint_read_2, "r" (arg1)
+#define __constraint_read_4	__constraint_read_3, "r" (arg2)
+#define __constraint_read_5	__constraint_read_4, "r" (arg3)
+#define __constraint_read_6	__constraint_read_5, "r" (arg4)
+#define __constraint_read_7	__constraint_read_6, "r" (arg5)
+#define __constraint_read_8	__constraint_read_7, "r" (arg6)
+#define __constraint_read_9	__constraint_read_8, "r" (arg7)
 
-#define __count_args(...)						\
-	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
-
-#define __constraint_read_0	"r" (arg0)
-#define __constraint_read_1	__constraint_read_0, "r" (arg1)
-#define __constraint_read_2	__constraint_read_1, "r" (arg2)
-#define __constraint_read_3	__constraint_read_2, "r" (arg3)
-#define __constraint_read_4	__constraint_read_3, "r" (arg4)
-#define __constraint_read_5	__constraint_read_4, "r" (arg5)
-#define __constraint_read_6	__constraint_read_5, "r" (arg6)
-#define __constraint_read_7	__constraint_read_6, "r" (arg7)
-
-#define __declare_arg_0(a0, res)					\
+#define __declare_arg_2(a0, res)					\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long arg0 asm("r0") = (u32)a0
 
-#define __declare_arg_1(a0, a1, res)					\
+#define __declare_arg_3(a0, a1, res)					\
 	typeof(a1) __a1 = a1;						\
 	struct arm_smccc_res   *___res = res;				\
 	register unsigned long arg0 asm("r0") = (u32)a0;			\
 	register typeof(a1) arg1 asm("r1") = __a1
 
-#define __declare_arg_2(a0, a1, a2, res)				\
+#define __declare_arg_4(a0, a1, a2, res)				\
 	typeof(a1) __a1 = a1;						\
 	typeof(a2) __a2 = a2;						\
 	struct arm_smccc_res   *___res = res;				\
@@ -445,7 +441,7 @@ asmlinkage void __arm_smccc_hvc(unsigned
 	register typeof(a1) arg1 asm("r1") = __a1;			\
 	register typeof(a2) arg2 asm("r2") = __a2
 
-#define __declare_arg_3(a0, a1, a2, a3, res)				\
+#define __declare_arg_5(a0, a1, a2, a3, res)				\
 	typeof(a1) __a1 = a1;						\
 	typeof(a2) __a2 = a2;						\
 	typeof(a3) __a3 = a3;						\
@@ -455,34 +451,26 @@ asmlinkage void __arm_smccc_hvc(unsigned
 	register typeof(a2) arg2 asm("r2") = __a2;			\
 	register typeof(a3) arg3 asm("r3") = __a3
 
-#define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
+#define __declare_arg_6(a0, a1, a2, a3, a4, res)			\
 	typeof(a4) __a4 = a4;						\
-	__declare_arg_3(a0, a1, a2, a3, res);				\
+	__declare_arg_5(a0, a1, a2, a3, res);				\
 	register typeof(a4) arg4 asm("r4") = __a4
 
-#define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
+#define __declare_arg_7(a0, a1, a2, a3, a4, a5, res)			\
 	typeof(a5) __a5 = a5;						\
-	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
+	__declare_arg_6(a0, a1, a2, a3, a4, res);			\
 	register typeof(a5) arg5 asm("r5") = __a5
 
-#define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
+#define __declare_arg_8(a0, a1, a2, a3, a4, a5, a6, res)		\
 	typeof(a6) __a6 = a6;						\
-	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
+	__declare_arg_7(a0, a1, a2, a3, a4, a5, res);			\
 	register typeof(a6) arg6 asm("r6") = __a6
 
-#define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
+#define __declare_arg_9(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
 	typeof(a7) __a7 = a7;						\
-	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
+	__declare_arg_8(a0, a1, a2, a3, a4, a5, a6, res);		\
 	register typeof(a7) arg7 asm("r7") = __a7
 
-#define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
-#define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
-
-#define ___constraints(count)						\
-	: __constraint_read_ ## count					\
-	: smccc_sve_clobbers "memory"
-#define __constraints(count)	___constraints(count)
-
 /*
  * We have an output list that is not necessarily used, and GCC feels
  * entitled to optimise the whole sequence away. "volatile" is what
@@ -494,11 +482,14 @@ asmlinkage void __arm_smccc_hvc(unsigned
 		register unsigned long r1 asm("r1");			\
 		register unsigned long r2 asm("r2");			\
 		register unsigned long r3 asm("r3"); 			\
-		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		CONCATENATE(__declare_arg_,				\
+			    COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__);	\
 		asm volatile(SMCCC_SVE_CHECK				\
 			     inst "\n" :				\
 			     "=r" (r0), "=r" (r1), "=r" (r2), "=r" (r3)	\
-			     __constraints(__count_args(__VA_ARGS__)));	\
+			     : CONCATENATE(__constraint_read_,		\
+					   COUNT_ARGS(__VA_ARGS__))	\
+			     : smccc_sve_clobbers "memory");		\
 		if (___res)						\
 			*___res = (typeof(*___res)){r0, r1, r2, r3};	\
 	} while (0)
@@ -542,8 +533,12 @@ asmlinkage void __arm_smccc_hvc(unsigned
  */
 #define __fail_smccc_1_1(...)						\
 	do {								\
-		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
-		asm ("" : __constraints(__count_args(__VA_ARGS__)));	\
+		CONCATENATE(__declare_arg_,				\
+			    COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__);	\
+		asm ("" :						\
+		     : CONCATENATE(__constraint_read_,			\
+				   COUNT_ARGS(__VA_ARGS__))		\
+		     : smccc_sve_clobbers "memory");			\
 		if (___res)						\
 			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
 	} while (0)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-count_args-and-concatenate-to-argsh.patch
x86-asm-replace-custom-count_args-concatenate-implementations.patch
arm64-smccc-replace-custom-count_args-concatenate-implementations.patch
genetlink-replace-custom-concatenate-implementation.patch

