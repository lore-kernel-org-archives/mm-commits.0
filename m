From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch added to -mm tree
Date: Sun, 17 Aug 2008 15:18:36 -0700
Message-ID: <200808172218.m7HMIaiw024193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbYHQWTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 Aug 2008 18:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, danielm77@spray.se, krafft@de.ibm.com, michael@ellerman.id.au, minyard@acm.org, paulus@samba.org


The patch titled
     drivers/char/ipmi/ipmi_si_intf.c:default_find_bmc(): fix leak
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch

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
Subject: drivers/char/ipmi/ipmi_si_intf.c:default_find_bmc(): fix leak
From: Andrew Morton <akpm@linux-foundation.org>

If check_legacy_ioport() returns true, we leak *info.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11362

Reported-by: Daniel Marjamki <danielm77@spray.se>
Cc: Christian Krafft <krafft@de.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Corey Minyard <minyard@acm.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2695,15 +2695,13 @@ static __devinit void default_find_bmc(v
 	for (i = 0; ; i++) {
 		if (!ipmi_defaults[i].port)
 			break;
-
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
-		if (!info)
-			return;
-
 #ifdef CONFIG_PPC_MERGE
 		if (check_legacy_ioport(ipmi_defaults[i].port))
 			continue;
 #endif
+		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		if (!info)
+			return;
 
 		info->addr_source = NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-use-a-bitop-for-locking-rather-than-xchg.patch
hwmon-adc124s501-generic-driver.patch
spi-bugfix-spi_add_device-with-duplicate-chipselects.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
next-git-rejects.patch
acpi-trivial-cleanups-fix.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-microcode-patch-loader-style-corrections-fix.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
git-net.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
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
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
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
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
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

