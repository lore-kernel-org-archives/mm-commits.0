From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-use-memdup_user.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:28 -0700
Message-ID: <200904221831.n3MIVSJ9006757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbZDVSel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: use memdup_user()
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/miscdev.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/miscdev.c~ecryptfs-use-memdup_user fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-use-memdup_user
+++ a/fs/ecryptfs/miscdev.c
@@ -418,18 +418,13 @@ ecryptfs_miscdev_write(struct file *file
 
 	if (count == 0)
 		goto out;
-	data = kmalloc(count, GFP_KERNEL);
-	if (!data) {
-		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc([%zd], GFP_KERNEL)\n", __func__, count);
+
+	data = memdup_user(buf, count);
+	if (IS_ERR(data)) {
+		printk(KERN_ERR "%s: memdup_user returned error [%ld]\n",
+		       __func__, PTR_ERR(data));
 		goto out;
 	}
-	rc = copy_from_user(data, buf, count);
-	if (rc) {
-		printk(KERN_ERR "%s: copy_from_user returned error [%d]\n",
-		       __func__, rc);
-		goto out_free;
-	}
 	sz = count;
 	i = 0;
 	switch (data[i++]) {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

