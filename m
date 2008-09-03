From: akpm@linux-foundation.org
Subject: + drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch added to -mm tree
Date: Tue, 02 Sep 2008 22:05:53 -0700
Message-ID: <200809030519.m835JS9Z030929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYICFUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 01:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, davem@davemloft.net, david-b@pacbell.net


The patch titled
     drivers/rtc/Kconfig: don't build rtc-cmos.o on sparc32
has been added to the -mm tree.  Its filename is
     drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch

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
Subject: drivers/rtc/Kconfig: don't build rtc-cmos.o on sparc32
From: Andrew Morton <akpm@linux-foundation.org>

Fix for linux-next's

: Author: David S. Miller <davem@davemloft.net>  2008-08-28 19:54:17
: Committer: David S. Miller <davem@davemloft.net>  2008-08-29 14:16:45
: Parent: 7f60459921bd24e86b21e07c42244c510b4f46b2 (Blackfin RTC Driver: BF561 not have on-chip RTC)
: Child:  cca4c231028405950a15f5a27d7326d18d909784 (rtc: Add TI BQ4802 RTC driver.)
: Branches: git-alsa-tiwai, linux-next
: Follows: v2.6.27-rc4
: Precedes: next-20080902
: 
:     rtc: Allow RTC_DRV_CMOS to be used on SPARC.


In file included from drivers/rtc/rtc-cmos.c:40:
include/asm-generic/rtc.h: In function 'rtc_is_updating':
include/asm-generic/rtc.h:40: error: 'rtc_port' undeclared (first use in this function)
include/asm-generic/rtc.h:40: error: (Each undeclared identifier is reported only once
include/asm-generic/rtc.h:40: error: for each function it appears in.)
include/asm-generic/rtc.h: In function 'get_rtc_time':
include/asm-generic/rtc.h:73: error: 'rtc_port' undeclared (first use in this function)
include/asm-generic/rtc.h: In function 'set_rtc_time':
include/asm-generic/rtc.h:160: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_read_alarm':
drivers/rtc/rtc-cmos.c:193: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_checkintr':
drivers/rtc/rtc-cmos.c:255: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_enable':
drivers/rtc/rtc-cmos.c:272: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_disable':
drivers/rtc/rtc-cmos.c:292: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_set_alarm':
drivers/rtc/rtc-cmos.c:337: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_set_freq':
drivers/rtc/rtc-cmos.c:378: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_procfs':
drivers/rtc/rtc-cmos.c:455: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_nvram_read':
drivers/rtc/rtc-cmos.c:519: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_nvram_write':
drivers/rtc/rtc-cmos.c:551: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_interrupt':
drivers/rtc/rtc-cmos.c:588: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_do_probe':
drivers/rtc/rtc-cmos.c:722: error: 'rtc_port' undeclared (first use in this function)

Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32
+++ a/drivers/rtc/Kconfig
@@ -329,7 +329,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC
+	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC64
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch
acer-wmi-remove-debugfs-entries-upon-unloading.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-git-rejects.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
fs-dlm-configc-choose-better-identifiers.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
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
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
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

