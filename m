From: akpm@linux-foundation.org
Subject: + pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch added to -mm tree
Date: Tue, 01 Sep 2009 15:45:12 -0700
Message-ID: <200909012245.n81MjChD016303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbZIAWpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 18:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, linux@dominikbrodowski.net


The patch titled
     pcmcia: switch /proc/bus/pccard/drivers to seq_file
has been added to the -mm tree.  Its filename is
     pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: switch /proc/bus/pccard/drivers to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pcmcia_ioctl.c |   36 +++++++++++++++++---------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN drivers/pcmcia/pcmcia_ioctl.c~pcmcia-switch-proc-bus-pccard-drivers-to-seq_file drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~pcmcia-switch-proc-bus-pccard-drivers-to-seq_file
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/proc_fs.h>
 #include <linux/poll.h>
 #include <linux/pci.h>
+#include <linux/seq_file.h>
 #include <linux/smp_lock.h>
 #include <linux/workqueue.h>
 
@@ -105,37 +106,40 @@ static struct pcmcia_driver *get_pcmcia_
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *proc_pccard = NULL;
 
-static int proc_read_drivers_callback(struct device_driver *driver, void *d)
+static int proc_read_drivers_callback(struct device_driver *driver, void *_m)
 {
-	char **p = d;
+	struct seq_file *m = _m;
 	struct pcmcia_driver *p_drv = container_of(driver,
 						   struct pcmcia_driver, drv);
 
-	*p += sprintf(*p, "%-24.24s 1 %d\n", p_drv->drv.name,
+	seq_printf(m, "%-24.24s 1 %d\n", p_drv->drv.name,
 #ifdef CONFIG_MODULE_UNLOAD
 		      (p_drv->owner) ? module_refcount(p_drv->owner) : 1
 #else
 		      1
 #endif
 	);
-	d = (void *) p;
-
 	return 0;
 }
 
-static int proc_read_drivers(char *buf, char **start, off_t pos,
-			     int count, int *eof, void *data)
+static int pccard_drivers_proc_show(struct seq_file *m, void *v)
 {
-	char *p = buf;
-	int rc;
-
-	rc = bus_for_each_drv(&pcmcia_bus_type, NULL,
-			      (void *) &p, proc_read_drivers_callback);
-	if (rc < 0)
-		return rc;
+	return bus_for_each_drv(&pcmcia_bus_type, NULL,
+				m, proc_read_drivers_callback);
+}
 
-	return (p - buf);
+static int pccard_drivers_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pccard_drivers_proc_show, NULL);
 }
+
+static const struct file_operations pccard_drivers_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pccard_drivers_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 
@@ -1011,7 +1015,7 @@ void __init pcmcia_setup_ioctl(void) {
 #ifdef CONFIG_PROC_FS
 	proc_pccard = proc_mkdir("bus/pccard", NULL);
 	if (proc_pccard)
-		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
+		proc_create("drivers", 0, proc_pccard, &pccard_drivers_proc_fops);
 #endif
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch

