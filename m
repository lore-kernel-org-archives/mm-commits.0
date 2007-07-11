From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch added to -mm tree
Date: Wed, 11 Jul 2007 16:59:58 -0700
Message-ID: <200707112359.l6BNxwNI027781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936785AbXGLAAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     Sky Cpu and Nexus: use seq_file/single_open on proc interface
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: use seq_file/single_open on proc interface
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch changes proc interface to be used with
single_file/seq_open calls.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   66 ++++++++++++------------
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   52 ++++++++++++++----
 2 files changed, 74 insertions(+), 44 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -19,9 +19,10 @@
 #include <linux/spinlock.h>
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/hdpu_features.h>
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
-#include <linux/hdpu_features.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 #define SKY_CPUSTATE_VERSION		"1.1"
@@ -29,7 +30,30 @@
 static int hdpu_cpustate_probe(struct platform_device *pdev);
 static int hdpu_cpustate_remove(struct platform_device *pdev);
 
-struct cpustate_t cpustate;
+static unsigned char cpustate_get_state(void);
+static int cpustate_proc_open(struct inode *inode, struct file *file);
+static int cpustate_proc_read(struct seq_file *seq, void *offset);
+
+static struct cpustate_t cpustate;
+
+static const struct file_operations proc_cpustate = {
+	.open = cpustate_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int cpustate_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cpustate_proc_read, NULL);
+}
+
+static int cpustate_proc_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "CPU State: %04x\n", cpustate_get_state());
+	return 0;
+}
 
 static int cpustate_get_ref(int excl)
 {
@@ -67,13 +91,13 @@ static int cpustate_free_ref(void)
 	return 0;
 }
 
-unsigned char cpustate_get_state(void)
+static unsigned char cpustate_get_state(void)
 {
 
 	return cpustate.cached_val;
 }
 
-void cpustate_set_state(unsigned char new_state)
+static void cpustate_set_state(unsigned char new_state)
 {
 	unsigned int state = (new_state << 21);
 
@@ -135,29 +159,6 @@ static int cpustate_release(struct inode
 	return cpustate_free_ref();
 }
 
-/*
- *	Info exported via "/proc/sky_cpustate".
- */
-static int cpustate_read_proc(char *page, char **start, off_t off,
-			      int count, int *eof, void *data)
-{
-	char *p = page;
-	int len = 0;
-
-	p += sprintf(p, "CPU State: %04x\n", cpustate_get_state());
-	len = p - page;
-
-	if (len <= off + count)
-		*eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-	return len;
-}
-
 static struct platform_driver hdpu_cpustate_driver = {
 	.probe = hdpu_cpustate_probe,
 	.remove = hdpu_cpustate_remove,
@@ -208,11 +209,14 @@ static int hdpu_cpustate_probe(struct pl
 		return ret;
 	}
 
-	proc_de = create_proc_read_entry("sky_cpustate", 0, 0,
-					 cpustate_read_proc, NULL);
-	if (proc_de == NULL)
+	proc_de = create_proc_entry("sky_cpustate", 0666, &proc_root);
+	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
-		       "Unable to create proc dir entry\n");
+		       "Unable to create proc entry\n");
+	} else {
+		proc_de->proc_fops = &proc_cpustate;
+		proc_de->owner = THIS_MODULE;
+	}
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
 	return 0;
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -18,18 +18,38 @@
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/hdpu_features.h>
-
 #include <linux/platform_device.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 static int hdpu_nexus_probe(struct platform_device *pdev);
 static int hdpu_nexus_remove(struct platform_device *pdev);
+static int hdpu_slot_id_open(struct inode *inode, struct file *file);
+static int hdpu_slot_id_read(struct seq_file *seq, void *offset);
+static int hdpu_chassis_id_open(struct inode *inode, struct file *file);
+static int hdpu_chassis_id_read(struct seq_file *seq, void *offset);
 
 static struct proc_dir_entry *hdpu_slot_id;
 static struct proc_dir_entry *hdpu_chassis_id;
 static int slot_id = -1;
 static int chassis_id = -1;
 
+static const struct file_operations proc_slot_id = {
+	.open = hdpu_slot_id_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations proc_chassis_id = {
+	.open = hdpu_chassis_id_open,
+	.read = seq_read,
+	.llseek	= seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static struct platform_driver hdpu_nexus_driver = {
 	.probe = hdpu_nexus_probe,
 	.remove = hdpu_nexus_remove,
@@ -38,22 +58,26 @@ static struct platform_driver hdpu_nexus
 	},
 };
 
-int hdpu_slot_id_read(char *buffer, char **buffer_location, off_t offset,
-		      int buffer_length, int *zero, void *ptr)
+static int hdpu_slot_id_open(struct inode *inode, struct file *file)
 {
-	if (offset > 0)
-		return 0;
+	return single_open(file, hdpu_slot_id_read, NULL);
+}
 
-	return sprintf(buffer, "%d\n", slot_id);
+static int hdpu_slot_id_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "%d\n", slot_id);
+	return 0;
 }
 
-int hdpu_chassis_id_read(char *buffer, char **buffer_location, off_t offset,
-			 int buffer_length, int *zero, void *ptr)
+static int hdpu_chassis_id_open(struct inode *inode, struct file *file)
 {
-	if (offset > 0)
-		return 0;
+	return single_open(file, hdpu_chassis_id_read, NULL);
+}
 
-	return sprintf(buffer, "%d\n", chassis_id);
+static int hdpu_chassis_id_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "%d\n", chassis_id);
+	return 0;
 }
 
 static int hdpu_nexus_probe(struct platform_device *pdev)
@@ -82,7 +106,8 @@ static int hdpu_nexus_probe(struct platf
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
 	} else {
-		hdpu_slot_id->read_proc = hdpu_slot_id_read;
+		hdpu_slot_id->proc_fops = &proc_slot_id;
+		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
@@ -90,7 +115,8 @@ static int hdpu_nexus_probe(struct platf
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
 	} else {
-		hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+		hdpu_chassis_id->proc_fops = &proc_chassis_id;
+		hdpu_chassis_id->owner = THIS_MODULE;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
