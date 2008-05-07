From: akpm@linux-foundation.org
Subject: + add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch added to -mm tree
Date: Wed, 07 May 2008 15:16:08 -0700
Message-ID: <200805072216.m47MG85k019344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbYEGWQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, greg@kroah.com, jirislaby@gmail.com


The patch titled
     add-a-warn-macro-this-is-warn_on-printk-arguments-fix
has been added to the -mm tree.  Its filename is
     add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch

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
Subject: add-a-warn-macro-this-is-warn_on-printk-arguments-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
DESC
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-checkpatch-fixes
EDESC

ERROR: space required after that ',' (ctx:VxV)
#22: FILE: include/asm-generic/bug.h:37:
+		__attribute__((format(printf,3,4)));
 		                            ^

ERROR: space required after that ',' (ctx:VxV)
#22: FILE: include/asm-generic/bug.h:37:
+		__attribute__((format(printf,3,4)));
 		                              ^

total: 2 errors, 0 warnings, 29 lines checked

./patches/add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    6 ++----
 kernel/panic.c            |    4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments-fix include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments-fix
+++ a/include/asm-generic/bug.h
@@ -34,7 +34,8 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
-extern void warn_slowpath(const char *file, const int line, const char *fmt, ...);
+extern void warn_slowpath(const char *file, const int line,
+		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
@@ -61,9 +62,6 @@ extern void warn_slowpath(const char *fi
 })
 #endif
 
-
-
-
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
diff -puN kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments-fix kernel/panic.c
--- a/kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments-fix
+++ a/kernel/panic.c
@@ -326,10 +326,8 @@ EXPORT_SYMBOL(warn_on_slowpath);
 void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
-
-
 	char function[KSYM_SYMBOL_LEN];
-	unsigned long caller = (unsigned long) __builtin_return_address(0);
+	unsigned long caller = (unsigned long)__builtin_return_address(0);
 	sprint_symbol(function, caller);
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
linux-next.patch
linux-next-fixup.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
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

