From: akpm@linux-foundation.org
Subject: - revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:33 -0700
Message-ID: <200805010933.m419XXQ6031151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbYEAJd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, heiko.carstens@de.ibm.com, pbadari@us.ibm.com, torvalds@linux-foundation.org, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@


The patch titled
     revert "memory hotplug: allocate usemap on the section with pgdat"
has been removed from the -mm tree.  Its filename was
     revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "memory hotplug: allocate usemap on the section with pgdat"
From: Andrew Morton <akpm@linux-foundation.org>

This:

commit 86f6dae1377523689bd8468fed2f2dd180fc0560
Author: Yasunori Goto <y-goto@jp.fujitsu.com>
Date:   Mon Apr 28 02:13:33 2008 -0700

    memory hotplug: allocate usemap on the section with pgdat
    
    Usemaps are allocated on the section which has pgdat by this.
    
    Because usemap size is very small, many other sections usemaps are allocated
    on only one page.  If a section has usemap, it can't be removed until removing
    other sections.  This dependency is not desirable for memory removing.
    
    Pgdat has similar feature.  When a section has pgdat area, it must be the last
    section for removing on the node.  So, if section A has pgdat and section B
    has usemap for section A, Both sections can't be removed due to dependency
    each other.
    
    To solve this issue, this patch collects usemap on same section with pgdat.
    If other sections doesn't have any dependency, this section will be able to be
    removed finally.
    
    Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Cc: Badari Pulavarty <pbadari@us.ibm.com>
    Cc: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

broke davem's sparc64 bootup.  Revert it while we work out what went wrong.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN mm/sparse.c~revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat mm/sparse.c
--- a/mm/sparse.c~revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat
+++ a/mm/sparse.c
@@ -250,22 +250,11 @@ static unsigned long *__kmalloc_section_
 
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
-	unsigned long *usemap, section_nr;
+	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
-	struct pglist_data *pgdat = NODE_DATA(nid);
 
-	/*
-	 * Usemap's page can't be freed until freeing other sections
-	 * which use it. And, Pgdat has same feature.
-	 * If section A has pgdat and section B has usemap for other
-	 * sections (includes section A), both sections can't be removed,
-	 * because there is the dependency each other.
-	 * To solve above issue, this collects all usemap on the same section
-	 * which has pgdat.
-	 */
-	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	usemap = alloc_bootmem_section(usemap_size(), section_nr);
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
 	if (usemap)
 		return usemap;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
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
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

