From: akpm@linux-foundation.org
Subject: + ecryptfs-use-memdup_user.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:35:46 -0700
Message-ID: <200904100535.n3A5ZkZX015173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758670AbZDJFih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: use memdup_user()
has been added to the -mm tree.  Its filename is
     ecryptfs-use-memdup_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-sysctl-nettxt-fix-a-typo.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
xattr-use-memdup_user.patch
btrfs-use-memdup_user.patch
sysfs-use-memdup_user.patch
xfs-use-memdup_user.patch
ncpfs-use-memdup_user.patch
ecryptfs-use-memdup_user.patch

