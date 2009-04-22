From: akpm@linux-foundation.org
Subject: [merged] xattr-use-memdup_user.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:09 -0700
Message-ID: <200904221831.n3MIV9wW006566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbZDVSeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, agruen@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     xattr: use memdup_user()
has been removed from the -mm tree.  Its filename was
     xattr-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

