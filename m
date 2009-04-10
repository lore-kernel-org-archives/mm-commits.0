From: akpm@linux-foundation.org
Subject: + sysfs-use-memdup_user.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:35:40 -0700
Message-ID: <200904100535.n3A5ZeTw015132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935780AbZDJFhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, greg@kroah.com


The patch titled
     sysfs: use memdup_user()
has been added to the -mm tree.  Its filename is
     sysfs-use-memdup_user.patch

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

documentation-sysctl-nettxt-fix-a-typo.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
xattr-use-memdup_user.patch
btrfs-use-memdup_user.patch
sysfs-use-memdup_user.patch
xfs-use-memdup_user.patch
ncpfs-use-memdup_user.patch
ecryptfs-use-memdup_user.patch

