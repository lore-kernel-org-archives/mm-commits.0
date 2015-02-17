From: akpm@linux-foundation.org
Subject: [merged] ext2-remove-xipc-and-xiph.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:51 -0800
Message-ID: <54e39f1f.d3hMRocjiGuNfds5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext2: remove xip.c and xip.h
has been removed from the -mm tree.  Its filename was
     ext2-remove-xipc-and-xiph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: ext2: remove xip.c and xip.h

These files are now empty, so delete them

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/Makefile |    1 -
 fs/ext2/inode.c  |    1 -
 fs/ext2/namei.c  |    1 -
 fs/ext2/super.c  |    1 -
 fs/ext2/xip.c    |   15 ---------------
 fs/ext2/xip.h    |   16 ----------------
 6 files changed, 35 deletions(-)

diff -puN fs/ext2/Makefile~ext2-remove-xipc-and-xiph fs/ext2/Makefile
--- a/fs/ext2/Makefile~ext2-remove-xipc-and-xiph
+++ a/fs/ext2/Makefile
@@ -10,4 +10,3 @@ ext2-y := balloc.o dir.o file.o ialloc.o
 ext2-$(CONFIG_EXT2_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext2-$(CONFIG_EXT2_FS_POSIX_ACL) += acl.o
 ext2-$(CONFIG_EXT2_FS_SECURITY)	 += xattr_security.o
-ext2-$(CONFIG_EXT2_FS_XIP)	 += xip.o
diff -puN fs/ext2/inode.c~ext2-remove-xipc-and-xiph fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-remove-xipc-and-xiph
+++ a/fs/ext2/inode.c
@@ -34,7 +34,6 @@
 #include <linux/aio.h>
 #include "ext2.h"
 #include "acl.h"
-#include "xip.h"
 #include "xattr.h"
 
 static int __ext2_write_inode(struct inode *inode, int do_sync);
diff -puN fs/ext2/namei.c~ext2-remove-xipc-and-xiph fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-remove-xipc-and-xiph
+++ a/fs/ext2/namei.c
@@ -35,7 +35,6 @@
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "xip.h"
 
 static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
 {
diff -puN fs/ext2/super.c~ext2-remove-xipc-and-xiph fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-remove-xipc-and-xiph
+++ a/fs/ext2/super.c
@@ -35,7 +35,6 @@
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
-#include "xip.h"
 
 static void ext2_sync_super(struct super_block *sb,
 			    struct ext2_super_block *es, int wait);
diff -puN fs/ext2/xip.c~ext2-remove-xipc-and-xiph /dev/null
--- a/fs/ext2/xip.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- *  linux/fs/ext2/xip.c
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte (cotte@de.ibm.com)
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/genhd.h>
-#include <linux/buffer_head.h>
-#include <linux/blkdev.h>
-#include "ext2.h"
-#include "xip.h"
-
diff -puN fs/ext2/xip.h~ext2-remove-xipc-and-xiph /dev/null
--- a/fs/ext2/xip.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- *  linux/fs/ext2/xip.h
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte (cotte@de.ibm.com)
- */
