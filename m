From: akpm@linux-foundation.org
Subject: + reiser4-compile-warning-cleanups.patch added to -mm tree
Date: Mon, 04 Aug 2008 21:22:03 -0700
Message-ID: <200808050422.m754M38D016623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYHEEWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 00:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmh3093@gmail.com, edward.shishkin@gmail.com


The patch titled
     reiser4: compile warning cleanups
has been added to the -mm tree.  Its filename is
     reiser4-compile-warning-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: compile warning cleanups
From: "Ryan Hope" <rmh3093@gmail.com>

Clean up some reiser4 compile warnings:

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    2 +-
 fs/reiser4/plugin/inode_ops.c          |    3 +--
 fs/reiser4/plugin/object.h             |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-compile-warning-cleanups fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-compile-warning-cleanups
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -821,7 +821,7 @@ static int need_cut_or_align(struct inod
 static void align_or_cut_overhead(struct inode * inode,
 				  struct cluster_handle * ch, rw_op rw)
 {
-	int oh;
+	unsigned int oh;
 	cipher_plugin * cplug = inode_cipher_plugin(inode);
 
 	assert("edward-1402", need_cipher(inode));
diff -puN fs/reiser4/plugin/inode_ops.c~reiser4-compile-warning-cleanups fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~reiser4-compile-warning-cleanups
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -418,8 +418,7 @@ void *reiser4_follow_link_common(struct 
  *
  * Uses generic function to check for rwx permissions.
  */
-int reiser4_permission_common(struct inode *inode, int mask,
-			      struct nameidata *nameidata)
+int reiser4_permission_common(struct inode *inode, int mask)
 {
 	return generic_permission(inode, mask, NULL);
 }
diff -puN fs/reiser4/plugin/object.h~reiser4-compile-warning-cleanups fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-compile-warning-cleanups
+++ a/fs/reiser4/plugin/object.h
@@ -25,8 +25,7 @@ int reiser4_mknod_common(struct inode *p
 int reiser4_rename_common(struct inode *old_dir, struct dentry *old_name,
 			  struct inode *new_dir, struct dentry *new_name);
 void *reiser4_follow_link_common(struct dentry *, struct nameidata *data);
-int reiser4_permission_common(struct inode *, int mask,
-			      struct nameidata *nameidata);
+int reiser4_permission_common(struct inode *, int mask);
 int reiser4_setattr_common(struct dentry *, struct iattr *);
 int reiser4_getattr_common(struct vfsmount *mnt, struct dentry *,
 			   struct kstat *);
_

Patches currently in -mm which might be from rmh3093@gmail.com are

mm-fix-uninitialized-variables-for-find_vma_prepare-callers.patch
reiser4-compile-warning-cleanups.patch

