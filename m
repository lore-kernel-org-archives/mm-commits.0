From: akpm@linux-foundation.org
Subject: [merged]
 sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:42:42 -0700
Message-ID: <20170713204242.xibmp7X0D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUmn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, tytso@mit.edu, ysato@users.sourceforge.jp


The patch titled
     Subject: sh64: ascii armor the sh64 boot init stack canary
has been removed from the -mm tree.  Its filename was
     sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from riel@redhat.com are


