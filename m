From: akpm@linux-foundation.org
Subject: - kexec-jump-fix-for-ftrace.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:37 -0700
Message-ID: <200808181939.m7IJdbMs008343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762673AbYHRTkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rostedt@goodmis.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec jump: fix for ftrace
has been removed from the -mm tree.  Its filename was
     kexec-jump-fix-for-ftrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: fix for ftrace
From: Huang Ying <ying.huang@intel.com>

Ftrace depends on some processor state that we destroyed during kexec and
restored by restore_processor_state().  So save_processor_state() and
restore_processor_state() are moved into machine_kexec() and ftrace is
restored after restore_processor_state().

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_32.c |   16 +++++++++++++++-
 kernel/kexec.c                     |    2 --
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump-fix-for-ftrace arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump-fix-for-ftrace
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/numa.h>
 #include <linux/ftrace.h>
+#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -113,6 +114,7 @@ void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
+	int save_ftrace_enabled;
 	asmlinkage unsigned long
 		(*relocate_kernel_ptr)(unsigned long indirection_page,
 				       unsigned long control_page,
@@ -120,7 +122,12 @@ void machine_kexec(struct kimage *image)
 				       unsigned int has_pae,
 				       unsigned int preserve_context);
 
-	tracer_disable();
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		save_processor_state();
+#endif
+
+	save_ftrace_enabled = __ftrace_enabled_save();
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
@@ -178,6 +185,13 @@ void machine_kexec(struct kimage *image)
 					   (unsigned long)page_list,
 					   image->start, cpu_has_pae,
 					   image->preserve_context);
+
+#ifdef CONFIG_KEXEC_JUMP
+	if (kexec_image->preserve_context)
+		restore_processor_state();
+#endif
+
+	__ftrace_enabled_restore(save_ftrace_enabled);
 }
 
 void arch_crash_save_vmcoreinfo(void)
diff -puN kernel/kexec.c~kexec-jump-fix-for-ftrace kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-fix-for-ftrace
+++ a/kernel/kexec.c
@@ -1469,7 +1469,6 @@ int kernel_kexec(void)
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
 			goto Enable_irqs;
-		save_processor_state();
 	} else
 #endif
 	{
@@ -1482,7 +1481,6 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-		restore_processor_state();
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch

