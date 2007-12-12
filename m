From: akpm@linux-foundation.org
Subject: + fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:42:45 -0800
Message-ID: <200712120842.lBC8gjBr001512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbXLLInH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     fs/reiserfs/xattr.c: use LIST_HEAD instead of LIST_HEAD_INIT
has been added to the -mm tree.  Its filename is
     fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/reiserfs/xattr.c: use LIST_HEAD instead of LIST_HEAD_INIT
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr.c~fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init
+++ a/fs/reiserfs/xattr.c
@@ -1034,7 +1034,7 @@ ssize_t reiserfs_listxattr(struct dentry
 }
 
 /* This is the implementation for the xattr plugin infrastructure */
-static struct list_head xattr_handlers = LIST_HEAD_INIT(xattr_handlers);
+static LIST_HEAD(xattr_handlers);
 static DEFINE_RWLOCK(handler_lock);
 
 static struct reiserfs_xattr_handler *find_xattr_handler_prefix(const char
_

Patches currently in -mm which might be from crquan@gmail.com are

git-net.patch
git-s390.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch
drivers-dma-iop-admac-use-list_head-instead-of-list_head_init.patch
