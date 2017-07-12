From: akpm@linux-foundation.org
Subject: [patch 67/96] x86: ascii armor the x86_64 boot init stack
 canary
Date: Wed, 12 Jul 2017 14:36:23 -0700
Message-ID: <20170712213623.sGZLFgXd2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbdGLVgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, tytso@mit.edu, ysato@users.sourceforge.jp

From: Rik van Riel <riel@redhat.com>
Subject: x86: ascii armor the x86_64 boot init stack canary

Use the ascii-armor canary to prevent unterminated C string overflows from
being able to successfully overwrite the canary, even if they somehow
obtain the canary value.

Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170524155751.424-4-riel@redhat.com
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

 arch/x86/include/asm/stackprotector.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/include/asm/stackprotector.h~x86-ascii-armor-the-x86_64-boot-init-stack-canary arch/x86/include/asm/stackprotector.h
--- a/arch/x86/include/asm/stackprotector.h~x86-ascii-armor-the-x86_64-boot-init-stack-canary
+++ a/arch/x86/include/asm/stackprotector.h
@@ -74,6 +74,7 @@ static __always_inline void boot_init_st
 	get_random_bytes(&canary, sizeof(canary));
 	tsc = rdtsc();
 	canary += tsc + (tsc << 32UL);
+	canary &= CANARY_MASK;
 
 	current->stack_canary = canary;
 #ifdef CONFIG_X86_64
_
