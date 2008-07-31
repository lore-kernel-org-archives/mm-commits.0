From: akpm@linux-foundation.org
Subject: - getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 22:30:52 -0700
Message-ID: <200807310530.m6V5Uq5c006104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYGaFbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 01:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, matt@bluehost.com, scott@perlcode.org, mm-commits@vger.kernel.org


The patch titled
     getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch

This patch was dropped because it was folded into getdelaysc-add-a-usr1-signal-handler.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not initialise externals to 0 or NULL
#42: FILE: Documentation/accounting/getdelays.c:53:
+volatile sig_atomic_t reopen_log = 0;

WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
#42: FILE: Documentation/accounting/getdelays.c:53:
+volatile sig_atomic_t reopen_log = 0;

WARNING: line over 80 characters
#96: FILE: Documentation/accounting/getdelays.c:350:
+		signal(SIGUSR1, catch_usr1); /* only set when write_file is set */

WARNING: braces {} are not necessary for single statement blocks
#104: FILE: Documentation/accounting/getdelays.c:469:
+						if (reopen_log) {
+							fd = reopen_logfile(fd, logfile);
+						}

WARNING: line over 80 characters
#105: FILE: Documentation/accounting/getdelays.c:470:
+							fd = reopen_logfile(fd, logfile);

total: 1 errors, 4 warnings, 67 lines checked

./patches/getdelaysc-add-a-usr1-signal-handler.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Matt Heaton <matt@bluehost.com>
Cc: Scott Wiersdorf <scott@perlcode.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/accounting/getdelays.c~getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes
+++ a/Documentation/accounting/getdelays.c
@@ -50,7 +50,7 @@ int dbg;
 int print_delays;
 int print_io_accounting;
 int print_task_context_switch_counts;
-volatile sig_atomic_t reopen_log = 0;
+volatile sig_atomic_t reopen_log;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -470,9 +470,9 @@ int main(int argc, char *argv[])
 								err(1,"write error\n");
 							}
 						}
-						if (reopen_log) {
-							fd = reopen_logfile(fd, logfile);
-						}
+						if (reopen_log)
+							fd = reopen_logfile(fd,
+								logfile);
 						if (!loop)
 							goto done;
 						break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
missing-symbol-prefix-on-vmlinuxldsh-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
next-remove-localversion.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
x86-export-is_uv_system.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

