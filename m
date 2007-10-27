From: akpm@linux-foundation.org
Subject: + iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:44:35 -0700
Message-ID: <200710270744.l9R7iZrF003266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXJ0Ho5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, zippel@linux-m68k.org


The patch titled
     iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#31: FILE: fs/affs/affs.h:177:
+extern struct inode		*affs_iget(struct super_block *sb, unsigned long ino);

WARNING: line over 80 characters
#44: FILE: fs/affs/amigaffs.c:173:
+		dir = affs_iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));

ERROR: need space after that ',' (ctx:VxV)
#81: FILE: fs/affs/inode.c:36:
+	pr_debug("AFFS: affs_iget(%lu)\n",inode->i_ino);
 	                                 ^

total: 1 errors, 2 warnings, 130 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    3 ++-
 fs/affs/inode.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes fs/affs/affs.h
--- a/fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/affs/affs.h
@@ -174,7 +174,8 @@ extern void			 affs_put_inode(struct ino
 extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
-extern struct inode		*affs_iget(struct super_block *sb, unsigned long ino);
+extern struct inode		*affs_iget(struct super_block *sb,
+					unsigned long ino);
 extern int			 affs_write_inode(struct inode *inode, int);
 extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s32 type);
 
diff -puN fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes fs/affs/inode.c
--- a/fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/affs/inode.c
@@ -33,7 +33,7 @@ struct inode *affs_iget(struct super_blo
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-	pr_debug("AFFS: affs_iget(%lu)\n",inode->i_ino);
+	pr_debug("AFFS: affs_iget(%lu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
i386-and-x86_64-randomize-brk-fix.patch
git-perfmon-fill-in-i386-syscall-table.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
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
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
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
