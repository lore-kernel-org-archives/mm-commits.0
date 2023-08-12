Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE15C04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjHLWGH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjHLWFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824B31BDD
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A6960B81
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770D0C433C7;
        Sat, 12 Aug 2023 22:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877947;
        bh=7NSh9lAeNws/AFaO7GToHU1k83MmCh/2S16DM1BojWg=;
        h=Date:To:From:Subject:From;
        b=khJyjBozhUqgFMb5+JESrTp64cF7Ao14D9TZFH5MkPvPXDIZiGjR0EXsN3m1HU2Pn
         h3uBLjNGRYPvEA/RlEMVLB7K19m3zY54z20Uhu4laATZDZdvBx67RhyiPAMcGo6hBc
         Qldidi6xddimt8ARLE0ZXQBbfhZJB6RUA0pfSuwo=
Date:   Sat, 12 Aug 2023 15:05:47 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sudeep.holla@arm.com, skhan@linuxfoundation.org,
        rostedt@goodmis.org, mingo@redhat.com, mhiramat@kernel.org,
        mark.rutland@arm.com, lpieralisi@kernel.org, hpa@zytor.com,
        dlatypov@google.com, davidgow@google.com,
        dave.hansen@linux.intel.com, brendan.higgins@linux.dev,
        bp@alien8.de, bhelgaas@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-asm-replace-custom-count_args-concatenate-implementations.patch removed from -mm tree
Message-Id: <20230812220547.770D0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/asm: replace custom COUNT_ARGS() & CONCATENATE() implementations
has been removed from the -mm tree.  Its filename was
     x86-asm-replace-custom-count_args-concatenate-implementations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: x86/asm: replace custom COUNT_ARGS() & CONCATENATE() implementations
Date: Wed, 19 Jul 2023 00:11:45 +0300

Replace custom implementation of the macros from args.h.

Link: https://lkml.kernel.org/r/20230718211147.18647-3-andriy.shevchenko@linux.intel.com
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

 arch/x86/include/asm/rmwcc.h |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/rmwcc.h~x86-asm-replace-custom-count_args-concatenate-implementations
+++ a/arch/x86/include/asm/rmwcc.h
@@ -2,12 +2,7 @@
 #ifndef _ASM_X86_RMWcc
 #define _ASM_X86_RMWcc
 
-/* This counts to 12. Any more, it will return 13th argument. */
-#define __RMWcc_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
-#define RMWcc_ARGS(X...) __RMWcc_ARGS(, ##X, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
-
-#define __RMWcc_CONCAT(a, b) a ## b
-#define RMWcc_CONCAT(a, b) __RMWcc_CONCAT(a, b)
+#include <linux/args.h>
 
 #define __CLOBBERS_MEM(clb...)	"memory", ## clb
 
@@ -48,7 +43,7 @@ cc_label:	c = true;						\
 #define GEN_UNARY_RMWcc_3(op, var, cc)					\
 	GEN_UNARY_RMWcc_4(op, var, cc, "%[var]")
 
-#define GEN_UNARY_RMWcc(X...) RMWcc_CONCAT(GEN_UNARY_RMWcc_, RMWcc_ARGS(X))(X)
+#define GEN_UNARY_RMWcc(X...)	CONCATENATE(GEN_UNARY_RMWcc_, COUNT_ARGS(X))(X)
 
 #define GEN_BINARY_RMWcc_6(op, var, cc, vcon, _val, arg0)		\
 	__GEN_RMWcc(op " %[val], " arg0, var, cc,			\
@@ -57,7 +52,7 @@ cc_label:	c = true;						\
 #define GEN_BINARY_RMWcc_5(op, var, cc, vcon, val)			\
 	GEN_BINARY_RMWcc_6(op, var, cc, vcon, val, "%[var]")
 
-#define GEN_BINARY_RMWcc(X...) RMWcc_CONCAT(GEN_BINARY_RMWcc_, RMWcc_ARGS(X))(X)
+#define GEN_BINARY_RMWcc(X...)	CONCATENATE(GEN_BINARY_RMWcc_, COUNT_ARGS(X))(X)
 
 #define GEN_UNARY_SUFFIXED_RMWcc(op, suffix, var, cc, clobbers...)	\
 	__GEN_RMWcc(op " %[var]\n\t" suffix, var, cc,			\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


