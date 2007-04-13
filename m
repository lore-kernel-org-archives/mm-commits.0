From: akpm@linux-foundation.org
Subject: - sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:23 -0700
Message-ID: <200704132329.l3DNTN0F012618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161120AbXDMX3Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: implement sysfs_dirent active reference and immediate disconnect (lockdep fix)
has been removed from the -mm tree.  Its filename was
     sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: implement sysfs_dirent active reference and immediate disconnect (lockdep fix)
From: Tejun Heo <htejun@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |    7 ++++++-
 fs/sysfs/sysfs.h |    5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/sysfs/dir.c~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix
+++ a/fs/sysfs/dir.c
@@ -25,8 +25,13 @@ void release_sysfs_dirent(struct sysfs_d
 	/* If @sd is being released after deletion, s_active is write
 	 * locked.  If @sd is cursor for directory walk or being
 	 * released prematurely, s_active has no reader or writer.
+	 *
+	 * sysfs_deactivate() lies to lockdep that s_active is
+	 * unlocked immediately.  Lie one more time to cover the
+	 * previous lie.
 	 */
-	down_write_trylock(&sd->s_active);
+	if (!down_write_trylock(&sd->s_active))
+		rwsem_acquire(&sd->s_active.dep_map, 0, 0, _RET_IP_);
 	up_write(&sd->s_active);
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
diff -puN fs/sysfs/sysfs.h~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix
+++ a/fs/sysfs/sysfs.h
@@ -187,6 +187,11 @@ static inline void sysfs_put_active_two(
 static inline void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	down_write(&sd->s_active);
+
+	/* s_active will be unlocked by the thread doing the final put
+	 * on @sd.  Lie to lockdep.
+	 */
+	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
 }
 
 static inline int sysfs_is_shadowed_inode(struct inode *inode)
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
