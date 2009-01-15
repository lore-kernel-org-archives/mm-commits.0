From: akpm@linux-foundation.org
Subject: + ecryptfs-some-inode-attr-fixes-fix.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:03:41 -0800
Message-ID: <200901152303.n0FN3flL008586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935379AbZAOXEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:04:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hooanon05@yahoo.co.jp, shaggy@linux.vnet.ibm.com


The patch titled
     ecryptfs-some-inode-attr-fixes-fix
has been added to the -mm tree.  Its filename is
     ecryptfs-some-inode-attr-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs-some-inode-attr-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/atomic_inc_return/atomic_inc/

Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    2 +-
 fs/ecryptfs/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes-fix
+++ a/fs/ecryptfs/inode.c
@@ -479,7 +479,7 @@ static int ecryptfs_unlink(struct inode 
 
 	lower_dir_dentry = lock_parent(lower_dentry);
 	dget(lower_dentry);
-	atomic_inc_return(&lower_dentry->d_inode->i_count);
+	atomic_inc(&lower_dentry->d_inode->i_count);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	dput(lower_dentry);
 	if (rc) {
diff -puN fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes-fix
+++ a/fs/ecryptfs/super.c
@@ -102,7 +102,7 @@ static void ecryptfs_destroy_inode(struc
  */
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode)
 {
-	atomic_inc_return(&lower_inode->i_count);
+	atomic_inc(&lower_inode->i_count);
 	ecryptfs_set_inode_lower(inode, lower_inode);
 	inode->i_ino = lower_inode->i_ino;
 	inode->i_version++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
ecryptfs-some-inode-attr-fixes-fix.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
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

