From: akpm@linux-foundation.org
Subject: - git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:30 -0700
Message-ID: <200710180705.l9I75UBX031652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120AbXJRHPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-md-accel: fix type that is stopping raid5 grow from working.
has been removed from the -mm tree.  Its filename was
     git-md-accel-fix-type-that-is-stopping-raid5-grow-from-working.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-md-accel.patch
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
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
