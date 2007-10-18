From: akpm@linux-foundation.org
Subject: - md-fix-a-bug-in-some-never-used-code.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:57 -0700
Message-ID: <200710180702.l9I72vSD031317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761207AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix a bug in some never-used code.
has been removed from the -mm tree.  Its filename was
     md-fix-a-bug-in-some-never-used-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix a bug in some never-used code.
From: NeilBrown <neilb@suse.de>

http://bugzilla.kernel.org/show_bug.cgi?id=3277

There is a seq_printf here that isn't being passed a 'seq'.  Howeve as the
code is inside #ifdef MD_DEBUG, nobody noticed.

Also remove some extra spaces.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid0.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/md/raid0.c~md-fix-a-bug-in-some-never-used-code drivers/md/raid0.c
--- a/drivers/md/raid0.c~md-fix-a-bug-in-some-never-used-code
+++ a/drivers/md/raid0.c
@@ -472,7 +472,7 @@ bad_map:
 	bio_io_error(bio);
 	return 0;
 }
-			   
+
 static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG
@@ -480,18 +480,18 @@ static void raid0_status (struct seq_fil
 	int j, k, h;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-  
+
 	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		seq_printf(seq, "      z%d", j);
 		if (conf->hash_table[h] == conf->strip_zone+j)
-			seq_printf("(h%d)", h++);
+			seq_printf(seq, "(h%d)", h++);
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			seq_printf (seq, "%s/", bdevname(
+			seq_printf(seq, "%s/", bdevname(
 				conf->strip_zone[j].dev[k]->bdev,b));
 
-		seq_printf (seq, "] zo=%d do=%d s=%d\n",
+		seq_printf(seq, "] zo=%d do=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
 				conf->strip_zone[j].dev_offset,
 				conf->strip_zone[j].size);
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
