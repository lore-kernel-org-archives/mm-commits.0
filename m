From: akpm@linux-foundation.org
Subject: + fs-xattrc-getxattr-improve-handling-of-allocation-failures.patch added to -mm tree
Date: Fri, 08 Jun 2012 16:16:31 -0700
Message-ID: <20120608231632.0EFBBA011A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35155 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484Ab2FHXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 19:16:33 -0400
Received: by ghbz15 with SMTP id z15so218377ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 16:16:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/xattr.c:getxattr(): improve handling of allocation failures
has been added to the -mm tree.  Its filename is
     fs-xattrc-getxattr-improve-handling-of-allocation-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs/xattr.c:getxattr(): improve handling of allocation failures

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch
fs-xattrc-getxattr-improve-handling-of-allocation-failures.patch

