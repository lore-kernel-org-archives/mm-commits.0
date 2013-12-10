From: akpm@linux-foundation.org
Subject: + efi-export-efi-runtime-memory-mapping-to-sysfs.patch added to
 -mm tree
Date: Tue, 10 Dec 2013 15:23:18 -0800
Message-ID: <52a7a266.w6dyxtIvzEAkQXGb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LJXXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-export-efi-runtime-memory-mapping-to-sysfs.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:18 -0800


The patch titled
     Subject: efi: export efi runtime memory mapping to sysfs
has been added to the -mm tree.  Its filename is
     efi-export-efi-runtime-memory-mapping-to-sysfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-export-efi-runtime-memory-mapping-to-sysfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-export-efi-runtime-memory-mapping-to-sysfs.patch

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
Subject: efi: export efi runtime memory mapping to sysfs

kexec kernel will need exactly same mapping for efi runtime memory ranges.
 Thus here export the runtime ranges mapping to sysfs, kexec-tools will
assemble them and pass to 2nd kernel via setup_data.

Introduce a new directory /sys/firmware/efi/runtime-map Just like
/sys/firmware/memmap.  Containing below attribute in each file of that
directory: attribute num_pages phys_addr type virt_addr

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

 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map |   36 ++
 arch/x86/platform/efi/efi.c                              |   28 +
 drivers/firmware/efi/Kconfig                             |   11 
 drivers/firmware/efi/Makefile                            |    1 
 drivers/firmware/efi/efi.c                               |    4 
 drivers/firmware/efi/runtime-map.c                       |  176 ++++++++++
 include/linux/efi.h                                      |    6 
 7 files changed, 261 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
@@ -0,0 +1,36 @@
+What:		/sys/firmware/efi/runtime-map/
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		Switching efi runtime services to virtual mode requires
+		that all efi memory ranges which have the runtime attribute
+		bit set to be mapped to virtual addresses.
+
+		The efi runtime services can only be switched to virtual
+		mode once without rebooting. The kexec kernel must maintain
+		the same physical to virtual address mappings as the first
+		kernel. The mappings are exported to sysfs so userspace tools
+		can reassemble them and pass them into the kexec kernel.
+
+		/sys/firmware/efi/runtime-map/ is the directory the kernel
+		exports that information in.
+
+		subdirectories are named with the number of the memory range:
+
+			/sys/firmware/efi/runtime-map/0
+			/sys/firmware/efi/runtime-map/1
+			/sys/firmware/efi/runtime-map/2
+			/sys/firmware/efi/runtime-map/3
+			...
+
+		Each subdirectory contains five files:
+
+		attribute : The attributes of the memory range.
+		num_pages : The size of the memory range in pages.
+		phys_addr : The physical address of the memory range.
+		type      : The type of the memory range.
+		virt_addr : The virtual address of the memory range.
+
+		Above values are all hexadecimal numbers with the '0x' prefix.
+
+Users:		Kexec
diff -puN arch/x86/platform/efi/efi.c~efi-export-efi-runtime-memory-mapping-to-sysfs arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-export-efi-runtime-memory-mapping-to-sysfs
+++ a/arch/x86/platform/efi/efi.c
@@ -76,6 +76,9 @@ static __initdata efi_config_table_type_
 	{NULL_GUID, NULL, NULL},
 };
 
+void *efi_runtime_map;
+int nr_efi_runtime_map;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -810,6 +813,19 @@ static void __init efi_merge_regions(voi
 	}
 }
 
+static int __init save_runtime_map(efi_memory_desc_t *md, int idx)
+{
+	void *p;
+	p = krealloc(efi_runtime_map, (idx + 1) * memmap.desc_size, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	efi_runtime_map = p;
+	memcpy(efi_runtime_map + idx * memmap.desc_size, md, memmap.desc_size);
+
+	return 0;
+}
+
 /*
  * Map efi memory ranges for runtime serivce and update new_memmap with virtual
  * addresses.
@@ -820,6 +836,7 @@ static void * __init efi_map_regions(int
 	void *p, *tmp, *new_memmap = NULL;
 	unsigned long size;
 	u64 end, systab;
+	int err = 0;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -848,10 +865,21 @@ static void * __init efi_map_regions(int
 		new_memmap = tmp;
 		memcpy(new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA) {
+			err = save_runtime_map(md, nr_efi_runtime_map);
+			if (err)
+				goto out_save_runtime;
+			nr_efi_runtime_map++;
+		}
 		(*count)++;
 	}
 
 	return new_memmap;
+out_save_runtime:
+	kfree(efi_runtime_map);
+	nr_efi_runtime_map = 0;
+	efi_runtime_map = NULL;
 out_krealloc:
 	kfree(new_memmap);
 	return NULL;
diff -puN drivers/firmware/efi/Kconfig~efi-export-efi-runtime-memory-mapping-to-sysfs drivers/firmware/efi/Kconfig
--- a/drivers/firmware/efi/Kconfig~efi-export-efi-runtime-memory-mapping-to-sysfs
+++ a/drivers/firmware/efi/Kconfig
@@ -39,4 +39,15 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 config UEFI_CPER
 	def_bool n
 
+config EFI_RUNTIME_MAP
+	bool "Export efi runtime maps to sysfs" if EXPERT
+	depends on X86 && EFI && KEXEC
+	default y
+	help
+	  Export efi runtime memory maps to /sys/firmware/efi/runtime-map.
+	  That memory map is used for example by kexec to set up efi virtual
+	  mapping the 2nd kernel, but can also be used for debugging purposes.
+
+	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
+
 endmenu
diff -puN drivers/firmware/efi/Makefile~efi-export-efi-runtime-memory-mapping-to-sysfs drivers/firmware/efi/Makefile
--- a/drivers/firmware/efi/Makefile~efi-export-efi-runtime-memory-mapping-to-sysfs
+++ a/drivers/firmware/efi/Makefile
@@ -5,3 +5,4 @@ obj-y					+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
+obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
diff -puN drivers/firmware/efi/efi.c~efi-export-efi-runtime-memory-mapping-to-sysfs drivers/firmware/efi/efi.c
--- a/drivers/firmware/efi/efi.c~efi-export-efi-runtime-memory-mapping-to-sysfs
+++ a/drivers/firmware/efi/efi.c
@@ -38,7 +38,8 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
-static struct kobject *efi_kobj;
+struct kobject *efi_kobj;
+EXPORT_SYMBOL_GPL(efi_kobj);
 static struct kobject *efivars_kobj;
 
 /*
@@ -183,6 +184,7 @@ err_unregister:
 	generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
+	efi_kobj = NULL;
 	return error;
 }
 
diff -puN /dev/null drivers/firmware/efi/runtime-map.c
--- /dev/null
+++ a/drivers/firmware/efi/runtime-map.c
@@ -0,0 +1,176 @@
+/*
+ * linux/drivers/efi/runtime-map.c
+ * Copyright (C) 2013 Red Hat, Inc., Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+
+#include <asm/setup.h>
+
+struct efi_runtime_map_entry {
+	efi_memory_desc_t md;
+	struct kobject kobj;   /* kobject for each entry */
+};
+
+static struct efi_runtime_map_entry **map_entries;
+
+struct map_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct efi_runtime_map_entry *entry, char *buf);
+};
+
+static inline struct map_attribute *to_map_attr(struct attribute *attr)
+{
+	return container_of(attr, struct map_attribute, attr);
+}
+
+static ssize_t type_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%x\n", entry->md.type);
+}
+
+#define EFI_RUNTIME_FIELD(var) entry->md.var
+
+#define EFI_RUNTIME_U64_ATTR_SHOW(name) \
+static ssize_t name##_show(struct efi_runtime_map_entry *entry, char *buf) \
+{ \
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", EFI_RUNTIME_FIELD(name)); \
+}
+
+EFI_RUNTIME_U64_ATTR_SHOW(phys_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(virt_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(num_pages);
+EFI_RUNTIME_U64_ATTR_SHOW(attribute);
+
+static inline struct efi_runtime_map_entry *to_map_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct efi_runtime_map_entry, kobj);
+}
+
+static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct efi_runtime_map_entry *entry = to_map_entry(kobj);
+	struct map_attribute *map_attr = to_map_attr(attr);
+
+	return map_attr->show(entry, buf);
+}
+
+static struct map_attribute map_type_attr = __ATTR_RO(type);
+static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
+static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
+static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
+static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
+
+/*
+ * These are default attributes that are added for every memmap entry.
+ */
+static struct attribute *def_attrs[] = {
+	&map_type_attr.attr,
+	&map_phys_addr_attr.attr,
+	&map_virt_addr_attr.attr,
+	&map_num_pages_attr.attr,
+	&map_attribute_attr.attr,
+	NULL
+};
+
+static const struct sysfs_ops map_attr_ops = {
+	.show = map_attr_show,
+};
+
+static void map_release(struct kobject *kobj)
+{
+	struct efi_runtime_map_entry *entry;
+
+	entry = to_map_entry(kobj);
+	kfree(entry);
+}
+
+static struct kobj_type __refdata map_ktype = {
+	.sysfs_ops	= &map_attr_ops,
+	.default_attrs	= def_attrs,
+	.release	= map_release,
+};
+
+static struct kset *map_kset;
+
+static struct efi_runtime_map_entry *add_sysfs_runtime_map_entry(int nr)
+{
+	int ret;
+	struct efi_runtime_map_entry *entry;
+	struct efi_info *e = &boot_params.efi_info;
+
+	if (!map_kset) {
+		map_kset = kset_create_and_add("runtime-map", NULL,
+				efi_kobj);
+		if (!map_kset)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		kset_unregister(map_kset);
+		return entry;
+	}
+
+	memcpy(&entry->md, efi_runtime_map + nr * e->efi_memdesc_size,
+	       sizeof(efi_memory_desc_t));
+
+	kobject_init(&entry->kobj, &map_ktype);
+	entry->kobj.kset = map_kset;
+	ret = kobject_add(&entry->kobj, NULL, "%d", nr);
+	if (ret) {
+		kobject_put(&entry->kobj);
+		kset_unregister(map_kset);
+		return ERR_PTR(ret);
+	}
+
+	return entry;
+}
+
+static int __init efi_runtime_map_init(void)
+{
+	int i, j, ret = 0;
+	struct efi_runtime_map_entry *entry;
+
+	if (!efi_kobj)
+		return 0;
+
+	if (!efi_runtime_map)
+		return 0;
+
+	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
+	if (!map_entries) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		entry = add_sysfs_runtime_map_entry(i);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto out_add_entry;
+		}
+		*(map_entries + i) = entry;
+	}
+
+	return 0;
+out_add_entry:
+	for (j = i - 1; j > 0; j--) {
+		entry = *(map_entries + j);
+		kobject_put(&entry->kobj);
+	}
+	if (map_kset)
+		kset_unregister(map_kset);
+out:
+	return ret;
+}
+
+subsys_initcall(efi_runtime_map_init);
diff -puN include/linux/efi.h~efi-export-efi-runtime-memory-mapping-to-sysfs include/linux/efi.h
--- a/include/linux/efi.h~efi-export-efi-runtime-memory-mapping-to-sysfs
+++ a/include/linux/efi.h
@@ -876,4 +876,10 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+extern void *efi_runtime_map;
+extern int nr_efi_runtime_map;
+extern struct kobject *efi_kobj;
+#endif
+
 #endif /* _LINUX_EFI_H */
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

