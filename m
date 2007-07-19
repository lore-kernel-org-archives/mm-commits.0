From: akpm@linux-foundation.org
Subject: + sysfs-avoid-kmem_cache_freenull.patch added to -mm tree
Date: Wed, 18 Jul 2007 20:04:40 -0700
Message-ID: <200707190304.l6J34ejc010735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbXGSDEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 23:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de


The patch titled
     sysfs: avoid kmem_cache_free(NULL)
has been added to the -mm tree.  Its filename is
     sysfs-avoid-kmem_cache_freenull.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: avoid kmem_cache_free(NULL)
From: Akinobu Mita <akinobu.mita@gmail.com>

kmem_cache_free() with NULL is not allowed.  But it may happen if out of
memory error is triggered in sysfs_new_dirent().  This patch fixes that
error handling.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-avoid-kmem_cache_freenull fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-avoid-kmem_cache_freenull
+++ a/fs/sysfs/dir.c
@@ -361,20 +361,20 @@ static struct dentry_operations sysfs_de
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
-	struct sysfs_dirent *sd = NULL;
+	struct sysfs_dirent *sd;
 
 	if (type & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
-			goto err_out;
+			return NULL;
 	}
 
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		goto err_out;
+		goto err_out1;
 
 	if (sysfs_alloc_ino(&sd->s_ino))
-		goto err_out;
+		goto err_out2;
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
@@ -386,9 +386,10 @@ struct sysfs_dirent *sysfs_new_dirent(co
 
 	return sd;
 
- err_out:
-	kfree(dup_name);
+ err_out2:
 	kmem_cache_free(sysfs_dir_cachep, sd);
+ err_out1:
+	kfree(dup_name);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
sysfs-avoid-kmem_cache_freenull.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
