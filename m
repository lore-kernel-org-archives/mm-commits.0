From: akpm@linux-foundation.org
Subject: + kexec-jump-fix-for-ftrace.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:53 -0700
Message-ID: <200808122315.m7CNFrVK018751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYHLXQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, rostedt@goodmis.org, vgoyal@redhat.com


The patch titled
     kexec jump: fix for ftrace
has been added to the -mm tree.  Its filename is
     kexec-jump-fix-for-ftrace.patch

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
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

