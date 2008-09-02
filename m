From: akpm@linux-foundation.org
Subject: + x86-64-add-two-__cpuinit-annotations.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:09:03 -0700
Message-ID: <200809022209.m82M93PP015272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYIBWKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-64: add two __cpuinit annotations
has been added to the -mm tree.  Its filename is
     x86-64-add-two-__cpuinit-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

