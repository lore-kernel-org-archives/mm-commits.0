From: akpm@linux-foundation.org
Subject: - disable-init-initramfsc-updated-fix.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:12:50 -0800
Message-ID: <200702100812.l1A8CohH006968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39327 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbXBJINH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, frederik.deweerdt@gmail.com, jean-paul.saman@nxp.com, mm-commits@vger.kernel.org


The patch titled
     disable-init-initramfsc-updated fix
has been removed from the -mm tree.  Its filename was
     disable-init-initramfsc-updated-fix.patch

This patch was dropped because it was folded into disable-init-initramfsc-updated.patch

------------------------------------------------------
Subject: disable-init-initramfsc-updated fix
From: Frederik Deweerdt <deweerdt@free.fr>

The following patch silences the following compile time warning introduced
by the disable-init-initramfsc-updated patch:

  CC      init/noinitramfs.o
  init/noinitramfs.c:42: warning : initialization from incompatible pointer type

In addition, I've cleaned up the headers and added some error handling.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Jean-Paul Saman <jean-paul.saman@nxp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/noinitramfs.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff -puN init/noinitramfs.c~disable-init-initramfsc-updated-fix init/noinitramfs.c
--- a/init/noinitramfs.c~disable-init-initramfsc-updated-fix
+++ a/init/noinitramfs.c
@@ -18,25 +18,35 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 #include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/fcntl.h>
-#include <linux/delay.h>
-#include <linux/string.h>
+#include <linux/stat.h>
+#include <linux/kdev_t.h>
 #include <linux/syscalls.h>
 
 /*
  * Create a simple rootfs that is similar to the default initramfs
  */
-static void __init default_rootfs(void)
+static int __init default_rootfs(void)
 {
-	int mkdir_err = sys_mkdir("/dev", 0755);
-	int err = sys_mknod((const char __user *) "/dev/console",
-				S_IFCHR | S_IRUSR | S_IWUSR,
-				new_encode_dev(MKDEV(5, 1)));
-	if (err == -EROFS)
-		printk("Warning: Failed to create a rootfs\n");
-	mkdir_err = sys_mkdir("/root", 0700);
+	int err;
+
+	err = sys_mkdir("/dev", 0755);
+	if (err < 0)
+		goto out;
+
+	err = sys_mknod((const char __user *) "/dev/console",
+			S_IFCHR | S_IRUSR | S_IWUSR,
+			new_encode_dev(MKDEV(5, 1)));
+	if (err < 0)
+		goto out;
+
+	err = sys_mkdir("/root", 0700);
+	if (err < 0)
+		goto out;
+
+	return 0;
+
+out:
+	printk(KERN_WARNING "Failed to create a rootfs\n");
+	return err;
 }
 rootfs_initcall(default_rootfs);
_

Patches currently in -mm which might be from deweerdt@free.fr are

origin.patch
disable-init-initramfsc-updated.patch
disable-init-initramfsc-updated-fix.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
reiser4-sb_sync_inodes-fix.patch
