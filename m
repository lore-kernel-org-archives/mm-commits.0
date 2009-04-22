From: akpm@linux-foundation.org
Subject: [merged] sysfs-use-memdup_user.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:03 -0700
Message-ID: <200904221831.n3MIV3SQ006555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbZDVSdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: use memdup_user()
has been removed from the -mm tree.  Its filename was
     sysfs-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-use-memdup_user fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-use-memdup_user
+++ a/fs/sysfs/bin.c
@@ -157,14 +157,9 @@ static ssize_t write(struct file *file, 
 			count = size - offs;
 	}
 
-	temp = kmalloc(count, GFP_KERNEL);
-	if (!temp)
-		return -ENOMEM;
-
-	if (copy_from_user(temp, userbuf, count)) {
-		count = -EFAULT;
-		goto out_free;
-	}
+	temp = memdup_user(userbuf, count);
+	if (IS_ERR(temp))
+		return PTR_ERR(temp);
 
 	mutex_lock(&bb->mutex);
 
@@ -176,8 +171,6 @@ static ssize_t write(struct file *file, 
 	if (count > 0)
 		*off = offs + count;
 
-out_free:
-	kfree(temp);
 	return count;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

