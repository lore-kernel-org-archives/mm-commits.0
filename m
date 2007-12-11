From: akpm@linux-foundation.org
Subject: + x86-boot-export-boot_params-via-sysfs.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:38:26 -0800
Message-ID: <200712112338.lBBNcQbj014935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbXLKXjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 18:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 boot: export boot_params via sysfs
has been added to the -mm tree.  Its filename is
     x86-boot-export-boot_params-via-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86 boot: export boot_params via sysfs
From: "Huang, Ying" <ying.huang@intel.com>

Export the boot parameters via sysfs.  This can be used for debugging and
kexec.

The files added are as follow:

/sys/kernel/boot_params/data	: binary file for struct boot_params
/sys/kernel/boot_params/version	: boot protocol version

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile_32 |    1 
 arch/x86/kernel/Makefile_64 |    1 
 arch/x86/kernel/ksysfs.c    |   94 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c   |    2 
 arch/x86/kernel/setup_32.c  |    2 
 5 files changed, 98 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/Makefile_32~x86-boot-export-boot_params-via-sysfs arch/x86/kernel/Makefile_32
--- a/arch/x86/kernel/Makefile_32~x86-boot-export-boot_params-via-sysfs
+++ a/arch/x86/kernel/Makefile_32
@@ -45,6 +45,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
diff -puN arch/x86/kernel/Makefile_64~x86-boot-export-boot_params-via-sysfs arch/x86/kernel/Makefile_64
--- a/arch/x86/kernel/Makefile_64~x86-boot-export-boot_params-via-sysfs
+++ a/arch/x86/kernel/Makefile_64
@@ -40,6 +40,7 @@ obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
 obj-$(CONFIG_EFI)		+= efi.o efi_64.o efi_stub_64.o
+obj-$(CONFIG_SYSFS)		+= ksysfs.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
diff -puN /dev/null arch/x86/kernel/ksysfs.c
--- /dev/null
+++ a/arch/x86/kernel/ksysfs.c
@@ -0,0 +1,94 @@
+/*
+ * arch/i386/ksysfs.c - architecture specific sysfs attributes in /sys/kernel
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *      Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/mm.h>
+
+#include <asm/setup.h>
+
+static ssize_t boot_params_version_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
+}
+
+static struct kobj_attribute boot_params_version_attr = {
+	.attr = {
+		.name = "version",
+		.mode = S_IRUGO,
+	},
+	.show = boot_params_version_show,
+};
+
+static struct attribute *boot_params_attrs[] = {
+	&boot_params_version_attr.attr,
+	NULL
+};
+
+static struct attribute_group boot_params_attr_group = {
+	.attrs = boot_params_attrs,
+};
+
+static ssize_t boot_params_data_read(struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, (void *)&boot_params + off, count);
+	return count;
+}
+
+static struct bin_attribute boot_params_data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = boot_params_data_read,
+	.size = sizeof(boot_params),
+};
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int error;
+	struct kobject *boot_params_kobj;
+
+	boot_params_kobj = kobject_create_and_register("boot_params",
+						       kernel_kobj);
+	if (!boot_params_kobj) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	error = sysfs_create_group(boot_params_kobj,
+				   &boot_params_attr_group);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	error = sysfs_create_bin_file(boot_params_kobj,
+				      &boot_params_data_attr);
+	if (error)
+		goto err_boot_params_subsys_unregister;
+	return 0;
+err_boot_params_subsys_unregister:
+	kobject_unregister(boot_params_kobj);
+err_return:
+	return error;
+}
+
+static int __init arch_ksysfs_init(void)
+{
+	int error;
+
+	error = boot_params_ksysfs_init();
+
+	return error;
+}
+
+arch_initcall(arch_ksysfs_init);
diff -puN arch/x86/kernel/setup64.c~x86-boot-export-boot_params-via-sysfs arch/x86/kernel/setup64.c
--- a/arch/x86/kernel/setup64.c~x86-boot-export-boot_params-via-sysfs
+++ a/arch/x86/kernel/setup64.c
@@ -24,7 +24,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
diff -puN arch/x86/kernel/setup_32.c~x86-boot-export-boot_params-via-sysfs arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~x86-boot-export-boot_params-via-sysfs
+++ a/arch/x86/kernel/setup_32.c
@@ -194,7 +194,7 @@ unsigned long saved_videomode;
 
 static char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct boot_params __initdata boot_params;
+struct boot_params boot_params;
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
x86-boot-use-e820-memory-map-on-efi-32-platform.patch
x86-boot-export-boot_params-via-sysfs.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
