From: akpm@linux-foundation.org
Subject: [merged] fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:48:46 -0700
Message-ID: <20120406184846.779F9A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39534 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2DFSsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:48:47 -0400
Received: by yenq2 with SMTP id q2so298563yen.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:48:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, david@fromorbit.com, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()
has been removed from the -mm tree.  Its filename was
     fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()

This size is user controllable, up to a maximum of XATTR_LIST_MAX (64k). 
So it's trivial for someone to trigger a stream of order:4 page allocation
errors.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xattr.c~fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr
+++ a/fs/xattr.c
@@ -496,7 +496,7 @@ listxattr(struct dentry *d, char __user 
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
-		klist = kmalloc(size, GFP_KERNEL);
+		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
 		if (!klist)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch

