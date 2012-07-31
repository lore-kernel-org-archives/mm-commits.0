From: akpm@linux-foundation.org
Subject: [merged] fs-xattrc-getxattr-improve-handling-of-allocation-failures.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:47:49 -0700
Message-ID: <20120731184750.15B425C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64574 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaSrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:47:52 -0400
Received: by fat25 with SMTP id 25so290408fat.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:47:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c:getxattr(): improve handling of allocation failures
has been removed from the -mm tree.  Its filename was
     fs-xattrc-getxattr-improve-handling-of-allocation-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <levinsasha928@gmail.com>
Subject: fs/xattr.c:getxattr(): improve handling of allocation failures

This allocation can be as large as 64k.

 - Add __GFP_NOWARN so the falied kmalloc() is silent

 - Fall back to vmalloc() if the kmalloc() failed

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-getxattr-improve-handling-of-allocation-failures fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-getxattr-improve-handling-of-allocation-failures
+++ a/fs/xattr.c
@@ -427,6 +427,7 @@ getxattr(struct dentry *d, const char __
 {
 	ssize_t error;
 	void *kvalue = NULL;
+	void *vvalue = NULL;
 	char kname[XATTR_NAME_MAX + 1];
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
@@ -438,9 +439,13 @@ getxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			size = XATTR_SIZE_MAX;
-		kvalue = kzalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
+		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!kvalue) {
+			vvalue = vmalloc(size);
+			if (!vvalue)
+				return -ENOMEM;
+			kvalue = vvalue;
+		}
 	}
 
 	error = vfs_getxattr(d, kname, kvalue, size);
@@ -452,7 +457,10 @@ getxattr(struct dentry *d, const char __
 		   than XATTR_SIZE_MAX bytes. Not possible. */
 		error = -E2BIG;
 	}
-	kfree(kvalue);
+	if (vvalue)
+		vfree(vvalue);
+	else
+		kfree(kvalue);
 	return error;
 }
 
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch

