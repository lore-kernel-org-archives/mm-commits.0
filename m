From: akpm@linux-foundation.org
Subject: + proper-prototype-for-proc_nr_files.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:37:14 -0700
Message-ID: <200706261937.l5QJbEcJ000714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202AbXFZThZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     proper prototype for proc_nr_files()
has been added to the -mm tree.  Its filename is
     proper-prototype-for-proc_nr_files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proper prototype for proc_nr_files()
From: Adrian Bunk <bunk@stusta.de>

Add a proper prototype for proc_nr_files() in include/linux/fs.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    5 +++++
 kernel/sysctl.c    |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~proper-prototype-for-proc_nr_files include/linux/fs.h
--- a/include/linux/fs.h~proper-prototype-for-proc_nr_files
+++ a/include/linux/fs.h
@@ -285,6 +285,7 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
+#include <linux/sysctl.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -2119,5 +2120,9 @@ static inline void free_secdata(void *se
 { }
 #endif	/* CONFIG_SECURITY */
 
+int proc_nr_files(ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos);
+
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
diff -puN kernel/sysctl.c~proper-prototype-for-proc_nr_files kernel/sysctl.c
--- a/kernel/sysctl.c~proper-prototype-for-proc_nr_files
+++ a/kernel/sysctl.c
@@ -46,13 +46,11 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 
-extern int proc_nr_files(ctl_table *table, int write, struct file *filp,
-                     void __user *buffer, size_t *lenp, loff_t *ppos);
-
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
mark-calibrate_xor_blocks-__init.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
kernel-sys_nic-should-include-linux-syscallsh.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
