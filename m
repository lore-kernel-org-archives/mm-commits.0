From: akpm@linux-foundation.org
Subject: + sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:32:14 -0700
Message-ID: <200704110632.l3B6WEcS030363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161213AbXDKGc4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: implement sysfs_dirent active reference and immediate disconnect (update)
has been added to the -mm tree.  Its filename is
     sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: implement sysfs_dirent active reference and immediate disconnect (update)
From: Tejun Heo <htejun@gmail.com>

Cornelia, this should fix the problem you reported.  It's caused by
doing up_write() on sysfs_dirent which is used for readdir cursor
which is not deactivated before being released.
release_sysfs_dirent() is udpated such that it does
down_write_trylock() on s_active before doing up_write().  This also
covers error paths where allocated sysfs_dirent is put due to errors
during initialization.

Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/sysfs/dir.c~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update
+++ a/fs/sysfs/dir.c
@@ -22,7 +22,11 @@ void release_sysfs_dirent(struct sysfs_d
  repeat:
 	parent_sd = sd->s_parent;
 
-	/* s_active must have been write locked by sysfs_deactivate(), unlock */
+	/* If @sd is being released after deletion, s_active is write
+	 * locked.  If @sd is cursor for directory walk or being
+	 * released prematurely, s_active has no reader or writer.
+	 */
+	down_write_trylock(&sd->s_active);
 	up_write(&sd->s_active);
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
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
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
