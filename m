From: akpm@linux-foundation.org
Subject: + fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch added to -mm tree
Date: Tue, 27 Mar 2012 15:49:08 -0700
Message-ID: <20120327224908.CE00CA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:64528 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2C0WtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 18:49:11 -0400
Received: by wgbdt11 with SMTP id dt11so19457wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 15:49:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()
has been added to the -mm tree.  Its filename is
     fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()

This size is user controllable, up to a maximum of XATTR_LIST_MAX (64k). 
So it's trivial for someone to trigger a stream of order:4 page allocation
errors.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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
Subject: Subject: fs/xattr.c: suppress page allocation failure warnings from sys_listxattr()

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
fs-xattrc-suppress-page-allocation-failure-warnings-from-sys_listxattr.patch

