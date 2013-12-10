From: akpm@linux-foundation.org
Subject: + x86-export-x86-boot_params-to-sysfs.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:23:26 -0800
Message-ID: <52a7a26e.2jsu1cN8ExUlbupY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3LJXX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + x86-export-x86-boot_params-to-sysfs.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:26 -0800


The patch titled
     Subject: x86: export x86 boot_params to sysfs
has been added to the -mm tree.  Its filename is
     x86-export-x86-boot_params-to-sysfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-export-x86-boot_params-to-sysfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-export-x86-boot_params-to-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: x86: export x86 boot_params to sysfs

kexec-tools use boot_params for getting the 1st kernel hardware_subarch,
the kexec kernel efi runtime support also need read the old efi_info from
boot_params.  Currently it exists in debugfs which is not a good place for
such infomation.  Per HPA, we should avoid of "sploit debugfs".

In this patch /sys/kernel/boot_params are exported, also the setup_data is
exported as a subdirectory.  kexec-tools is using debugfs for
hardware_subarch for a long time now so we're not removing it yet.

Structure is like below:

/sys/kernel/boot_params
|__ data                /* boot_params in binary*/
|__ setup_data
|   |__ 0               /* the first setup_data node */
|   |   |__ data        /* setup_data node 0 in binary*/
|   |   |__ type        /* setup_data type of setup_data node 0, hex string */
[snip]
|__ version             /* boot protocal version (in hex, "0x" prefixed)*/

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-boot_params |   39 +
 arch/x86/kernel/Makefile                           |    1 
 arch/x86/kernel/ksysfs.c                           |  339 +++++++++++
 3 files changed, 379 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-boot_params
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-boot_params
@@ -0,0 +1,39 @@
+What:		/sys/kernel/boot_params
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		The /sys/kernel/boot_params directory contains two
+		files: "data" and "version" and one subdirectory "setup_data".
+		It is used to export the kernel boot parameters of an x86
+		platform to userspace for kexec and debugging purpose.
+
+		If there's no setup_data in boot_params the subdirectory will
+		not be created.
+
+		"data" file is the binary representation of struct boot_params.
+
+		"version" file is the string representation of boot
+		protocol version.
+
+		"setup_data" subdirectory contains the setup_data data
+		structure in boot_params. setup_data is maintained in kernel
+		as a link list. In "setup_data" subdirectory there's one
+		subdirectory for each link list node named with the number
+		of the list nodes. The list node subdirectory contains two
+		files "type" and "data". "type" file is the string
+		representation of setup_data type. "data" file is the binary
+		representation of setup_data payload.
+
+		The whole boot_params directory structure is like below:
+		/sys/kernel/boot_params
+		|__ data
+		|__ setup_data
+		|   |__ 0
+		|   |   |__ data
+		|   |   |__ type
+		|   |__ 1
+		|       |__ data
+		|       |__ type
+		|__ version
+
+Users:		Kexec
diff -puN arch/x86/kernel/Makefile~x86-export-x86-boot_params-to-sysfs arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~x86-export-x86-boot_params-to-sysfs
+++ a/arch/x86/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x86
 obj-y			+= syscall_$(BITS).o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff -puN /dev/null arch/x86/kernel/ksysfs.c
--- /dev/null
+++ a/arch/x86/kernel/ksysfs.c
@@ -0,0 +1,339 @@
+/*
+ * Architecture specific sysfs attributes in /sys/kernel
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *      Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2013, 2013 Red Hat, Inc.
+ *      Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+
+#include <asm/setup.h>
+
+static ssize_t version_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
+}
+
+static struct kobj_attribute boot_params_version_attr = __ATTR_RO(version);
+
+static ssize_t boot_params_data_read(struct file *fp, struct kobject *kobj,
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
+static struct attribute *boot_params_version_attrs[] = {
+	&boot_params_version_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *boot_params_data_attrs[] = {
+	&boot_params_data_attr,
+	NULL,
+};
+
+static struct attribute_group boot_params_attr_group = {
+	.attrs = boot_params_version_attrs,
+	.bin_attrs = boot_params_data_attrs,
+};
+
+static int kobj_to_setup_data_nr(struct kobject *kobj, int *nr)
+{
+	const char *name;
+
+	name = kobject_name(kobj);
+	return kstrtoint(name, 10, nr);
+}
+
+static int get_setup_data_paddr(int nr, u64 *paddr)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		if (nr == i) {
+			*paddr = pa_data;
+			return 0;
+		}
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static int __init get_setup_data_size(int nr, size_t *size)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+		if (nr == i) {
+			*size = data->len;
+			iounmap(data);
+			return 0;
+		}
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_show(struct kobject *kobj,
+			 struct kobj_attribute *attr, char *buf)
+{
+	int nr, ret;
+	u64 paddr;
+	struct setup_data *data;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	ret = sprintf(buf, "0x%x\n", data->type);
+	iounmap(data);
+	return ret;
+}
+
+static ssize_t setup_data_data_read(struct file *fp,
+				    struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf,
+				    loff_t off, size_t count)
+{
+	int nr, ret = 0;
+	u64 paddr;
+	struct setup_data *data;
+	void *p;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	if (off > data->len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (count > data->len - off)
+		count = data->len - off;
+
+	if (!count)
+		goto out;
+
+	ret = count;
+	p = ioremap_cache(paddr + sizeof(*data), data->len);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(buf, p + off, count);
+	iounmap(p);
+out:
+	iounmap(data);
+	return ret;
+}
+
+static struct kobj_attribute type_attr = __ATTR_RO(type);
+
+static struct bin_attribute data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = setup_data_data_read,
+};
+
+static struct attribute *setup_data_type_attrs[] = {
+	&type_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *setup_data_data_attrs[] = {
+	&data_attr,
+	NULL,
+};
+
+static struct attribute_group setup_data_attr_group = {
+	.attrs = setup_data_type_attrs,
+	.bin_attrs = setup_data_data_attrs,
+};
+
+static int __init create_setup_data_node(struct kobject *parent,
+					 struct kobject **kobjp, int nr)
+{
+	int ret = 0;
+	size_t size;
+	struct kobject *kobj;
+	char name[16]; /* should be enough for setup_data nodes numbers */
+	snprintf(name, 16, "%d", nr);
+
+	kobj = kobject_create_and_add(name, parent);
+	if (!kobj)
+		return -ENOMEM;
+
+	ret = get_setup_data_size(nr, &size);
+	if (ret)
+		goto out_kobj;
+
+	data_attr.size = size;
+	ret = sysfs_create_group(kobj, &setup_data_attr_group);
+	if (ret)
+		goto out_kobj;
+	*kobjp = kobj;
+
+	return 0;
+out_kobj:
+	kobject_put(kobj);
+	return ret;
+}
+
+static void __init cleanup_setup_data_node(struct kobject *kobj)
+{
+	sysfs_remove_group(kobj, &setup_data_attr_group);
+	kobject_put(kobj);
+}
+
+static int __init get_setup_data_total_num(u64 pa_data, int *nr)
+{
+	int ret = 0;
+	struct setup_data *data;
+
+	*nr = 0;
+	while (pa_data) {
+		*nr += 1;
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		pa_data = data->next;
+		iounmap(data);
+	}
+
+out:
+	return ret;
+}
+
+static int __init create_setup_data_nodes(struct kobject *parent)
+{
+	struct kobject *setup_data_kobj, **kobjp;
+	u64 pa_data;
+	int i, j, nr, ret = 0;
+
+	pa_data = boot_params.hdr.setup_data;
+	if (!pa_data)
+		return 0;
+
+	setup_data_kobj = kobject_create_and_add("setup_data", parent);
+	if (!setup_data_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_setup_data_total_num(pa_data, &nr);
+	if (ret)
+		goto out_setup_data_kobj;
+
+	kobjp = kmalloc(sizeof(*kobjp) * nr, GFP_KERNEL);
+	if (!kobjp) {
+		ret = -ENOMEM;
+		goto out_setup_data_kobj;
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = create_setup_data_node(setup_data_kobj, kobjp + i, i);
+		if (ret)
+			goto out_clean_nodes;
+	}
+
+	kfree(kobjp);
+	return 0;
+
+out_clean_nodes:
+	for (j = i - 1; j > 0; j--)
+		cleanup_setup_data_node(*(kobjp + j));
+	kfree(kobjp);
+out_setup_data_kobj:
+	kobject_put(setup_data_kobj);
+out:
+	return ret;
+}
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int ret;
+	struct kobject *boot_params_kobj;
+
+	boot_params_kobj = kobject_create_and_add("boot_params",
+						  kernel_kobj);
+	if (!boot_params_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sysfs_create_group(boot_params_kobj, &boot_params_attr_group);
+	if (ret)
+		goto out_boot_params_kobj;
+
+	ret = create_setup_data_nodes(boot_params_kobj);
+	if (ret)
+		goto out_create_group;
+
+	return 0;
+out_create_group:
+	sysfs_remove_group(boot_params_kobj, &boot_params_attr_group);
+out_boot_params_kobj:
+	kobject_put(boot_params_kobj);
+out:
+	return ret;
+}
+
+arch_initcall(boot_params_ksysfs_init);
_

Patches currently in -mm which might be from dyoung@redhat.com are

kexec-migrate-to-reboot-cpu.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
efi-use-early_memremap-and-early_memunmap.patch
efi-remove-unused-variables-in-__map_region.patch
efi-add-a-wrapper-function-efi_map_region_fixed.patch
efi-reserve-boot-service-fix.patch
efi-cleanup-efi_enter_virtual_mode-function.patch
efi-export-more-efi-table-variable-to-sysfs.patch
efi-export-efi-runtime-memory-mapping-to-sysfs.patch
efi-pass-kexec-necessary-efi-data-via-setup_data.patch
efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch
x86-add-xloadflags-bit-for-efi-runtime-support-on-kexec.patch
x86-export-x86-boot_params-to-sysfs.patch
x86-reserve-setup_data-ranges-late-after-parsing-memmap-cmdline.patch
x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch

