From: akpm@linux-foundation.org
Subject: [merged] fs-affs-remove-redundant-sys_tz-declarations.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:36 -0700
Message-ID: <543d69b0.MJXusIFtq/RElb8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: remove redundant sys_tz declarations
has been removed from the -mm tree.  Its filename was
     fs-affs-remove-redundant-sys_tz-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: remove redundant sys_tz declarations

sys_tz is already declared in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    2 --
 fs/affs/inode.c    |    1 -
 fs/affs/super.c    |    2 --
 3 files changed, 5 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-extern struct timezone sys_tz;
-
 static char ErrorBuffer[256];
 
 /*
diff -puN fs/affs/inode.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/inode.c
@@ -14,7 +14,6 @@
 #include "affs.h"
 
 extern const struct inode_operations affs_symlink_inode_operations;
-extern struct timezone sys_tz;
 
 struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
diff -puN fs/affs/super.c~fs-affs-remove-redundant-sys_tz-declarations fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-remove-redundant-sys_tz-declarations
+++ a/fs/affs/super.c
@@ -20,8 +20,6 @@
 #include <linux/writeback.h>
 #include "affs.h"
 
-extern struct timezone sys_tz;
