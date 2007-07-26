From: akpm@linux-foundation.org
Subject: + sysfs-cleanup-semaphoreh-usage.patch added to -mm tree
Date: Thu, 26 Jul 2007 00:42:10 -0700
Message-ID: <200707260742.l6Q7gAFK020689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761228AbXGZHnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 03:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysfs: cleanup semaphore.h usage
has been added to the -mm tree.  Its filename is
     sysfs-cleanup-semaphoreh-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sysfs-filec-use-mutex-instead-of-semaphore.patch
sysfs-cleanup-semaphoreh-usage.patch
zisofs-use-mutex-instead-of-semaphore.patch
hpettxt-broken-link-fix.patch
