From: akpm@osdl.org
Subject: + proc-remove-useless-and-buggy-nlink-settings.patch added to -mm tree
Date: Mon, 08 Jan 2007 14:49:13 -0800
Message-ID: <200701082249.l08MnDmQ021429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbXAHWub (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org, greg@kroah.com, jdike@addtoit.com, kyle@mcmartin.ca, mingo@elte.hu, minyard@acm.org, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de


The patch titled
     proc: remove useless (and buggy) ->nlink settings
has been added to the -mm tree.  Its filename is
     proc-remove-useless-and-buggy-nlink-settings.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: remove useless (and buggy) ->nlink settings
From: Alexey Dobriyan <adobriyan@gmail.com>

Bug: pnx8550 code creates directory but resets ->nlink to 1.

create_proc_entry() et al will correctly set ->nlink for you.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/philips/pnx8550/common/proc.c   |    7 +------
 arch/powerpc/kernel/proc_ppc64.c          |    1 -
 arch/powerpc/kernel/rtas_flash.c          |    1 -
 arch/powerpc/platforms/iseries/mf.c       |    4 ----
 arch/powerpc/platforms/pseries/reconfig.c |    1 -
 arch/um/drivers/ubd_kern.c                |    1 -
 drivers/char/ipmi/ipmi_msghandler.c       |    1 -
 drivers/ide/ide-proc.c                    |    1 -
 drivers/macintosh/via-pmu.c               |    1 -
 drivers/misc/hdpuftrs/hdpu_nexus.c        |    2 --
 drivers/parisc/led.c                      |    2 --
 drivers/s390/crypto/zcrypt_api.c          |    1 -
 drivers/usb/gadget/rndis.c                |    1 -
 kernel/irq/proc.c                         |    1 -
 kernel/profile.c                          |    1 -
 15 files changed, 1 insertion(+), 25 deletions(-)

diff -puN arch/mips/philips/pnx8550/common/proc.c~proc-remove-useless-and-buggy-nlink-settings arch/mips/philips/pnx8550/common/proc.c
--- a/arch/mips/philips/pnx8550/common/proc.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/mips/philips/pnx8550/common/proc.c
@@ -79,10 +79,7 @@ static int pnx8550_proc_init( void )
 
 	// Create /proc/pnx8550
         pnx8550_dir = create_proc_entry("pnx8550", S_IFDIR|S_IRUGO, NULL);
-        if (pnx8550_dir){
-                pnx8550_dir->nlink = 1;
-        }
-        else {
+        if (!pnx8550_dir) {
                 printk(KERN_ERR "Can't create pnx8550 proc dir\n");
                 return -1;
         }
@@ -90,7 +87,6 @@ static int pnx8550_proc_init( void )
 	// Create /proc/pnx8550/timers
         pnx8550_timers = create_proc_entry("timers", S_IFREG|S_IRUGO, pnx8550_dir );
         if (pnx8550_timers){
-                pnx8550_timers->nlink = 1;
                 pnx8550_timers->read_proc = pnx8550_timers_read;
         }
         else {
@@ -100,7 +96,6 @@ static int pnx8550_proc_init( void )
 	// Create /proc/pnx8550/registers
         pnx8550_registers = create_proc_entry("registers", S_IFREG|S_IRUGO, pnx8550_dir );
         if (pnx8550_registers){
-                pnx8550_registers->nlink = 1;
                 pnx8550_registers->read_proc = pnx8550_registers_read;
         }
         else {
diff -puN arch/powerpc/kernel/proc_ppc64.c~proc-remove-useless-and-buggy-nlink-settings arch/powerpc/kernel/proc_ppc64.c
--- a/arch/powerpc/kernel/proc_ppc64.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/powerpc/kernel/proc_ppc64.c
@@ -71,7 +71,6 @@ static int __init proc_ppc64_init(void)
 	pde = create_proc_entry("ppc64/systemcfg", S_IFREG|S_IRUGO, NULL);
 	if (!pde)
 		return 1;
-	pde->nlink = 1;
 	pde->data = vdso_data;
 	pde->size = PAGE_SIZE;
 	pde->proc_fops = &page_map_fops;
diff -puN arch/powerpc/kernel/rtas_flash.c~proc-remove-useless-and-buggy-nlink-settings arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -708,7 +708,6 @@ static struct proc_dir_entry *create_fla
 
 	ent = create_proc_entry(filename, S_IRUSR | S_IWUSR, NULL);
 	if (ent != NULL) {
-		ent->nlink = 1;
 		ent->proc_fops = fops;
 		ent->owner = THIS_MODULE;
 	}
diff -puN arch/powerpc/platforms/iseries/mf.c~proc-remove-useless-and-buggy-nlink-settings arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -1249,7 +1249,6 @@ static int __init mf_proc_init(void)
 		ent = create_proc_entry("cmdline", S_IFREG|S_IRUSR|S_IWUSR, mf);
 		if (!ent)
 			return 1;
-		ent->nlink = 1;
 		ent->data = (void *)(long)i;
 		ent->read_proc = proc_mf_dump_cmdline;
 		ent->write_proc = proc_mf_change_cmdline;
@@ -1260,7 +1259,6 @@ static int __init mf_proc_init(void)
 		ent = create_proc_entry("vmlinux", S_IFREG|S_IWUSR, mf);
 		if (!ent)
 			return 1;
-		ent->nlink = 1;
 		ent->data = (void *)(long)i;
 		ent->proc_fops = &proc_vmlinux_operations;
 	}
@@ -1268,7 +1266,6 @@ static int __init mf_proc_init(void)
 	ent = create_proc_entry("side", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root);
 	if (!ent)
 		return 1;
-	ent->nlink = 1;
 	ent->data = (void *)0;
 	ent->read_proc = proc_mf_dump_side;
 	ent->write_proc = proc_mf_change_side;
@@ -1276,7 +1273,6 @@ static int __init mf_proc_init(void)
 	ent = create_proc_entry("src", S_IFREG|S_IRUSR|S_IWUSR, mf_proc_root);
 	if (!ent)
 		return 1;
-	ent->nlink = 1;
 	ent->data = (void *)0;
 	ent->read_proc = proc_mf_dump_src;
 	ent->write_proc = proc_mf_change_src;
diff -puN arch/powerpc/platforms/pseries/reconfig.c~proc-remove-useless-and-buggy-nlink-settings arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -513,7 +513,6 @@ static int proc_ppc64_create_ofdt(void)
 
 	ent = create_proc_entry("ppc64/ofdt", S_IWUSR, NULL);
 	if (ent) {
-		ent->nlink = 1;
 		ent->data = NULL;
 		ent->size = 0;
 		ent->proc_fops = &ofdt_fops;
diff -puN arch/um/drivers/ubd_kern.c~proc-remove-useless-and-buggy-nlink-settings arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/arch/um/drivers/ubd_kern.c
@@ -242,7 +242,6 @@ static void make_ide_entries(char *dev_n
 
 	ent = create_proc_entry("media", S_IFREG|S_IRUGO, dir);
 	if(!ent) return;
-	ent->nlink = 1;
 	ent->data = NULL;
 	ent->read_proc = proc_ide_read_media;
 	ent->write_proc = NULL;
diff -puN drivers/char/ipmi/ipmi_msghandler.c~proc-remove-useless-and-buggy-nlink-settings drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -1887,7 +1887,6 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 		kfree(entry);
 		rv = -ENOMEM;
 	} else {
-		file->nlink = 1;
 		file->data = data;
 		file->read_proc = read_proc;
 		file->write_proc = write_proc;
diff -puN drivers/ide/ide-proc.c~proc-remove-useless-and-buggy-nlink-settings drivers/ide/ide-proc.c
--- a/drivers/ide/ide-proc.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/ide/ide-proc.c
@@ -413,7 +413,6 @@ void ide_add_proc_entries(struct proc_di
 	while (p->name != NULL) {
 		ent = create_proc_entry(p->name, p->mode, dir);
 		if (!ent) return;
-		ent->nlink = 1;
 		ent->data = data;
 		ent->read_proc = p->read_proc;
 		ent->write_proc = p->write_proc;
diff -puN drivers/macintosh/via-pmu.c~proc-remove-useless-and-buggy-nlink-settings drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/macintosh/via-pmu.c
@@ -516,7 +516,6 @@ static int __init via_pmu_dev_init(void)
 					proc_get_irqstats, NULL);
 		proc_pmu_options = create_proc_entry("options", 0600, proc_pmu_root);
 		if (proc_pmu_options) {
-			proc_pmu_options->nlink = 1;
 			proc_pmu_options->read_proc = proc_read_options;
 			proc_pmu_options->write_proc = proc_write_options;
 		}
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~proc-remove-useless-and-buggy-nlink-settings drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -72,11 +72,9 @@ static int hdpu_nexus_probe(struct platf
 		printk("Could not map slot id\n");
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
 	hdpu_slot_id->read_proc = hdpu_slot_id_read;
-	hdpu_slot_id->nlink = 1;
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
 	hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
-	hdpu_chassis_id->nlink = 1;
 	return 0;
 }
 
diff -puN drivers/parisc/led.c~proc-remove-useless-and-buggy-nlink-settings drivers/parisc/led.c
--- a/drivers/parisc/led.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/parisc/led.c
@@ -252,7 +252,6 @@ static int __init led_create_procfs(void
 	proc_pdc_root->owner = THIS_MODULE;
 	ent = create_proc_entry("led", S_IFREG|S_IRUGO|S_IWUSR, proc_pdc_root);
 	if (!ent) return -1;
-	ent->nlink = 1;
 	ent->data = (void *)LED_NOLCD; /* LED */
 	ent->read_proc = led_proc_read;
 	ent->write_proc = led_proc_write;
@@ -262,7 +261,6 @@ static int __init led_create_procfs(void
 	{
 		ent = create_proc_entry("lcd", S_IFREG|S_IRUGO|S_IWUSR, proc_pdc_root);
 		if (!ent) return -1;
-		ent->nlink = 1;
 		ent->data = (void *)LED_HASLCD; /* LCD */
 		ent->read_proc = led_proc_read;
 		ent->write_proc = led_proc_write;
diff -puN drivers/s390/crypto/zcrypt_api.c~proc-remove-useless-and-buggy-nlink-settings drivers/s390/crypto/zcrypt_api.c
--- a/drivers/s390/crypto/zcrypt_api.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/s390/crypto/zcrypt_api.c
@@ -1063,7 +1063,6 @@ int __init zcrypt_api_init(void)
 		rc = -ENOMEM;
 		goto out_misc;
 	}
-	zcrypt_entry->nlink = 1;
 	zcrypt_entry->data = NULL;
 	zcrypt_entry->read_proc = zcrypt_status_read;
 	zcrypt_entry->write_proc = zcrypt_status_write;
diff -puN drivers/usb/gadget/rndis.c~proc-remove-useless-and-buggy-nlink-settings drivers/usb/gadget/rndis.c
--- a/drivers/usb/gadget/rndis.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/drivers/usb/gadget/rndis.c
@@ -1419,7 +1419,6 @@ int __devinit rndis_init (void)
 			return -EIO;
 		}
 
-		rndis_connect_state [i]->nlink = 1;
 		rndis_connect_state [i]->write_proc = rndis_proc_write;
 		rndis_connect_state [i]->read_proc = rndis_proc_read;
 		rndis_connect_state [i]->data = (void *)
diff -puN kernel/irq/proc.c~proc-remove-useless-and-buggy-nlink-settings kernel/irq/proc.c
--- a/kernel/irq/proc.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/kernel/irq/proc.c
@@ -136,7 +136,6 @@ void register_irq_proc(unsigned int irq)
 		entry = create_proc_entry("smp_affinity", 0600, irq_desc[irq].dir);
 
 		if (entry) {
-			entry->nlink = 1;
 			entry->data = (void *)(long)irq;
 			entry->read_proc = irq_affinity_read_proc;
 			entry->write_proc = irq_affinity_write_proc;
diff -puN kernel/profile.c~proc-remove-useless-and-buggy-nlink-settings kernel/profile.c
--- a/kernel/profile.c~proc-remove-useless-and-buggy-nlink-settings
+++ a/kernel/profile.c
@@ -434,7 +434,6 @@ void create_prof_cpu_mask(struct proc_di
 	/* create /proc/irq/prof_cpu_mask */
 	if (!(entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir)))
 		return;
-	entry->nlink = 1;
 	entry->data = (void *)&prof_cpu_mask;
 	entry->read_proc = prof_cpu_mask_read_proc;
 	entry->write_proc = prof_cpu_mask_write_proc;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
proc-remove-useless-and-buggy-nlink-settings.patch
