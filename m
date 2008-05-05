From: akpm@linux-foundation.org
Subject: - drivers-base-topologyc-add-conditionals-around-show_cpumap.patch removed from -mm tree
Date: Mon, 05 May 2008 12:17:07 -0700
Message-ID: <200805051917.m45JH7PM000435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbYEETRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/base/topology.c: add conditionals around show_cpumap()
has been removed from the -mm tree.  Its filename was
     drivers-base-topologyc-add-conditionals-around-show_cpumap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/topology.c: add conditionals around show_cpumap()
From: Andrew Morton <akpm@linux-foundation.org>

drivers/base/topology.c:44: warning: 'show_cpumap' defined but not used

Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/topology.c~drivers-base-topologyc-add-conditionals-around-show_cpumap drivers/base/topology.c
--- a/drivers/base/topology.c~drivers-base-topologyc-add-conditionals-around-show_cpumap
+++ a/drivers/base/topology.c
@@ -40,6 +40,7 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
+#if defined(topology_thread_siblings) || defined(topology_core_siblings)
 static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -54,6 +55,7 @@ static ssize_t show_cpumap(int type, cpu
 	}
 	return n;
 }
+#endif
 
 #define define_siblings_show_map(name)					\
 static inline ssize_t show_##name(struct sys_device *dev, char *buf)	\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
sxc-fix-printk-warnings-on-sparc32.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
git-net-git-rejects.patch
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
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
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

