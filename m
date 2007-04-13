From: akpm@linux-foundation.org
Subject: + sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:06:48 -0700
Message-ID: <200704131906.l3DJ6mk9007162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbXDMTGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     sysfs: implement sysfs_dirent active reference and immediate disconnect (lockdep fix)
has been added to the -mm tree.  Its filename is
     sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
revert-gregkh-driver-sysfs-crash-debugging.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-lockdep-fix.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-update.patch
sysfs-kill-unnecessary-attribute-owner-update-fix.patch
sysfs-kill-unnecessary-attribute-owner-vs-gregkh-driver-uio.patch
sysfs-make-lockdep-ignore-s_active.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
