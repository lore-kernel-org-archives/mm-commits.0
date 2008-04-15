From: akpm@linux-foundation.org
Subject: + drivers-use-non-racy-method-for-proc-entries-creation-2.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:50 -0700
Message-ID: <200804152356.m3FNupes022578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbYDOX55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, a.zummo@towertech.it, adobriyan@gmail.com, bjorn.helgaas@hp.com, bzolnier@gmail.com, dtor@mail.ru, ebiederm@xmission.com, gregkh@suse.de, mchehab@infradead.org, neilb@suse.de, petero2@telia.com


The patch titled
     drivers: use non-racy method for proc entries creation (2)
has been added to the -mm tree.  Its filename is
     drivers-use-non-racy-method-for-proc-entries-creation-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: use non-racy method for proc entries creation (2)
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Neil Brown <neilb@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c               |    7 +------
 drivers/cdrom/viocd.c                 |   10 +++-------
 drivers/ide/ide-proc.c                |    7 ++-----
 drivers/input/input.c                 |   12 ++++--------
 drivers/md/md.c                       |    6 +-----
 drivers/media/video/zoran_procfs.c    |    7 +++----
 drivers/message/i2o/i2o_proc.c        |    6 ++----
 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 +----
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   13 ++++---------
 drivers/pci/proc.c                    |   13 ++++++-------
 drivers/pnp/isapnp/proc.c             |    7 +++----
 drivers/rapidio/rio.c                 |    6 +-----
 drivers/rtc/rtc-proc.c                |    8 +++-----
 13 files changed, 34 insertions(+), 73 deletions(-)

diff -puN drivers/block/pktcdvd.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/block/pktcdvd.c
@@ -2742,7 +2742,6 @@ static int pkt_new_dev(struct pktcdvd_de
 	int i;
 	int ret = 0;
 	char b[BDEVNAME_SIZE];
-	struct proc_dir_entry *proc;
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
@@ -2786,11 +2785,7 @@ static int pkt_new_dev(struct pktcdvd_de
 		goto out_mem;
 	}
 
-	proc = create_proc_entry(pd->name, 0, pkt_proc);
-	if (proc) {
-		proc->data = pd;
-		proc->proc_fops = &pkt_proc_fops;
-	}
+	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
 	DPRINTK(DRIVER_NAME": writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
 	return 0;
 
diff -puN drivers/cdrom/viocd.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/cdrom/viocd.c
--- a/drivers/cdrom/viocd.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/cdrom/viocd.c
@@ -144,6 +144,7 @@ static int proc_viocd_open(struct inode 
 }
 
 static const struct file_operations proc_viocd_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_viocd_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -679,7 +680,6 @@ static struct vio_driver viocd_driver = 
 
 static int __init viocd_init(void)
 {
-	struct proc_dir_entry *e;
 	int ret = 0;
 
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
@@ -719,12 +719,8 @@ static int __init viocd_init(void)
 	if (ret)
 		goto out_free_info;
 
-	e = create_proc_entry("iSeries/viocd", S_IFREG|S_IRUGO, NULL);
-	if (e) {
-		e->owner = THIS_MODULE;
-		e->proc_fops = &proc_viocd_operations;
-	}
-
+	proc_create("iSeries/viocd", S_IFREG|S_IRUGO, NULL,
+		    &proc_viocd_operations);
 	return 0;
 
 out_free_info:
diff -puN drivers/ide/ide-proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/ide/ide-proc.c
@@ -822,6 +822,7 @@ static int ide_drivers_open(struct inode
 }
 
 static const struct file_operations ide_drivers_operations = {
+	.owner		= THIS_MODULE,
 	.open		= ide_drivers_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -830,16 +831,12 @@ static const struct file_operations ide_
 
 void proc_ide_create(void)
 {
-	struct proc_dir_entry *entry;
-
 	proc_ide_root = proc_mkdir("ide", NULL);
 
 	if (!proc_ide_root)
 		return;
 
-	entry = create_proc_entry("drivers", 0, proc_ide_root);
-	if (entry)
-		entry->proc_fops = &ide_drivers_operations;
+	proc_create("drivers", 0, proc_ide_root, &ide_drivers_operations);
 }
 
 void proc_ide_destroy(void)
diff -puN drivers/input/input.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/input/input.c
--- a/drivers/input/input.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/input/input.c
@@ -904,20 +904,16 @@ static int __init input_proc_init(void)
 
 	proc_bus_input_dir->owner = THIS_MODULE;
 
-	entry = create_proc_entry("devices", 0, proc_bus_input_dir);
+	entry = proc_create("devices", 0, proc_bus_input_dir,
+			    &input_devices_fileops);
 	if (!entry)
 		goto fail1;
 
-	entry->owner = THIS_MODULE;
-	entry->proc_fops = &input_devices_fileops;
-
-	entry = create_proc_entry("handlers", 0, proc_bus_input_dir);
+	entry = proc_create("handlers", 0, proc_bus_input_dir,
+			    &input_handlers_fileops);
 	if (!entry)
 		goto fail2;
 
-	entry->owner = THIS_MODULE;
-	entry->proc_fops = &input_handlers_fileops;
-
 	return 0;
 
  fail2:	remove_proc_entry("devices", proc_bus_input_dir);
diff -puN drivers/md/md.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/md/md.c
--- a/drivers/md/md.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/md/md.c
@@ -5947,13 +5947,9 @@ static struct notifier_block md_notifier
 
 static void md_geninit(void)
 {
-	struct proc_dir_entry *p;
-
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	p = create_proc_entry("mdstat", S_IRUGO, NULL);
-	if (p)
-		p->proc_fops = &md_seq_fops;
+	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
 }
 
 static int __init md_init(void)
diff -puN drivers/media/video/zoran_procfs.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/media/video/zoran_procfs.c
--- a/drivers/media/video/zoran_procfs.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/media/video/zoran_procfs.c
@@ -180,6 +180,7 @@ static ssize_t zoran_write(struct file *
 }
 
 static const struct file_operations zoran_operations = {
+	.owner		= THIS_MODULE,
 	.open		= zoran_open,
 	.read		= seq_read,
 	.write		= zoran_write,
@@ -195,10 +196,8 @@ zoran_proc_init (struct zoran *zr)
 	char name[8];
 
 	snprintf(name, 7, "zoran%d", zr->id);
-	if ((zr->zoran_proc = create_proc_entry(name, 0, NULL))) {
-		zr->zoran_proc->data = zr;
-		zr->zoran_proc->owner = THIS_MODULE;
-		zr->zoran_proc->proc_fops = &zoran_operations;
+	zr->zoran_proc = proc_create_data(name, 0, NULL, &zoran_operations, zr);
+	if (zr->zoran_proc != NULL) {
 		dprintk(2,
 			KERN_INFO
 			"%s: procfs entry /proc/%s allocated. data=%p\n",
diff -puN drivers/message/i2o/i2o_proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/message/i2o/i2o_proc.c
--- a/drivers/message/i2o/i2o_proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/message/i2o/i2o_proc.c
@@ -1893,13 +1893,11 @@ static int i2o_proc_create_entries(struc
 	struct proc_dir_entry *tmp;
 
 	while (i2o_pe->name) {
-		tmp = create_proc_entry(i2o_pe->name, i2o_pe->mode, dir);
+		tmp = proc_create_data(i2o_pe->name, i2o_pe->mode, dir,
+				       i2o_pe->fops, data);
 		if (!tmp)
 			return -1;
 
-		tmp->data = data;
-		tmp->proc_fops = i2o_pe->fops;
-
 		i2o_pe++;
 	}
 
diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -210,13 +210,10 @@ static int hdpu_cpustate_probe(struct pl
 		return ret;
 	}
 
-	proc_de = create_proc_entry("sky_cpustate", 0666, NULL);
+	proc_de = proc_create("sky_cpustate", 0666, NULL, &proc_cpustate);
 	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
 		       "Unable to create proc entry\n");
-	} else {
-		proc_de->proc_fops = &proc_cpustate;
-		proc_de->owner = THIS_MODULE;
 	}
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -102,22 +102,17 @@ static int hdpu_nexus_probe(struct platf
 		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
-	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, NULL);
-	if (!hdpu_slot_id)
+	hdpu_slot_id = proc_create("sky_slot_id", 0666, NULL, &proc_slot_id);
+	if (!hdpu_slot_id) {
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
-	} else {
-		hdpu_slot_id->proc_fops = &proc_slot_id;
-		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
-	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, NULL);
+	hdpu_chassis_id = proc_create("sky_chassis_id", 0666, NULL,
+				      &proc_chassis_id);
 	if (!hdpu_chassis_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
-	} else {
-		hdpu_chassis_id->proc_fops = &proc_chassis_id;
-		hdpu_chassis_id->owner = THIS_MODULE;
 	}
 
 	return 0;
diff -puN drivers/pci/proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/pci/proc.c
--- a/drivers/pci/proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/pci/proc.c
@@ -293,6 +293,7 @@ static int proc_bus_pci_release(struct i
 #endif /* HAVE_PCI_MMAP */
 
 static const struct file_operations proc_bus_pci_operations = {
+	.owner		= THIS_MODULE,
 	.llseek		= proc_bus_pci_lseek,
 	.read		= proc_bus_pci_read,
 	.write		= proc_bus_pci_write,
@@ -406,11 +407,10 @@ int pci_proc_attach_device(struct pci_de
 	}
 
 	sprintf(name, "%02x.%x", PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	e = create_proc_entry(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir);
+	e = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir,
+			     &proc_bus_pci_operations, dev);
 	if (!e)
 		return -ENOMEM;
-	e->proc_fops = &proc_bus_pci_operations;
-	e->data = dev;
 	e->size = dev->cfg_size;
 	dev->procent = e;
 
@@ -462,6 +462,7 @@ static int proc_bus_pci_dev_open(struct 
 	return seq_open(file, &proc_bus_pci_devices_op);
 }
 static const struct file_operations proc_bus_pci_dev_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_bus_pci_dev_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -470,12 +471,10 @@ static const struct file_operations proc
 
 static int __init pci_proc_init(void)
 {
-	struct proc_dir_entry *entry;
 	struct pci_dev *dev = NULL;
 	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
-	entry = create_proc_entry("devices", 0, proc_bus_pci_dir);
-	if (entry)
-		entry->proc_fops = &proc_bus_pci_dev_operations;
+	proc_create("devices", 0, proc_bus_pci_dir,
+		    &proc_bus_pci_dev_operations);
 	proc_initialized = 1;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_proc_attach_device(dev);
diff -puN drivers/pnp/isapnp/proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/pnp/isapnp/proc.c
@@ -85,6 +85,7 @@ static ssize_t isapnp_proc_bus_read(stru
 }
 
 static const struct file_operations isapnp_proc_bus_file_operations = {
+	.owner	= THIS_MODULE,
 	.llseek = isapnp_proc_bus_lseek,
 	.read = isapnp_proc_bus_read,
 };
@@ -102,12 +103,10 @@ static int isapnp_proc_attach_device(str
 			return -ENOMEM;
 	}
 	sprintf(name, "%02x", dev->number);
-	e = dev->procent = create_proc_entry(name, S_IFREG | S_IRUGO, de);
+	e = dev->procent = proc_create_data(name, S_IFREG | S_IRUGO, de,
+			&isapnp_proc_bus_file_operations, dev);
 	if (!e)
 		return -ENOMEM;
-	e->proc_fops = &isapnp_proc_bus_file_operations;
-	e->owner = THIS_MODULE;
-	e->data = dev;
 	e->size = 256;
 	return 0;
 }
diff -puN drivers/rapidio/rio.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/rapidio/rio.c
@@ -984,11 +984,7 @@ static const struct file_operations proc
 
 static int __init rioresources_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("riores", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_riores_operations;
+	proc_create("riores", 0, NULL, &proc_riores_operations);
 	return 0;
 }
 __initcall(rioresources_init);
diff -puN drivers/rtc/rtc-proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/rtc/rtc-proc.c
@@ -108,12 +108,10 @@ void rtc_proc_add_device(struct rtc_devi
 	if (rtc->id == 0) {
 		struct proc_dir_entry *ent;
 
-		ent = create_proc_entry("driver/rtc", 0, NULL);
-		if (ent) {
-			ent->proc_fops = &rtc_proc_fops;
+		ent = proc_create_data("driver/rtc", 0, NULL,
+				       &rtc_proc_fops, rtc);
+		if (ent)
 			ent->owner = rtc->owner;
-			ent->data = rtc;
-		}
 	}
 }
 
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

