From: akpm@linux-foundation.org
Subject: - include-linux-kallsymsh-must-include.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:41 -0700
Message-ID: <200707080811.l688Bfh1014788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbXGHIL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     include/linux/kallsyms.h must #include <linux/errno.h>
has been removed from the -mm tree.  Its filename was
     include-linux-kallsymsh-must-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/linux/kallsyms.h must #include <linux/errno.h>
From: Adrian Bunk <bunk@stusta.de>

This patch fixes the following 2.6.22 regression with CONFIG_KALLSYMS=n:

<--  snip  -->

...
  CC      arch/m32r/kernel/traps.o
In file included from /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/m32r/kernel/traps.c:14:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h: In function 'lookup_symbol_name':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: 'ERANGE' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:66: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h: In function 'lookup_symbol_attrs':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/include/linux/kallsyms.h:71: error: 'ERANGE' undeclared (first use in this function)
make[2]: *** [arch/m32r/kernel/traps.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/kallsyms.h~include-linux-kallsymsh-must-include include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~include-linux-kallsymsh-must-include
+++ a/include/linux/kallsyms.h
@@ -5,6 +5,7 @@
 #ifndef _LINUX_KALLSYMS_H
 #define _LINUX_KALLSYMS_H
 
+#include <linux/errno.h>
 
 #define KSYM_NAME_LEN 127
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + KSYM_NAME_LEN +	\
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
git-battery.patch
git-selinux.patch
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
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.patch
mm-variable-length-argument-support-fix-2.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
