From: akpm@linux-foundation.org
Subject: - sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:41 -0700
Message-ID: <200708242058.l7OKwfW6014326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762533AbXHXVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, cornelia.huck@de.ibm.com, greg@kroah.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: don't warn on removal of a nonexistent binary file
has been removed from the -mm tree.  Its filename was
     sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: don't warn on removal of a nonexistent binary file
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as960) removes the error message and stack dump logged by
sysfs_remove_bin_file() when someone tries to remove a nonexistent file. 
The warning doesn't seem to be needed, since none of the other file-,
symlink-, or directory-removal routines in sysfs complain in a comparable
way.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file
+++ a/fs/sysfs/bin.c
@@ -248,12 +248,7 @@ int sysfs_create_bin_file(struct kobject
 
 void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
-	if (sysfs_hash_and_remove(kobj->sd, attr->attr.name) < 0) {
-		printk(KERN_ERR "%s: "
-			"bad dentry or inode or no such file: \"%s\"\n",
-			__FUNCTION__, attr->attr.name);
-		dump_stack();
-	}
+	sysfs_hash_and_remove(kobj->sd, attr->attr.name);
 }
 
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
