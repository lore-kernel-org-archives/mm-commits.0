From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-code-style-improvement.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:03:56 -0700
Message-ID: <200707052203.l65M3uTl021693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757992AbXGEWEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     Sky Cpu and Nexus: code style improvement
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-code-style-improvement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: code style improvement
From: Cyrill Gorcunov <gorcunov@gmail.com>

Remove useless spaces and adds some empty lines to make code more readable. 
Also marker for printk is added.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   38 ++++++++++--------------
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   24 ++++++++-------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-code-style-improvement drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-code-style-improvement
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -169,22 +169,21 @@ static struct platform_driver hdpu_cpust
  *	The various file operations we support.
  */
 static const struct file_operations cpustate_fops = {
-      owner:THIS_MODULE,
-      open:cpustate_open,
-      release:cpustate_release,
-      read:cpustate_read,
-      write:cpustate_write,
-      fasync:NULL,
-      poll:NULL,
-      ioctl:NULL,
-      llseek:no_llseek,
-
+      owner:	THIS_MODULE,
+      open:	cpustate_open,
+      release:	cpustate_release,
+      read:	cpustate_read,
+      write:	cpustate_write,
+      fasync:	NULL,
+      poll:	NULL,
+      ioctl:	NULL,
+      llseek:	no_llseek,
 };
 
 static struct miscdevice cpustate_dev = {
 	MISC_DYNAMIC_MINOR,
 	"sky_cpustate",
-	&cpustate_fops
+	&cpustate_fops,
 };
 
 static int hdpu_cpustate_probe(struct platform_device *pdev)
@@ -199,18 +198,18 @@ static int hdpu_cpustate_probe(struct pl
 
 	ret = misc_register(&cpustate_dev);
 	if (ret) {
-		printk(KERN_WARNING "sky_cpustate: Unable to register misc "
-					"device.\n");
+		printk(KERN_WARNING "sky_cpustate: "
+		       "Unable to register misc device.\n");
 		cpustate.set_addr = NULL;
 		cpustate.clr_addr = NULL;
 		return ret;
 	}
 
 	proc_de = create_proc_read_entry("sky_cpustate", 0, 0,
-					cpustate_read_proc, NULL);
+					 cpustate_read_proc, NULL);
 	if (proc_de == NULL)
-		printk(KERN_WARNING "sky_cpustate: Unable to create proc "
-					"dir entry\n");
+		printk(KERN_WARNING "sky_cpustate: "
+		       "Unable to create proc dir entry\n");
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
 	return 0;
@@ -218,21 +217,18 @@ static int hdpu_cpustate_probe(struct pl
 
 static int hdpu_cpustate_remove(struct platform_device *pdev)
 {
-
 	cpustate.set_addr = NULL;
 	cpustate.clr_addr = NULL;
 
 	remove_proc_entry("sky_cpustate", NULL);
 	misc_deregister(&cpustate_dev);
-	return 0;
 
+	return 0;
 }
 
 static int __init cpustate_init(void)
 {
-	int rc;
-	rc = platform_driver_register(&hdpu_cpustate_driver);
-	return rc;
+	return platform_driver_register(&hdpu_cpustate_driver);
 }
 
 static void __exit cpustate_exit(void)
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-code-style-improvement drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~sky-cpu-and-nexus-code-style-improvement
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -40,40 +40,43 @@ static struct platform_driver hdpu_nexus
 int hdpu_slot_id_read(char *buffer, char **buffer_location, off_t offset,
 		      int buffer_length, int *zero, void *ptr)
 {
-
 	if (offset > 0)
 		return 0;
+
 	return sprintf(buffer, "%d\n", slot_id);
 }
 
 int hdpu_chassis_id_read(char *buffer, char **buffer_location, off_t offset,
 			 int buffer_length, int *zero, void *ptr)
 {
-
 	if (offset > 0)
 		return 0;
+
 	return sprintf(buffer, "%d\n", chassis_id);
 }
 
 static int hdpu_nexus_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	int *nexus_id_addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int *nexus_id_addr;
-	nexus_id_addr =
-	    ioremap(res->start, (unsigned long)(res->end - res->start));
+	nexus_id_addr = ioremap(res->start,
+				(unsigned long)(res->end - res->start));
 	if (nexus_id_addr) {
 		slot_id = (*nexus_id_addr >> 8) & 0x1f;
 		chassis_id = *nexus_id_addr & 0xff;
 		iounmap(nexus_id_addr);
-	} else
-		printk("Could not map slot id\n");
+	} else {
+		printk(KERN_ERR "Could not map slot id\n");
+	}
+
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
 	hdpu_slot_id->read_proc = hdpu_slot_id_read;
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
 	hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+
 	return 0;
 }
 
@@ -81,18 +84,19 @@ static int hdpu_nexus_remove(struct plat
 {
 	slot_id = -1;
 	chassis_id = -1;
+
 	remove_proc_entry("sky_slot_id", &proc_root);
 	remove_proc_entry("sky_chassis_id", &proc_root);
+
 	hdpu_slot_id = 0;
 	hdpu_chassis_id = 0;
+
 	return 0;
 }
 
 static int __init nexus_init(void)
 {
-	int rc;
-	rc = platform_driver_register(&hdpu_nexus_driver);
-	return rc;
+	return platform_driver_register(&hdpu_nexus_driver);
 }
 
 static void __exit nexus_exit(void)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
