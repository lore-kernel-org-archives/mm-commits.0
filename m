From: akpm@linux-foundation.org
Subject: - rndis-switch-to-seq_files.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:37 -0700
Message-ID: <200805202114.m4KLEbvT011481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071AbYETVPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rndis: switch to seq_files
has been removed from the -mm tree.  Its filename was
     rndis-switch-to-seq_files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rndis: switch to seq_files
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/rndis.c |   53 ++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff -puN drivers/usb/gadget/rndis.c~rndis-switch-to-seq_files drivers/usb/gadget/rndis.c
--- a/drivers/usb/gadget/rndis.c~rndis-switch-to-seq_files
+++ a/drivers/usb/gadget/rndis.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/netdevice.h>
 
 #include <asm/io.h>
@@ -1296,14 +1297,11 @@ int rndis_rm_hdr(struct sk_buff *skb)
 
 #ifdef	CONFIG_USB_GADGET_DEBUG_FILES
 
-static int rndis_proc_read (char *page, char **start, off_t off, int count, int *eof,
-		void *data)
+static int rndis_proc_show(struct seq_file *m, void *v)
 {
-	char *out = page;
-	int len;
-	rndis_params *param = (rndis_params *) data;
+	rndis_params *param = m->private;
 
-	out += snprintf (out, count,
+	seq_printf(m,
 			 "Config Nr. %d\n"
 			 "used      : %s\n"
 			 "state     : %s\n"
@@ -1326,25 +1324,13 @@ static int rndis_proc_read (char *page, 
 			 (param->media_state) ? 0 : param->speed*100,
 			 (param->media_state) ? "disconnected" : "connected",
 			 param->vendorID, param->vendorDescr);
-
-	len = out - page;
-	len -= off;
-
-	if (len < count) {
-		*eof = 1;
-		if (len <= 0)
-			return 0;
-	} else
-		len = count;
-
-	*start = page + off;
-	return len;
+	return 0;
 }
 
-static int rndis_proc_write (struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
+		size_t count, loff_t *ppos)
 {
-	rndis_params *p = data;
+	rndis_params *p = PDE(file->f_path.dentry->d_inode)->data;
 	u32 speed = 0;
 	int i, fl_speed = 0;
 
@@ -1386,6 +1372,20 @@ static int rndis_proc_write (struct file
 	return count;
 }
 
+static int rndis_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rndis_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations rndis_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rndis_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= rndis_proc_write,
+};
+
 #define	NAME_TEMPLATE	"driver/rndis-%03d"
 
 static struct proc_dir_entry *rndis_connect_state [RNDIS_MAX_CONFIGS];
@@ -1403,7 +1403,9 @@ int __init rndis_init (void)
 
 		sprintf (name, NAME_TEMPLATE, i);
 		if (!(rndis_connect_state [i]
-				= create_proc_entry (name, 0660, NULL)))
+				= proc_create_data(name, 0660, NULL,
+					&rndis_proc_fops,
+					(void *)(rndis_per_dev_params + i))))
 		{
 			DBG("%s :remove entries", __func__);
 			while (i) {
@@ -1413,11 +1415,6 @@ int __init rndis_init (void)
 			DBG("\n");
 			return -EIO;
 		}
