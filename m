From: akpm@linux-foundation.org
Subject: + fix-the-sysfs_add_file_to_group-interfaces.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:25:03 -0800
Message-ID: <200801100724.m0A7OhME010727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178AbYAJHYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     fix the sysfs_add_file_to_group interfaces
has been added to the -mm tree.  Its filename is
     fix-the-sysfs_add_file_to_group-interfaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix the sysfs_add_file_to_group interfaces
From: James Bottomley <James.Bottomley@HansenPartnership.com>

I can't see a reason why these shouldn't work on every group.  However,
they only seem to work on named groups.  This patch allows the group
functions to work on anonymous groups (those with NULL names).

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/sysfs/file.c~fix-the-sysfs_add_file_to_group-interfaces fs/sysfs/file.c
--- a/fs/sysfs/file.c~fix-the-sysfs_add_file_to_group-interfaces
+++ a/fs/sysfs/file.c
@@ -537,7 +537,11 @@ int sysfs_add_file_to_group(struct kobje
 	struct sysfs_dirent *dir_sd;
 	int error;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (group)
+		dir_sd = sysfs_get_dirent(kobj->sd, group);
+	else
+		dir_sd = sysfs_get(kobj->sd);
+
 	if (!dir_sd)
 		return -ENOENT;
 
@@ -625,7 +629,10 @@ void sysfs_remove_file_from_group(struct
 {
 	struct sysfs_dirent *dir_sd;
 
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (group)
+		dir_sd = sysfs_get_dirent(kobj->sd, group);
+	else
+		dir_sd = sysfs_get(kobj->sd);
 	if (dir_sd) {
 		sysfs_hash_and_remove(dir_sd, attr->name);
 		sysfs_put(dir_sd);
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

fix-the-sysfs_add_file_to_group-interfaces.patch
attribute_container-update-to-use-the-group-interface.patch
git-scsi-misc.patch
scsi-pending-arm-convert-to-accessors.patch
