From: akpm@linux-foundation.org
Subject: [merged]
 arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:22:00 -0700
Message-ID: <543d69c8.sSlH/fad9tDgkazS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaJNSV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/cpu/common.c: fix unused symbol warning
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kernel/cpu/common.c: fix unused symbol warning

x86_64 allnoconfig:

arch/x86/kernel/cpu/common.c:968: warning: 'syscall32_cpu_init' defined but not used

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/common.c~arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning
+++ a/arch/x86/kernel/cpu/common.c
@@ -964,6 +964,7 @@ static void vgetcpu_set_mode(void)
 		vgetcpu_mode = VGETCPU_LSL;
 }
 
+#ifdef CONFIG_IA32_EMULATION
 /* May not be __init: called during resume */
 static void syscall32_cpu_init(void)
 {
@@ -975,7 +976,8 @@ static void syscall32_cpu_init(void)
 
 	wrmsrl(MSR_CSTAR, ia32_cstar_target);
 }
-#endif
+#endif		/* CONFIG_IA32_EMULATION */
+#endif		/* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
 void enable_sep_cpu(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

