From: akpm@linux-foundation.org
Subject: - proper-prototype-for-proc_nr_files.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:05 -0700
Message-ID: <200707172302.l6HN2526011531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936491AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     proper prototype for proc_nr_files()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-proc_nr_files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -283,6 +283,7 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
+#include <linux/sysctl.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -2050,5 +2051,9 @@ static inline void free_secdata(void *se
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
@@ -29,6 +29,7 @@
 #include <linux/utsname.h>
 #include <linux/capability.h>
 #include <linux/smp_lock.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
@@ -49,9 +50,6 @@
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

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
