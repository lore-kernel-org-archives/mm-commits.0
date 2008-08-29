From: akpm@linux-foundation.org
Subject: + separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch added to -mm tree
Date: Fri, 29 Aug 2008 15:08:12 -0700
Message-ID: <200808292221.m7TMLhLZ007300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYH2WXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Aug 2008 18:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, linux-arch@vger.kernel.org, ying.huang@intel.com


The patch titled
     separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix
has been added to the -mm tree.  Its filename is
     separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch

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
Subject: separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-arch@vger.kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/atomic_32.h  |    4 ++--
 arch/sparc/include/asm/atomic_64.h  |    2 +-
 arch/sparc/include/asm/atomic_def.h |    8 ++++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/sparc/include/asm/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -13,10 +13,10 @@
 
 #include <linux/types.h>
 
-typedef struct { volatile int counter; } atomic_t;
-
 #ifdef __KERNEL__
 
+#include <asm/atomic_def.h>
+
 #define ATOMIC_INIT(i)  { (i) }
 
 extern int __atomic_add_return(int, atomic_t *);
diff -puN arch/sparc/include/asm/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -9,8 +9,8 @@
 
 #include <linux/types.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
-typedef struct { volatile int counter; } atomic_t;
 typedef struct { volatile __s64 counter; } atomic64_t;
 
 #define ATOMIC_INIT(i)		{ (i) }
diff -puN /dev/null arch/sparc/include/asm/atomic_def.h
--- /dev/null
+++ a/arch/sparc/include/asm/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef _ATOMIC_DEF_H
+#define _ATOMIC_DEF_H
+
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
power-support-for-texas-instruments-bq27x00-battery-managers-fix.patch
drivers-pci-hotplug-ibmphp_ebdac-list_for_each-to-list_for_each_entry-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

