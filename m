From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-anonymous-inode-source-fix.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:16:25 -0700
Message-ID: <200704022316.l32NGPC3012186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966097AbXDBXQ1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal-timer-event-fds-v9-anonymous-inode-source-fix
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-anonymous-inode-source-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: signal-timer-event-fds-v9-anonymous-inode-source-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c            |    2 --
 include/linux/anon_inodes.h |    2 +-
 init/Kconfig                |    2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/anon_inodes.c~signal-timer-event-fds-v9-anonymous-inode-source-fix fs/anon_inodes.c
--- a/fs/anon_inodes.c~signal-timer-event-fds-v9-anonymous-inode-source-fix
+++ a/fs/anon_inodes.c
@@ -21,12 +21,10 @@
 
 #include <asm/uaccess.h>
 
-
 static struct vfsmount *aino_mnt __read_mostly;
 static struct inode *aino_inode;
 static const struct file_operations aino_fops;
 
-
 static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
 			 const char *dev_name, void *data, struct vfsmount *mnt)
 {
diff -puN include/linux/anon_inodes.h~signal-timer-event-fds-v9-anonymous-inode-source-fix include/linux/anon_inodes.h
--- a/include/linux/anon_inodes.h~signal-timer-event-fds-v9-anonymous-inode-source-fix
+++ a/include/linux/anon_inodes.h
@@ -9,7 +9,7 @@
 #define _LINUX_ANON_INODES_H
 
 int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
-	       const char *name, const struct file_operations *fops, void *priv);
+	    const char *name, const struct file_operations *fops, void *priv);
 
 #endif /* _LINUX_ANON_INODES_H */
 
diff -puN init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source-fix init/Kconfig
--- a/init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source-fix
+++ a/init/Kconfig
@@ -479,7 +479,7 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anynimous inode source" if EMBEDDED
+	bool "Enable anonymous inode source" if EMBEDDED
 	default y
 	help
 	  Anonymous inode source for pseudo-files like epoll, signalfd,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-parisc.patch
rm9000-serial-driver.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
utrace-x86_64-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
