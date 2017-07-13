From: akpm@linux-foundation.org
Subject: [merged]
 arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:42:39 -0700
Message-ID: <20170713204239.DlXyUb8-z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUmk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, danielmicay@gmail.com, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, tytso@mit.edu, ysato@users.sourceforge.jp


The patch titled
     Subject: arm64: ascii armor the arm64 boot init stack canary
has been removed from the -mm tree.  Its filename was
     arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: arm64: ascii armor the arm64 boot init stack canary

Use the ascii-armor canary to prevent unterminated C string overflows from
being able to successfully overwrite the canary, even if they somehow
obtain the canary value.

Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170524155751.424-5-riel@redhat.com
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

 arch/arm64/include/asm/stackprotector.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm64/include/asm/stackprotector.h~arm64-ascii-armor-the-arm64-boot-init-stack-canary arch/arm64/include/asm/stackprotector.h
--- a/arch/arm64/include/asm/stackprotector.h~arm64-ascii-armor-the-arm64-boot-init-stack-canary
+++ a/arch/arm64/include/asm/stackprotector.h
@@ -30,6 +30,7 @@ static __always_inline void boot_init_st
 	/* Try to get a semi random initial value. */
 	get_random_bytes(&canary, sizeof(canary));
 	canary ^= LINUX_VERSION_CODE;
+	canary &= CANARY_MASK;
 
 	current->stack_canary = canary;
 	__stack_chk_guard = current->stack_canary;
_

Patches currently in -mm which might be from riel@redhat.com are


