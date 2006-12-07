From: akpm@osdl.org
Subject: - fuse-update-userspace-interface-to-version-78.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:35 -0800
Message-ID: <200612072301.kB7N1ZHI029776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163697AbWLGXCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: update userspace interface to version 7.8
has been removed from the -mm tree.  Its filename was
     fuse-update-userspace-interface-to-version-78.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: update userspace interface to version 7.8
From: Miklos Szeredi <miklos@szeredi.hu>

Add a flag to the RELEASE message which specifies that a FLUSH operation
should be performed as well.  This interface update is needed for the FreeBSD
port, and doesn't actually touch the Linux implementation at all.

Also rename the unused 'flush_flags' in the FLUSH message to 'unused'.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fuse.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/fuse.h~fuse-update-userspace-interface-to-version-78 include/linux/fuse.h
--- a/include/linux/fuse.h~fuse-update-userspace-interface-to-version-78
+++ a/include/linux/fuse.h
@@ -15,7 +15,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 7
+#define FUSE_KERNEL_MINOR_VERSION 8
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -92,6 +92,11 @@ struct fuse_file_lock {
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
 
+/**
+ * Release flags
+ */
+#define FUSE_RELEASE_FLUSH	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -205,12 +210,13 @@ struct fuse_open_out {
 struct fuse_release_in {
 	__u64	fh;
 	__u32	flags;
-	__u32	padding;
+	__u32	release_flags;
+	__u64	lock_owner;
 };
 
 struct fuse_flush_in {
 	__u64	fh;
-	__u32	flush_flags;
+	__u32	unused;
 	__u32	padding;
 	__u64	lock_owner;
 };
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

