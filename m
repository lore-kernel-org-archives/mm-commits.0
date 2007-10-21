From: akpm@linux-foundation.org
Subject: - git-nfsd-broke-reiser4.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:48:03 -0700
Message-ID: <200710212348.l9LNm3Cq000694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbXJUXzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfields@citi.umich.edu, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     git-nfsd-broke-reiser4
has been removed from the -mm tree.  Its filename was
     git-nfsd-broke-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: git-nfsd-broke-reiser4
From: Andrew Morton <akpm@linux-foundation.org>

fs/reiser4/export_ops.c: In function 'reiser4_decode_fh':
fs/reiser4/export_ops.c:96: error: 'const struct export_operations' has no member named 'find_exported_dentry'
fs/reiser4/export_ops.c:96: warning: type defaults to 'int' in declaration of 'fn'
fs/reiser4/export_ops.c:98: error: 'const struct export_operations' has no member named 'find_exported_dentry'
fs/reiser4/export_ops.c:99: warning: comparison between pointer and integer
fs/reiser4/export_ops.c:101: error: called object 'fn' is not a function
fs/reiser4/export_ops.c: At top level:
fs/reiser4/export_ops.c:282: error: unknown field 'decode_fh' specified in initializer
fs/reiser4/export_ops.c:282: warning: initialization from incompatible pointer type
fs/reiser4/export_ops.c:284: error: unknown field 'get_dentry' specified in initializer
fs/reiser4/export_ops.c:285: warning: excess elements in struct initializer
fs/reiser4/export_ops.c:285: warning: (near initialization for 'reiser4_export_operations')

help!

Cc: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/export_ops.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/reiser4/export_ops.c~git-nfsd-broke-reiser4 fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~git-nfsd-broke-reiser4
+++ a/fs/reiser4/export_ops.c
@@ -86,7 +86,7 @@ static struct dentry *reiser4_decode_fh(
 
 	object_on_wire_init(&object);
 	object_on_wire_init(&parent);
-
+#if 0
 	addr = decode_inode(super, addr, &object);
 	if (!IS_ERR(addr)) {
 		if (with_parent)
@@ -105,12 +105,14 @@ static struct dentry *reiser4_decode_fh(
 			addr = (char *)d;
 		}
 	}
-
 	object_on_wire_done(&object);
 	object_on_wire_done(&parent);
 
 	reiser4_exit_context(ctx);
 	return (void *)addr;
+#else
+	return ERR_PTR(-EINVAL);
+#endif
 }
 
 /*
@@ -279,9 +281,9 @@ static struct dentry *reiser4_get_dentry
 
 struct export_operations reiser4_export_operations = {
 	.encode_fh = reiser4_encode_fh,
-	.decode_fh = reiser4_decode_fh,
+//	.decode_fh = reiser4_decode_fh,
 	.get_parent = reiser4_get_dentry_parent,
-	.get_dentry = reiser4_get_dentry
+//	.get_dentry = reiser4_get_dentry
 };
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
fix-x86_64-mm-sched-clock-share.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
