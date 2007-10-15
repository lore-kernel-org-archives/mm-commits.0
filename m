From: akpm@linux-foundation.org
Subject: + git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working.patch added to -mm tree
Date: Sun, 14 Oct 2007 22:02:17 -0700
Message-ID: <200710150502.l9F52HoS018286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXJOFCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 01:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com


The patch titled
     git-md-accel: fix type that is stopping raid5 grow from working.
has been added to the -mm tree.  Its filename is
     git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-md-accel: fix type that is stopping raid5 grow from working.
From: NeilBrown <neilb@suse.de>

This kmem_cache_create is creating a cache that already exists.  We could use
the alternate name, just like we do a few lines up.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Dan Williams" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/raid5.c~git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working drivers/md/raid5.c
--- a/drivers/md/raid5.c~git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working
+++ a/drivers/md/raid5.c
@@ -1380,7 +1380,7 @@ static int resize_stripes(raid5_conf_t *
 	if (!sc)
 		return -ENOMEM;
 
-	sc_q = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+	sc_q = kmem_cache_create(conf->sq_cache_name[1-conf->active_name],
 			       (sizeof(struct stripe_queue)+(newsize-1) *
 				sizeof(struct r5_queue_dev)) +
 				r5_io_weight_size(newsize) +
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
shrink_dcache_sb-speedup.patch
menuconfig-transform-network-filesystems-menu.patch
fs-nfsd-exportc-make-3-functions-static.patch
md-software-raid-autodetect-dev-list-not-array.patch
bitmaph-remove-dead-artifacts.patch
md-fix-a-bug-in-some-never-used-code.patch
md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch
md-expose-the-degraded-status-of-an-assembled-array-through-sysfs.patch
md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
