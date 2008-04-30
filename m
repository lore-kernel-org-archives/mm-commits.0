From: akpm@linux-foundation.org
Subject: - devpts-factor-out-pty-index-allocation-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:16:24 -0700
Message-ID: <200804300616.m3U6GO9s031295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237AbYD3GQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, matthltc@us.ibm.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts-factor-out-pty-index-allocation-fix
has been removed from the -mm tree.  Its filename was
     devpts-factor-out-pty-index-allocation-fix.patch

This patch was dropped because it was folded into devpts-factor-out-pty-index-allocation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts-factor-out-pty-index-allocation-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/devpts/inode.c~devpts-factor-out-pty-index-allocation-fix fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-factor-out-pty-index-allocation-fix
+++ a/fs/devpts/inode.c
@@ -17,6 +17,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/tty.h>
+#include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
@@ -29,7 +30,7 @@
 
 extern int pty_limit;			/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_MUTEX(allocated_ptys_lock);
 
 static struct vfsmount *devpts_mnt;
 static struct dentry *devpts_root;
@@ -186,10 +187,10 @@ retry:
 		return -ENOMEM;
 	}
 
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			goto retry;
 		return -EIO;
@@ -197,18 +198,18 @@ retry:
 
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 	return index;
 }
 
 void devpts_kill_index(int idx)
 {
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, idx);
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 }
 
 int devpts_pty_new(struct tty_struct *tty)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

