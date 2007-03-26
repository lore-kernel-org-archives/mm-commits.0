From: akpm@linux-foundation.org
Subject: - revert-jdelvare-hwmon-hwmon-coretemp-new-driver.patch removed from -mm tree
Date: Mon, 26 Mar 2007 14:12:14 -0700
Message-ID: <200703262112.l2QLCEZJ030687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXCZVMc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     revert jdelvare-hwmon-hwmon-coretemp-new-driver
has been removed from the -mm tree.  Its filename was
     revert-jdelvare-hwmon-hwmon-coretemp-new-driver.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert jdelvare-hwmon-hwmon-coretemp-new-driver
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "rdmsr_safe_on_cpu" [drivers/hwmon/coretemp.ko] undefined!

The rdmsr situation is bad, and will remain bad until the x86_64 tree gets
fixed.

Revert this patch locally from -mm.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS              |    6 
 drivers/hwmon/Kconfig    |    8 
 drivers/hwmon/Makefile   |    1 
 drivers/hwmon/coretemp.c |  406 -------------------------------------
 4 files changed, 421 deletions(-)

diff -puN MAINTAINERS~revert-jdelvare-hwmon-hwmon-coretemp-new-driver MAINTAINERS
--- a/MAINTAINERS~revert-jdelvare-hwmon-hwmon-coretemp-new-driver
+++ a/MAINTAINERS
@@ -965,12 +965,6 @@ M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
 
-CORETEMP HARDWARE MONITORING DRIVER
-P:	Rudolf Marek
-M:	r.marek@assembler.cz
-L:	lm-sensors@lm-sensors.org
-S:	Maintained
-
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
diff -puN drivers/hwmon/Kconfig~revert-jdelvare-hwmon-hwmon-coretemp-new-driver drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~revert-jdelvare-hwmon-hwmon-coretemp-new-driver
+++ a/drivers/hwmon/Kconfig
@@ -229,14 +229,6 @@ config SENSORS_GL520SM
 	  This driver can also be built as a module.  If so, the module
 	  will be called gl520sm.
 
-config SENSORS_CORETEMP
-	tristate "Intel Core (2) Duo/Solo temperature sensor"
-	depends on HWMON && X86 && EXPERIMENTAL
-	help
-	  If you say yes here you get support for the temperature
-	  sensor inside your CPU. Supported all are all known variants
-	  of Intel Core family.
-
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	depends on HWMON && I2C
diff -puN drivers/hwmon/Makefile~revert-jdelvare-hwmon-hwmon-coretemp-new-driver drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~revert-jdelvare-hwmon-hwmon-coretemp-new-driver
+++ a/drivers/hwmon/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031
 obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
 obj-$(CONFIG_SENSORS_AMS)	+= ams/
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
-obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_F71805F)	+= f71805f.o
 obj-$(CONFIG_SENSORS_FSCHER)	+= fscher.o
diff -puN drivers/hwmon/coretemp.c~revert-jdelvare-hwmon-hwmon-coretemp-new-driver /dev/null
--- a/drivers/hwmon/coretemp.c
+++ /dev/null
@@ -1,406 +0,0 @@
-/*
- * coretemp.c - Linux kernel module for hardware monitoring
- *
- * Copyright (C) 2007 Rudolf Marek <r.marek@assembler.cz>
- *
- * Inspired from many hwmon drivers
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301 USA.
- */
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/jiffies.h>
-#include <linux/hwmon.h>
-#include <linux/sysfs.h>
-#include <linux/hwmon-sysfs.h>
-#include <linux/err.h>
-#include <linux/mutex.h>
-#include <linux/list.h>
-#include <linux/platform_device.h>
-#include <linux/cpu.h>
-#include <asm/msr.h>
-#include <asm/processor.h>
-
-#define DRVNAME	"coretemp"
-
-typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_LABEL, SHOW_NAME } SHOW;
-
-/*
- * Functions declaration
- */
-
-static struct coretemp_data *coretemp_update_device(struct device *dev);
-
-struct coretemp_data {
-	struct class_device *class_dev;
-	struct mutex update_lock;
-	const char *name;
-	u32 id;
-	char valid;		/* zero until following fields are valid */
-	unsigned long last_updated;	/* in jiffies */
-	int temp;
-	int tjmax;
-	u8 alarm;
-};
-
-static struct coretemp_data *coretemp_update_device(struct device *dev);
-
-/*
- * Sysfs stuff
- */
-
-static ssize_t show_name(struct device *dev, struct device_attribute
-			  *devattr, char *buf)
-{
-	int ret;
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct coretemp_data *data = dev_get_drvdata(dev);
-
-	if (attr->index == SHOW_NAME)
-		ret = sprintf(buf, "%s\n", data->name);
-	else	/* show label */
-		ret = sprintf(buf, "Core %d\n", data->id);
-	return ret;
-}
-
-static ssize_t show_alarm(struct device *dev, struct device_attribute
-			  *devattr, char *buf)
-{
-	struct coretemp_data *data = coretemp_update_device(dev);
-	/* read the Out-of-spec log, never clear */
-	return sprintf(buf, "%d\n", data->alarm);
-}
-
-static ssize_t show_temp(struct device *dev,
-			 struct device_attribute *devattr, char *buf)
-{
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct coretemp_data *data = coretemp_update_device(dev);
-	int err;
-
-	if (attr->index == SHOW_TEMP)
-		err = data->valid ? sprintf(buf, "%d\n", data->temp) : -EAGAIN;
-	else
-		err = sprintf(buf, "%d\n", data->tjmax);
-
-	return err;
-}
-
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
-			  SHOW_TEMP);
-static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL,
-			  SHOW_TJMAX);
-static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
-static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABEL);
-static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
-
-static struct attribute *coretemp_attributes[] = {
-	&sensor_dev_attr_name.dev_attr.attr,
-	&sensor_dev_attr_temp1_label.dev_attr.attr,
-	&dev_attr_temp1_crit_alarm.attr,
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit.dev_attr.attr,
-	NULL
-};
-
-static const struct attribute_group coretemp_group = {
-	.attrs = coretemp_attributes,
-};
-
-static struct coretemp_data *coretemp_update_device(struct device *dev)
-{
-	struct coretemp_data *data = dev_get_drvdata(dev);
-
-	mutex_lock(&data->update_lock);
-
-	if (!data->valid || time_after(jiffies, data->last_updated + HZ)) {
-		u32 eax, edx;
-
-		data->valid = 0;
-		rdmsr_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
-		data->alarm = (eax >> 5) & 1;
-		/* update only if data has been valid */
-		if (eax & 0x80000000) {
-			data->temp = data->tjmax - (((eax >> 16)
-							& 0x7f) * 1000);
-			data->valid = 1;
-		} else {
-			dev_dbg(dev, "Temperature data invalid (0x%x)\n", eax);
-		}
-		data->last_updated = jiffies;
-	}
-
-	mutex_unlock(&data->update_lock);
-	return data;
-}
-
-static int __devinit coretemp_probe(struct platform_device *pdev)
-{
-	struct coretemp_data *data;
-	struct cpuinfo_x86 *c = &(cpu_data)[pdev->id];
-	int err;
-	u32 eax, edx;
-
-	if (!(data = kzalloc(sizeof(struct coretemp_data), GFP_KERNEL))) {
-		err = -ENOMEM;
-		dev_err(&pdev->dev, "Out of memory\n");
-		goto exit;
-	}
-
-	data->id = pdev->id;
-	data->name = "coretemp";
-	mutex_init(&data->update_lock);
-	/* Tjmax default is 100 degrees C */
-	data->tjmax = 100000;
-
-	/* test if we can access the THERM_STATUS MSR */
-	err = rdmsr_safe_on_cpu(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
-	if (err) {
-		dev_err(&pdev->dev,
-			"Unable to access THERM_STATUS MSR, giving up\n");
-		goto exit_free;
-	}
-
-	/* Some processors have Tjmax 85 following magic should detect it
-	   Intel won't disclose the information without signed NDA, but
-	   individuals cannot sign it. Catch(ed) 22.
-	*/
-
-	if (((c->x86_model == 0xf) && (c->x86_mask > 3)) ||
-		(c->x86_model == 0xe))  {
-		err = rdmsr_safe_on_cpu(data->id, 0xee, &eax, &edx);
-		if (err) {
-			dev_warn(&pdev->dev,
-				 "Unable to access MSR 0xEE, Tjmax left at %d "
-				 "degrees C\n", data->tjmax/1000);
-		} else if (eax & 0x40000000) {
-			data->tjmax = 85000;
-		}
-	}
-
-	platform_set_drvdata(pdev, data);
-
-	if ((err = sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
-		goto exit_free;
-
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
-		dev_err(&pdev->dev, "Class registration failed (%d)\n",
-			err);
-		goto exit_class;
-	}
-
-	return 0;
-
-exit_class:
-	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
-exit_free:
-	kfree(data);
-exit:
-	return err;
-}
-
-static int __devexit coretemp_remove(struct platform_device *pdev)
-{
-	struct coretemp_data *data = platform_get_drvdata(pdev);
-
-	hwmon_device_unregister(data->class_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
-	platform_set_drvdata(pdev, NULL);
-	kfree(data);
-	return 0;
-}
-
-static struct platform_driver coretemp_driver = {
-	.driver = {
-		.owner = THIS_MODULE,
-		.name = DRVNAME,
-	},
-	.probe = coretemp_probe,
-	.remove = __devexit_p(coretemp_remove),
-};
-
-struct pdev_entry {
-	struct list_head list;
-	struct platform_device *pdev;
-	unsigned int cpu;
-};
-
-static LIST_HEAD(pdev_list);
-static DEFINE_MUTEX(pdev_list_mutex);
-
-static int __cpuinit coretemp_device_add(unsigned int cpu)
-{
-	int err;
-	struct platform_device *pdev;
-	struct pdev_entry *pdev_entry;
-
-	pdev = platform_device_alloc(DRVNAME, cpu);
-	if (!pdev) {
-		err = -ENOMEM;
-		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
-		goto exit;
-	}
-
-	pdev_entry = kzalloc(sizeof(struct pdev_entry), GFP_KERNEL);
-	if (!pdev_entry) {
-		err = -ENOMEM;
-		goto exit_device_put;
-	}
-
-	err = platform_device_add(pdev);
-	if (err) {
-		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
-		       err);
-		goto exit_device_free;
-	}
-
-	pdev_entry->pdev = pdev;
-	pdev_entry->cpu = cpu;
-	mutex_lock(&pdev_list_mutex);
-	list_add_tail(&pdev_entry->list, &pdev_list);
-	mutex_unlock(&pdev_list_mutex);
-
-	return 0;
-
-exit_device_free:
-	kfree(pdev_entry);
-exit_device_put:
-	platform_device_put(pdev);
-exit:
-	return err;
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-void coretemp_device_remove(unsigned int cpu)
-{
-	struct pdev_entry *p, *n;
-	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		if (p->cpu == cpu) {
-			platform_device_unregister(p->pdev);
-			list_del(&p->list);
-			kfree(p);
-		}
-	}
-	mutex_unlock(&pdev_list_mutex);
-}
-
-static int coretemp_cpu_callback(struct notifier_block *nfb,
-				 unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (unsigned long) hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-		coretemp_device_add(cpu);
-		break;
-	case CPU_DEAD:
-		coretemp_device_remove(cpu);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata coretemp_cpu_notifier = {
-	.notifier_call = coretemp_cpu_callback,
-};
-#endif				/* !CONFIG_HOTPLUG_CPU */
-
-static int __init coretemp_init(void)
-{
-	int i, err = -ENODEV;
-	struct pdev_entry *p, *n;
-
-	printk(KERN_NOTICE DRVNAME ": This driver uses undocumented features "
-		"of Core CPU. Temperature might be wrong!\n");
-
-	/* quick check if we run Intel */
-	if (cpu_data[0].x86_vendor != X86_VENDOR_INTEL)
-		goto exit;
-
-	err = platform_driver_register(&coretemp_driver);
-	if (err)
-		goto exit;
-
-	for_each_online_cpu(i) {
-		struct cpuinfo_x86 *c = &(cpu_data)[i];
-
-		/* check if family 6, models e, f */
-		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
-		    !((c->x86_model == 0xe) || (c->x86_model == 0xf))) {
-
-			/* supported CPU not found, but report the unknown
-			   family 6 CPU */
-			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
-				printk(KERN_WARNING DRVNAME ": Unknown CPU "
-					"model %x\n", c->x86_model);
-			continue;
-		}
-
-		err = coretemp_device_add(i);
-		if (err)
-			goto exit_devices_unreg;
-	}
-	if (list_empty(&pdev_list)) {
-		err = -ENODEV;
-		goto exit_driver_unreg;
-	}
-
-#ifdef CONFIG_HOTPLUG_CPU
-	register_hotcpu_notifier(&coretemp_cpu_notifier);
-#endif
-	return 0;
-
-exit_devices_unreg:
-	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		platform_device_unregister(p->pdev);
-		list_del(&p->list);
-		kfree(p);
-	}
-	mutex_unlock(&pdev_list_mutex);
-exit_driver_unreg:
-	platform_driver_unregister(&coretemp_driver);
-exit:
-	return err;
-}
-
-static void __exit coretemp_exit(void)
-{
-	struct pdev_entry *p, *n;
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
-#endif
-	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		platform_device_unregister(p->pdev);
-		list_del(&p->list);
-		kfree(p);
-	}
-	mutex_unlock(&pdev_list_mutex);
-	platform_driver_unregister(&coretemp_driver);
-}
-
-MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
-MODULE_DESCRIPTION("Intel Core temperature monitor");
-MODULE_LICENSE("GPL");
-
-module_init(coretemp_init)
-module_exit(coretemp_exit)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-acpi-fixup.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
revert-jdelvare-hwmon-hwmon-coretemp-new-driver.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
forcedeth-work-around-null-skb-dereference-crash-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch
