From: akpm@linux-foundation.org
Subject: [merged] drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:17 -0700
Message-ID: <200906182247.n5IMlHwO006337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZFRW4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrianosf@uol.com.br, mm-commits@vger.kernel.org


The patch titled
     drivers/char/mem.c: memory_open() cleanup: lookup minor device number from devlist
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/mem.c: memory_open() cleanup: lookup minor device number from devlist
From: Adriano dos Santos Fernandes <adrianosf@uol.com.br>

memory_open() ignores devlist and does a switch for each item, duplicating
code and conditional definitions.

Clean it up by adding backing_dev_info to devlist and use it to lookup for
the minor device.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Adriano dos Santos Fernandes <adrianosf@uol.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |  115 ++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 70 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist
+++ a/drivers/char/mem.c
@@ -863,59 +863,58 @@ static const struct file_operations kmsg
 	.write =	kmsg_write,
 };
 
-static int memory_open(struct inode * inode, struct file * filp)
-{
-	int ret = 0;
-
-	lock_kernel();
-	switch (iminor(inode)) {
-		case 1:
-			filp->f_op = &mem_fops;
-			filp->f_mapping->backing_dev_info =
-				&directly_mappable_cdev_bdi;
-			break;
+static const struct {
+	unsigned int		minor;
+	char			*name;
+	umode_t			mode;
+	const struct file_operations	*fops;
+	struct backing_dev_info	*dev_info;
+} devlist[] = { /* list of minor devices */
+	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops,
+		&directly_mappable_cdev_bdi},
 #ifdef CONFIG_DEVKMEM
-		case 2:
-			filp->f_op = &kmem_fops;
-			filp->f_mapping->backing_dev_info =
-				&directly_mappable_cdev_bdi;
-			break;
+	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops,
+		&directly_mappable_cdev_bdi},
 #endif
-		case 3:
-			filp->f_op = &null_fops;
-			break;
+	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops, NULL},
 #ifdef CONFIG_DEVPORT
-		case 4:
-			filp->f_op = &port_fops;
-			break;
+	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops, NULL},
 #endif
-		case 5:
-			filp->f_mapping->backing_dev_info = &zero_bdi;
-			filp->f_op = &zero_fops;
-			break;
-		case 7:
-			filp->f_op = &full_fops;
-			break;
-		case 8:
-			filp->f_op = &random_fops;
-			break;
-		case 9:
-			filp->f_op = &urandom_fops;
-			break;
-		case 11:
-			filp->f_op = &kmsg_fops;
-			break;
+	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops, &zero_bdi},
+	{7, "full",    S_IRUGO | S_IWUGO,           &full_fops, NULL},
+	{8, "random",  S_IRUGO | S_IWUSR,           &random_fops, NULL},
+	{9, "urandom", S_IRUGO | S_IWUSR,           &urandom_fops, NULL},
+	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops, NULL},
 #ifdef CONFIG_CRASH_DUMP
-		case 12:
-			filp->f_op = &oldmem_fops;
-			break;
+	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops, NULL},
 #endif
-		default:
-			unlock_kernel();
-			return -ENXIO;
+};
+
+static int memory_open(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+	int i;
+
+	lock_kernel();
+
+	for (i = 0; i < ARRAY_SIZE(devlist); i++) {
+		if (devlist[i].minor == iminor(inode)) {
+			filp->f_op = devlist[i].fops;
+			if (devlist[i].dev_info) {
+				filp->f_mapping->backing_dev_info =
+					devlist[i].dev_info;
+			}
+
+			break;
+		}
 	}
-	if (filp->f_op && filp->f_op->open)
-		ret = filp->f_op->open(inode,filp);
+
+	if (i == ARRAY_SIZE(devlist))
+		ret = -ENXIO;
+	else
+		if (filp->f_op && filp->f_op->open)
+			ret = filp->f_op->open(inode, filp);
+
 	unlock_kernel();
 	return ret;
 }
@@ -924,30 +923,6 @@ static const struct file_operations memo
 	.open		= memory_open,	/* just a selector for the real open */
 };
 
-static const struct {
-	unsigned int		minor;
-	char			*name;
-	umode_t			mode;
-	const struct file_operations	*fops;
-} devlist[] = { /* list of minor devices */
-	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
-#ifdef CONFIG_DEVKMEM
-	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
-#endif
-	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
-#ifdef CONFIG_DEVPORT
-	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
-#endif
-	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops},
-	{7, "full",    S_IRUGO | S_IWUGO,           &full_fops},
-	{8, "random",  S_IRUGO | S_IWUSR,           &random_fops},
-	{9, "urandom", S_IRUGO | S_IWUSR,           &urandom_fops},
-	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops},
-#ifdef CONFIG_CRASH_DUMP
-	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops},
-#endif
-};
