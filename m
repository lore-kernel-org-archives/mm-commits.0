From: akpm@linux-foundation.org
Subject: [to-be-updated] sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch removed from -mm tree
Date: Thu, 29 Jan 2009 00:38:48 -0800
Message-ID: <200901290838.n0T8cnhl029193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbZA2IjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:39:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix
has been removed from the -mm tree.  Its filename was
     sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix
From: Andrew Morton <akpm@linux-foundation.org>

i386:

arch/x86/include/asm/uv/uv_mmrs.h:409: error: width of 'real_time_cmpb' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:425: error: width of 'real_time_cmpc' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:441: error: width of 'real_time_cmpd' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:491: error: width of 'address' exceeds its type

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/io_apic.c~sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c~sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix
+++ a/arch/x86/kernel/io_apic.c
@@ -59,8 +59,11 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+
+#ifdef CONFIG_X86_64
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
+#endif
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

