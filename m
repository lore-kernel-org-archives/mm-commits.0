From: akpm@linux-foundation.org
Subject: + kexec-migrate-to-reboot-cpu.patch added to -mm tree
Date: Mon, 11 Nov 2013 11:50:53 -0800
Message-ID: <5281351d.UnoHfBNHg+Z5Lli+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3KKTuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 14:50:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mwhitehe@redhat.com, hpa@linux.intel.com, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com, vgoyal@redhat.com

Subject: + kexec-migrate-to-reboot-cpu.patch added to -mm tree
To: vgoyal@redhat.com,bhe@redhat.com,chaowang@redhat.com,dyoung@redhat.com,hpa@linux.intel.com,mwhitehe@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 11:50:53 -0800


The patch titled
     Subject: kexec: migrate to reboot cpu
has been added to the -mm tree.  Its filename is
     kexec-migrate-to-reboot-cpu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-migrate-to-reboot-cpu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-migrate-to-reboot-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Reported-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Tested-by: Baoquan He <bhe@redhat.com>
Bisected-by: WANG Chao <chaowang@redhat.com>
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
@@ -1676,6 +1676,7 @@ int kernel_kexec(void)
 #endif
 	{
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

kexec-migrate-to-reboot-cpu.patch
linux-next.patch

