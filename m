From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space.patch removed
 from -mm tree
Date: Thu, 22 Jun 2017 14:05:17 -0700
Message-ID: <594c310d.5CNlXqvC/OCCaUOp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753692AbdFVVFS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jun 2017 17:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hpa@zytor.com, lwoodman@redhat.com, mhocko@kernel.org, mingo@kernel.org, oleg@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: move COMPAT_ELF_ET_DYN_BASE lower in the address space
has been removed from the -mm tree.  Its filename was
     arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: arm64: move COMPAT_ELF_ET_DYN_BASE lower in the address space

When setting up mmap_base, we take care to start the mmap base below the
maximum extent to which the stack will grow.  However, we take no such
precautions with PIE binaries, which are placed at 2/3 of TASK_SIZE plus a
random offset.  As a result, 32 bit PIE binaries can end up smack in the
middle of where the stack (which is randomized down) is supposed to go.

That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE at
256MB, which is a value linux-hardened and grsecurity have used for a long
time now without any known (to me) bug reports.

Link: http://lkml.kernel.org/r/20170602152010.2064-6-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/include/asm/elf.h~arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space
+++ a/arch/arm64/include/asm/elf.h
@@ -173,7 +173,7 @@ extern int arch_setup_additional_pages(s
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+#define COMPAT_ELF_ET_DYN_BASE		(0x10000000UL)
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
_

Patches currently in -mm which might be from riel@redhat.com are

powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
randomstackprotect-introduce-get_random_canary-function.patch
forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
x86-ascii-armor-the-x86_64-boot-init-stack-canary.patch
arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch
sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch

