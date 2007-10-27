From: akpm@linux-foundation.org
Subject: + iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:47:42 -0700
Message-ID: <200710270747.l9R7lgvS003408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbXJ0Hr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com


The patch titled
     iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#85: FILE: fs/minix/inode.c:415:
+static struct inode *V1_minix_iget(struct inode * inode)

ERROR: "foo * bar" should be "foo *bar"
#112: FILE: fs/minix/inode.c:448:
+static struct inode *V2_minix_iget(struct inode * inode)

ERROR: use tabs not spaces
#181: FILE: fs/minix/namei.c:58:
+ ^I^Iif (IS_ERR(inode))$

total: 3 errors, 0 warnings, 144 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    4 ++--
 fs/minix/namei.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes fs/minix/inode.c
--- a/fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
+++ a/fs/minix/inode.c
@@ -412,7 +412,7 @@ void minix_set_inode(struct inode *inode
 /*
  * The minix V1 function to read an inode.
  */
-static struct inode *V1_minix_iget(struct inode * inode)
+static struct inode *V1_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -445,7 +445,7 @@ static struct inode *V1_minix_iget(struc
 /*
  * The minix V2 function to read an inode.
  */
-static struct inode *V2_minix_iget(struct inode * inode)
+static struct inode *V2_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
diff -puN fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes fs/minix/namei.c
--- a/fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
+++ a/fs/minix/namei.c
@@ -55,7 +55,7 @@ static struct dentry *minix_lookup(struc
 	ino = minix_inode_by_name(dentry);
 	if (ino) {
 		inode = minix_iget(dir->i_sb, ino);
- 		if (IS_ERR(inode))
+		if (IS_ERR(inode))
 			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
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
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
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
