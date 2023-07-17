Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063EEEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjGQSOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjGQSOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CC1711
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8035F61092
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D491AC433C8;
        Mon, 17 Jul 2023 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689617626;
        bh=qChxT1BjwMFyv2tkaniF8csMmjylxbIlRAQMRnTnVoo=;
        h=Date:To:From:Subject:From;
        b=wqu4HsuikWmNdtaN1EHHCixSVgnfggVwas69JN22C9xB38PDQCZyg+RhyP9qJOmxU
         Yyd9PEuP8YmHzW/DbYrhRQMXXew0+tiK7rGtmaQPqg1XeHakzsAJ/VniThBdvuLDgL
         SOdZ2RF9nYi4wdEZgG0jAHux0mNve5IWXTyIDCMU=
Date:   Mon, 17 Jul 2023 11:13:46 -0700
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
Message-Id: <20230717181346.D491AC433C8@smtp.kernel.org>
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
Date: Mon, 17 Jul 2023 15:55:20 +0300

Replace custom implementation of the macros from args.h.

Link: https://lkml.kernel.org/r/20230717125521.43176-4-andriy.shevchenko@linux.intel.com
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
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/arm-smccc.h |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/include/linux/arm-smccc.h~arm64-smccc-replace-custom-count_args-concatenate-implementations
+++ a/include/linux/arm-smccc.h
@@ -5,6 +5,7 @@
 #ifndef __LINUX_ARM_SMCCC_H
 #define __LINUX_ARM_SMCCC_H
 
+#include <linux/args.h>
 #include <linux/init.h>
 #include <uapi/linux/const.h>
 
@@ -413,11 +414,6 @@ asmlinkage void __arm_smccc_hvc(unsigned
 
 #endif
 
-#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
-
-#define __count_args(...)						\
-	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
-
 #define __constraint_read_0	"r" (arg0)
 #define __constraint_read_1	__constraint_read_0, "r" (arg1)
 #define __constraint_read_2	__constraint_read_1, "r" (arg2)
@@ -475,14 +471,6 @@ asmlinkage void __arm_smccc_hvc(unsigned
 	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
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
@@ -494,11 +482,13 @@ asmlinkage void __arm_smccc_hvc(unsigned
 		register unsigned long r1 asm("r1");			\
 		register unsigned long r2 asm("r2");			\
 		register unsigned long r3 asm("r3"); 			\
-		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		CONCATENATE(__declare_arg_, COUNT_ARGS(__VA_ARGS__));	\
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
@@ -542,8 +532,11 @@ asmlinkage void __arm_smccc_hvc(unsigned
  */
 #define __fail_smccc_1_1(...)						\
 	do {								\
-		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
-		asm ("" : __constraints(__count_args(__VA_ARGS__)));	\
+		CONCATENATE(__declare_arg_, COUNT_ARGS(__VA_ARGS__));	\
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

