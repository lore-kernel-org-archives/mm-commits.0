From: akpm@linux-foundation.org
Subject: + fs-mark-link_path_walk-static.patch added to -mm tree
Date: Thu, 24 May 2007 15:14:48 -0700
Message-ID: <200705242214.l4OMEmCa004584@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616AbXEXWPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsipek@cs.sunysb.edu, hch@lst.de, mhalcrow@us.ibm.com, neilb@suse.de, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fs: mark link_path_walk static
has been added to the -mm tree.  Its filename is
     fs-mark-link_path_walk-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs: mark link_path_walk static
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    4 +++-
 include/linux/namei.h |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~fs-mark-link_path_walk-static fs/namei.c
--- a/fs/namei.c~fs-mark-link_path_walk-static
+++ a/fs/namei.c
@@ -107,6 +107,8 @@
  * any extra contention...
  */
 
+static int fastcall link_path_walk(const char *name, struct nameidata *nd);
+
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
  * kernel data space before using them..
@@ -998,7 +1000,7 @@ return_err:
  * Retry the whole path once, forcing real lookup requests
  * instead of relying on the dcache.
  */
-int fastcall link_path_walk(const char *name, struct nameidata *nd)
+static int fastcall link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct nameidata save = *nd;
 	int result;
diff -puN include/linux/namei.h~fs-mark-link_path_walk-static include/linux/namei.h
--- a/include/linux/namei.h~fs-mark-link_path_walk-static
+++ a/include/linux/namei.h
@@ -73,7 +73,6 @@ extern int FASTCALL(path_lookup(const ch
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
-extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
 extern void path_release_on_umount(struct nameidata *);
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

git-unionfs.patch
ecryptfs-move-ecryptfs-docs-into-documentation-filesystems.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
