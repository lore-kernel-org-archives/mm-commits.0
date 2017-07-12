From: akpm@linux-foundation.org
Subject: [patch 69/96] sh64: ascii armor the sh64 boot init stack
 canary
Date: Wed, 12 Jul 2017 14:36:29 -0700
Message-ID: <20170712213629.u5nglYMYj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbdGLVgb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, tytso@mit.edu, ysato@users.sourceforge.jp

From: Rik van Riel <riel@redhat.com>
Subject: sh64: ascii armor the sh64 boot init stack canary

Use the ascii-armor canary to prevent unterminated C string overflows from
being able to successfully overwrite the canary, even if they somehow
obtain the canary value.

Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170524123446.78510066@annuminas.surriel.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/stackprotector.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sh/include/asm/stackprotector.h~sh64-ascii-armor-the-sh64-boot-init-stack-canary arch/sh/include/asm/stackprotector.h
--- a/arch/sh/include/asm/stackprotector.h~sh64-ascii-armor-the-sh64-boot-init-stack-canary
+++ a/arch/sh/include/asm/stackprotector.h
@@ -19,6 +19,7 @@ static __always_inline void boot_init_st
 	/* Try to get a semi random initial value. */
 	get_random_bytes(&canary, sizeof(canary));
 	canary ^= LINUX_VERSION_CODE;
+	canary &= CANARY_MASK;
 
 	current->stack_canary = canary;
 	__stack_chk_guard = current->stack_canary;
_
