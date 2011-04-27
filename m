From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 27 Apr 2011 12:22:56 -0700
Message-ID: <201104271917.p3RJHji9029356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756620Ab1D0TRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Apr 2011 15:17:47 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p3RJHjcU000533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2011 12:17:45 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/avc.c   |    4 ----
 security/selinux/hooks.c |   11 -----------
 2 files changed, 15 deletions(-)

diff -puN security/selinux/avc.c~linux-next-git-rejects security/selinux/avc.c
--- a/security/selinux/avc.c~linux-next-git-rejects
+++ a/security/selinux/avc.c
@@ -531,11 +531,7 @@ int avc_audit(u32 ssid, u32 tsid,
 	 * during retry. However this is logically just as if the operation
 	 * happened a little later.
 	 */
-<<<<<<< HEAD
-	if ((a->type == LSM_AUDIT_DATA_FS) &&
-=======
 	if ((a->type == LSM_AUDIT_DATA_INODE) &&
->>>>>>> FETCH_HEAD
 	    (flags & IPERM_FLAG_RCU))
 		return -ECHILD;
 
diff -puN security/selinux/hooks.c~linux-next-git-rejects security/selinux/hooks.c
--- a/security/selinux/hooks.c~linux-next-git-rejects
+++ a/security/selinux/hooks.c
@@ -1507,15 +1507,9 @@ static inline int dentry_has_perm(const 
 	struct inode *inode = dentry->d_inode;
 	struct common_audit_data ad;
 
-<<<<<<< HEAD
-	COMMON_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.path.mnt = mnt;
-	ad.u.fs.path.dentry = dentry;
-=======
 	COMMON_AUDIT_DATA_INIT(&ad, PATH);
 	ad.u.path.mnt = mnt;
 	ad.u.path.dentry = dentry;
->>>>>>> FETCH_HEAD
 	return inode_has_perm(cred, inode, av, &ad, 0);
 }
 
@@ -2661,13 +2655,8 @@ static int selinux_inode_permission(stru
 	if (!mask)
 		return 0;
 
-<<<<<<< HEAD
-	COMMON_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.inode = inode;
-=======
 	COMMON_AUDIT_DATA_INIT(&ad, INODE);
 	ad.u.inode = inode;
->>>>>>> FETCH_HEAD
 
 	if (from_access)
 		ad.selinux_audit_data.auditdeny |= FILE__AUDIT_ACCESS;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

