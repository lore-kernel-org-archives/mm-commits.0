From: akpm@linux-foundation.org
Subject: - sysfs-cleanup-semaphoreh-usage.patch removed from -mm tree
Date: Tue, 31 Jul 2007 13:30:08 -0700
Message-ID: <200707312030.l6VKU8r6020942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933041AbXGaUay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 16:30:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: cleanup semaphore.h usage
has been removed from the -mm tree.  Its filename was
     sysfs-cleanup-semaphoreh-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: cleanup semaphore.h usage
From: Dave Young <hidave.darkstar@gmail.com>

Cleanup semaphore.h usage.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/bin.c     |    2 +-
 fs/sysfs/dir.c     |    2 +-
 fs/sysfs/group.c   |    1 -
 fs/sysfs/inode.c   |    1 -
 fs/sysfs/mount.c   |    1 -
 fs/sysfs/symlink.c |    2 +-
 6 files changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/bin.c
@@ -14,9 +14,9 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -puN fs/sysfs/dir.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/dir.c
@@ -11,7 +11,7 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include "sysfs.h"
 
 static void sysfs_prune_shadow_sd(struct sysfs_dirent *sd);
diff -puN fs/sysfs/group.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/group.c
--- a/fs/sysfs/group.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/group.c
@@ -13,7 +13,6 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 
diff -puN fs/sysfs/inode.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/inode.c
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff -puN fs/sysfs/mount.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/mount.c
@@ -8,7 +8,6 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -puN fs/sysfs/symlink.c~sysfs-cleanup-semaphoreh-usage fs/sysfs/symlink.c
--- a/fs/sysfs/symlink.c~sysfs-cleanup-semaphoreh-usage
+++ a/fs/sysfs/symlink.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "sysfs.h"
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

hpettxt-broken-link-fix.patch
zisofs-use-mutex-instead-of-semaphore.patch
