From: akpm@linux-foundation.org
Subject: - x86-64-add-two-__cpuinit-annotations.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:25:39 -0700
Message-ID: <200809130725.m8D7PdYG026077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbYIMH0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: add two __cpuinit annotations
has been removed from the -mm tree.  Its filename was
     x86-64-add-two-__cpuinit-annotations.patch

This patch was dropped because of rejects

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-64: add two __cpuinit annotations
From: Jan Beulich <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common_64.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/common_64.c~x86-64-add-two-__cpuinit-annotations arch/x86/kernel/cpu/common_64.c
--- a/arch/x86/kernel/cpu/common_64.c~x86-64-add-two-__cpuinit-annotations
+++ a/arch/x86/kernel/cpu/common_64.c
@@ -560,7 +560,7 @@ static int __init nonx32_setup(char *str
 }
 __setup("noexec32=", nonx32_setup);
 
-void pda_init(int cpu)
+void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
 
diff -puN arch/x86/kernel/cpu/mcheck/mce_64.c~x86-64-add-two-__cpuinit-annotations arch/x86/kernel/cpu/mcheck/mce_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c~x86-64-add-two-__cpuinit-annotations
+++ a/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -860,7 +860,7 @@ error:
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
swiotlb-fix-oops-on-memory-exhaustion.patch
kconfig-eliminate-def_bool-n-constructs.patch

