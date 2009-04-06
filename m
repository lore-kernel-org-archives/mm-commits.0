From: akpm@linux-foundation.org
Subject: [folded] vfs-simple_set_mnt-should-return-void-fix-nilfs.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:38:16 -0700
Message-ID: <200904062238.n36McG40019225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451AbZDFWiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:38:51 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n36McHaY004152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 6 Apr 2009 15:38:49 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     vfs-simple_set_mnt-should-return-void-fix-nilfs
has been removed from the -mm tree.  Its filename was
     vfs-simple_set_mnt-should-return-void-fix-nilfs.patch

This patch was dropped because it was folded into nilfs2-super-block-operations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-simple_set_mnt-should-return-void-fix-nilfs
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~vfs-simple_set_mnt-should-return-void-fix-nilfs fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~vfs-simple_set_mnt-should-return-void-fix-nilfs
+++ a/fs/nilfs2/super.c
@@ -1220,7 +1220,8 @@ nilfs_get_sb(struct file_system_type *fs
 	put_nilfs(nilfs);
 	if (need_to_close)
 		close_bdev_exclusive(sd.bdev, flags);
-	return simple_set_mnt(mnt, s);
+	simple_set_mnt(mnt, s);
+	return 0;
 
  error_s:
 	up(&sd.bdev->bd_mount_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-super-block-operations.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

