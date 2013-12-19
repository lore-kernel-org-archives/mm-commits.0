From: akpm@linux-foundation.org
Subject: [merged] kexec-migrate-to-reboot-cpu.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:23 -0800
Message-ID: <52b34eb3.vbd59HRRU1hbfp7j%akpm__11872.9771500968$1387482814$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3LSTxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mwhitehe@redhat.com, hpa@linux.intel.com, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com, vgoyal@redhat.com

Subject: [merged] kexec-migrate-to-reboot-cpu.patch removed from -mm tree
To: vgoyal@redhat.com,bhe@redhat.com,chaowang@redhat.com,dyoung@redhat.com,hpa@linux.intel.com,mwhitehe@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:23 -0800


The patch titled
     Subject: kexec: migrate to reboot cpu
has been removed from the -mm tree.  Its filename was
     kexec-migrate-to-reboot-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: migrate to reboot cpu

Commit 1b3a5d02ee0 ("reboot: move arch/x86 reboot= handling to generic
kernel") moved reboot= handling to generic code.  In the process it also
removed the code in native_machine_shutdown() which are moving reboot
process to reboot_cpu/cpu0.

I guess that thought must have been that all reboot paths are calling
migrate_to_reboot_cpu(), so we don't need this special handling.  But
kexec reboot path (kernel_kexec()) is not calling migrate_to_reboot_cpu()
so above change broke kexec.  Now reboot can happen on non-boot cpu and
when INIT is sent in second kerneo to bring up BP, it brings down the
machine.

So start calling migrate_to_reboot_cpu() in kexec reboot path to avoid
this problem.

Bisected by WANG Chao.

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Reported-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Tested-by: Baoquan He <bhe@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    1 +
 kernel/kexec.c         |    1 +
 kernel/reboot.c        |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/reboot.h~kexec-migrate-to-reboot-cpu include/linux/reboot.h
--- a/include/linux/reboot.h~kexec-migrate-to-reboot-cpu
+++ a/include/linux/reboot.h
@@ -43,6 +43,7 @@ extern int unregister_reboot_notifier(st
  * Architecture-specific implementations of sys_reboot commands.
  */
 
+extern void migrate_to_reboot_cpu(void);
 extern void machine_restart(char *cmd);
 extern void machine_halt(void);
 extern void machine_power_off(void);
diff -puN kernel/kexec.c~kexec-migrate-to-reboot-cpu kernel/kexec.c
--- a/kernel/kexec.c~kexec-migrate-to-reboot-cpu
+++ a/kernel/kexec.c
@@ -1680,6 +1680,7 @@ int kernel_kexec(void)
 	{
 		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
+		migrate_to_reboot_cpu();
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
 	}
diff -puN kernel/reboot.c~kexec-migrate-to-reboot-cpu kernel/reboot.c
--- a/kernel/reboot.c~kexec-migrate-to-reboot-cpu
+++ a/kernel/reboot.c
@@ -104,7 +104,7 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
-static void migrate_to_reboot_cpu(void)
+void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
 	int cpu = reboot_cpu;
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
linux-next.patch

