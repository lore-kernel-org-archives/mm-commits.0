From: akpm@linux-foundation.org
Subject: - sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:21 -0700
Message-ID: <200704132329.l3DNTL2f012615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161113AbXDMX3e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: implement sysfs_dirent active reference and immediate disconnect (update)
has been removed from the -mm tree.  Its filename was
     sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
