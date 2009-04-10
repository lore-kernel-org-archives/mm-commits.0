From: akpm@linux-foundation.org
Subject: + xfs-use-memdup_user.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:35:42 -0700
Message-ID: <200904100535.n3A5ZgJU015137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759128AbZDJFim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, felixb@sgi.com, hch@lst.de


The patch titled
     xfs: use memdup_user()
has been added to the -mm tree.  Its filename is
     xfs-use-memdup_user.patch

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
Subject: xfs: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
 2 files changed, 11 insertions(+), 24 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~xfs-use-memdup_user fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~xfs-use-memdup_user
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
 	if (len > XATTR_SIZE_MAX)
 		return EINVAL;
 
-	kbuf = kmalloc(len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
-
-	if (copy_from_user(kbuf, ubuf, len))
-		goto out_kfree;
+	kbuf = memdup_user(ubuf, len);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
 
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
 
- out_kfree:
-	kfree(kbuf);
 	return error;
 }
 
@@ -540,20 +535,16 @@ xfs_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(am_hreq.ops, size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, am_hreq.ops, size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		ops[i].am_error = strncpy_from_user(attr_name,
diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~xfs-use-memdup_user fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~xfs-use-memdup_user
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -427,20 +427,16 @@ xfs_compat_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(compat_ptr(am_hreq.ops), size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, compat_ptr(am_hreq.ops), size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
