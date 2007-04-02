From: akpm@linux-foundation.org
Subject: + display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:48:22 -0700
Message-ID: <200704020548.l325mMhK025350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbXDBFty (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@treblig.org, jengelh@gmx.de


The patch titled
     Display all possible partitions when the root filesystem failed to mount
has been added to the -mm tree.  Its filename is
     display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Display all possible partitions when the root filesystem failed to mount
From: Dave Gilbert <linux@treblig.org>

Display all possible partitions when the root filesystem is not mounted.
This helps to track spell'o's and missing drivers.

Updated to work with newer kernels.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c         |   54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    1 
 init/do_mounts.c      |    7 ++++-
 3 files changed, 61 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount block/genhd.c
--- a/block/genhd.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount
+++ a/block/genhd.c
@@ -215,6 +215,60 @@ struct gendisk *get_gendisk(dev_t dev, i
 	return  kobj ? to_disk(kobj) : NULL;
 }
 
+/*
+ * printk a full list of all partitions - intended for
+ * places where the root filesystem can't be mounted and thus
+ * to give the victim some idea of what went wrong
+ */
+void printk_all_partitions(void)
+{
+	int n;
+        struct gendisk* sgp;
+	mutex_lock(&block_subsys_lock);
+
+        /* For each block device... */
+	list_for_each_entry(sgp, &block_subsys.kset.list, kobj.entry) {
+		char buf[BDEVNAME_SIZE];
+	  	/*
+	  	 * Don't show empty devices or things that have been surpressed
+	  	 */
+		if (get_capacity(sgp) &&
+		  !(sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)) {
+			/*
+			 * Note, unlike /proc/partitions I am showing the
+			 * numbers in hex in the same format as the root=
+			 * option
+			 */
+			printk("%02x%02x %10llu %s",
+			       sgp->major, sgp->first_minor,
+			       (unsigned long long)get_capacity(sgp) >> 1,
+			       disk_name(sgp, 0, buf));
+			if ((sgp->driverfs_dev) &&
+			  (sgp->driverfs_dev->driver)) {
+				printk(" driver: %s\n",
+				       sgp->driverfs_dev->driver->name);
+			} else {
+				printk(" (driver?)\n");
+			}
+
+			/* now show the partitions */
+			for (n = 0; n < sgp->minors - 1; ++n) {
+				if (!sgp->part[n])
+					continue;
+				if (sgp->part[n]->nr_sects == 0)
+					continue;
+				printk("  %02x%02x %10llu %s\n",
+				       sgp->major, n + 1 + sgp->first_minor,
+				       (unsigned long long)sgp->part[n]->nr_sects >> 1 ,
+				       disk_name(sgp, n + 1, buf));
+			} /* partition subloop */
+		} /* Non 0 size, not surpressed */
+	} /* Block device loop */
+
+	mutex_unlock(&block_subsys_lock);
+	return;
+}
+
 #ifdef CONFIG_PROC_FS
 /* iterator */
 static void *part_start(struct seq_file *part, loff_t *pos)
diff -puN include/linux/genhd.h~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount include/linux/genhd.h
--- a/include/linux/genhd.h~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount
+++ a/include/linux/genhd.h
@@ -413,6 +413,7 @@ char *disk_name (struct gendisk *hd, int
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
+extern void printk_all_partitions(void);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
diff -puN init/do_mounts.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount init/do_mounts.c
--- a/init/do_mounts.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount
+++ a/init/do_mounts.c
@@ -7,6 +7,7 @@
 #include <linux/root_dev.h>
 #include <linux/security.h>
 #include <linux/delay.h>
+#include <linux/genhd.h>
 #include <linux/mount.h>
 #include <linux/device.h>
 #include <linux/init.h>
@@ -308,17 +309,21 @@ retry:
 	        /*
 		 * Allow the user to distinguish between failed sys_open
 		 * and bad superblock on root device.
+		 * and give them a list of the available devices
 		 */
 #ifdef CONFIG_BLOCK
 		__bdevname(ROOT_DEV, b);
 #endif
 		printk("VFS: Cannot open root device \"%s\" or %s\n",
 				root_device_name, b);
-		printk("Please append a correct \"root=\" boot option\n");
+		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
+		printk_all_partitions();
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 
+	printk("List of all partitions:\n");
+	printk_all_partitions();
 	printk("No filesystem could mount root, tried: ");
 	for (p = fs_names; *p; p += strlen(p)+1)
 		printk(" %s", p);
_

Patches currently in -mm which might be from linux@treblig.org are

display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
