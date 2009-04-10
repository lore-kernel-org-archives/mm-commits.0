From: akpm@linux-foundation.org
Subject: + xattr-use-memdup_user.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:35:36 -0700
Message-ID: <200904100535.n3A5ZanB015088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758899AbZDJFi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, agruen@suse.de, viro@zeniv.linux.org.uk


The patch titled
     xattr: use memdup_user()
has been added to the -mm tree.  Its filename is
     xattr-use-memdup_user.patch

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
Subject: xattr: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/xattr.c~xattr-use-memdup_user fs/xattr.c
--- a/fs/xattr.c~xattr-use-memdup_user
+++ a/fs/xattr.c
@@ -237,13 +237,9 @@ setxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kmalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			kfree(kvalue);
-			return -EFAULT;
-		}
+		kvalue = memdup_user(value, size);
+		if (IS_ERR(kvalue))
+			return PTR_ERR(kvalue);
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
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

