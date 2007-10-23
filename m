From: akpm@linux-foundation.org
Subject: - security-convert-lsm-into-a-static-interface-fix-unionfs.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:48:08 -0700
Message-ID: <200710230648.l9N6m8ME004344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbXJWHCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, chrisw@sous-sol.org, jmorris@namei.org, jsipek@cs.sunysb.edu, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security-convert-lsm-into-a-static-interface :fix unionfs
has been removed from the -mm tree.  Its filename was
     security-convert-lsm-into-a-static-interface-fix-unionfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: security-convert-lsm-into-a-static-interface :fix unionfs
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "security_inode_permission" [fs/unionfs/unionfs.ko] undefined!
ERROR: "security_file_ioctl" [fs/unionfs/unionfs.ko] undefined!

Need these back.

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/security.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN security/security.c~security-convert-lsm-into-a-static-interface-fix-unionfs security/security.c
--- a/security/security.c~security-convert-lsm-into-a-static-interface-fix-unionfs
+++ a/security/security.c
@@ -409,6 +409,7 @@ int security_inode_permission(struct ino
 		return 0;
 	return security_ops->inode_permission(inode, mask, nd);
 }
+EXPORT_SYMBOL(security_inode_permission);
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -518,6 +519,7 @@ int security_file_ioctl(struct file *fil
 {
 	return security_ops->file_ioctl(file, cmd, arg);
 }
+EXPORT_SYMBOL(security_file_ioctl);
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
documentation-watchdog-src-watchdog-simplec-improve-this-code-checkpatch-fixes.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
