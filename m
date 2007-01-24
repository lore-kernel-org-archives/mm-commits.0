From: akpm@osdl.org
Subject: + seq_file-conversion-toshibac.patch added to -mm tree
Date: Tue, 23 Jan 2007 17:13:43 -0800
Message-ID: <200701240113.l0O1DhMO004699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965471AbXAXBNu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 20:13:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, dtor_core@ameritech.net


The patch titled
     seq_file conversion: toshiba.c
has been added to the -mm tree.  Its filename is
     seq_file-conversion-toshibac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: seq_file conversion: toshiba.c
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dmitry Torokhov <dtor_core@ameritech.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/toshiba.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff -puN drivers/char/toshiba.c~seq_file-conversion-toshibac drivers/char/toshiba.c
--- a/drivers/char/toshiba.c~seq_file-conversion-toshibac
+++ a/drivers/char/toshiba.c
@@ -68,6 +68,7 @@
 #include <linux/init.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <linux/toshiba.h>
 
@@ -298,12 +299,10 @@ static int tosh_ioctl(struct inode *ip, 
  * Print the information for /proc/toshiba
  */
 #ifdef CONFIG_PROC_FS
-static int tosh_get_info(char *buffer, char **start, off_t fpos, int length)
+static int proc_toshiba_show(struct seq_file *m, void *v)
 {
-	char *temp;
 	int key;
 
-	temp = buffer;
 	key = tosh_fn_status();
 
 	/* Arguments
@@ -314,8 +313,7 @@ static int tosh_get_info(char *buffer, c
 	     4) BIOS date (in SCI date format)
 	     5) Fn Key status
 	*/
-
-	temp += sprintf(temp, "1.1 0x%04x %d.%d %d.%d 0x%04x 0x%02x\n",
+	seq_printf(m, "1.1 0x%04x %d.%d %d.%d 0x%04x 0x%02x\n",
 		tosh_id,
 		(tosh_sci & 0xff00)>>8,
 		tosh_sci & 0xff,
@@ -323,9 +321,21 @@ static int tosh_get_info(char *buffer, c
 		tosh_bios & 0xff,
 		tosh_date,
 		key);
+	return 0;
+}
 
-	return temp-buffer;
+static int proc_toshiba_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_toshiba_show, NULL);
 }
+
+static const struct file_operations proc_toshiba_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_toshiba_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 
@@ -508,10 +518,15 @@ static int __init toshiba_init(void)
 		return retval;
 
 #ifdef CONFIG_PROC_FS
-	/* register the proc entry */
-	if (create_proc_info_entry("toshiba", 0, NULL, tosh_get_info) == NULL) {
-		misc_deregister(&tosh_device);
-		return -ENOMEM;
+	{
+		struct proc_dir_entry *pde;
+
+		pde = create_proc_entry("toshiba", 0, NULL);
+		if (!pde) {
+			misc_deregister(&tosh_device);
+			return -ENOMEM;
+		}
+		pde->proc_fops = &proc_toshiba_fops;
 	}
 #endif
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
proc-remove-useless-and-buggy-nlink-settings.patch
seq_file-conversion-coda.patch
seq_file-conversion-toshibac.patch
