From: akpm@linux-foundation.org
Subject: - document-nlink-function.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:12 -0700
Message-ID: <200706250921.l5P9LCjp031077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbXFYJV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     document nlink function
has been removed from the -mm tree.  Its filename was
     document-nlink-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: document nlink function
From: Dave Hansen <haveblue@us.ibm.com>

These should have been documented from the beginning.  Fix it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN include/linux/fs.h~document-nlink-function include/linux/fs.h
--- a/include/linux/fs.h~document-nlink-function
+++ a/include/linux/fs.h
@@ -1211,6 +1211,14 @@ static inline void mark_inode_dirty_sync
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+/**
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
 static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
@@ -1222,11 +1230,30 @@ static inline void inode_inc_link_count(
 	mark_inode_dirty(inode);
 }
 
+/**
+ * drop_nlink - directly drop an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  In cases
+ * where we are attempting to track writes to the
+ * filesystem, a decrement to zero means an imminent
+ * write when the file is truncated and actually unlinked
+ * on the filesystem.
+ */
 static inline void drop_nlink(struct inode *inode)
 {
 	inode->i_nlink--;
 }
 
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ */
 static inline void clear_nlink(struct inode *inode)
 {
 	inode->i_nlink = 0;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

ext3-remove-extra-is_rdonly-check.patch
ext4-remove-extra-is_rdonly-check.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
page-owner-tracking-leak-detector.patch
