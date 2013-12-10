From: akpm@linux-foundation.org
Subject: + efi-export-more-efi-table-variable-to-sysfs.patch added to -mm
 tree
Date: Tue, 10 Dec 2013 15:23:16 -0800
Message-ID: <52a7a264.1/8Cs+xt7uTgYYsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LJXXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + efi-export-more-efi-table-variable-to-sysfs.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:16 -0800


The patch titled
     Subject: efi: export more efi table variable to sysfs
has been added to the -mm tree.  Its filename is
     efi-export-more-efi-table-variable-to-sysfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-export-more-efi-table-variable-to-sysfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-export-more-efi-table-variable-to-sysfs.patch

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
Subject: efi: export more efi table variable to sysfs

Export fw_vendor, runtime and config table physical addresses to
/sys/firmware/efi/fw_vendor, /sys/firmware/efi/runtime and
/sys/firmware/efi/config_table because kexec kernel will need them.

To conform to the EFI spec these 3 variables will be updated to virtual
address after entering virtual mode.  But kernel startup code will need
the physical address.

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

 Documentation/ABI/testing/sysfs-firmware-efi |   24 ++++++++++
 arch/x86/platform/efi/efi.c                  |    4 +
 drivers/firmware/efi/efi.c                   |   39 +++++++++++++++++
 include/linux/efi.h                          |    3 +
 4 files changed, 70 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-firmware-efi
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-firmware-efi
@@ -0,0 +1,24 @@
+What:		/sys/firmware/efi/fw_vendor
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		It shows the physical address of firmware vendor field in the
+		EFI system table.
+
+Users:		Kexec
+
+What:		/sys/firmware/efi/runtime
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		It shows the physical address of runtime service table entry in
+		the EFI system table.
+Users:		Kexec
+
+What:		/sys/firmware/efi/config_table
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:
+		It shows the physical address of config table entry in the EFI
+		system table.
+Users:		Kexec
diff -puN arch/x86/platform/efi/efi.c~efi-export-more-efi-table-variable-to-sysfs arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~efi-export-more-efi-table-variable-to-sysfs
+++ a/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.config_table = (unsigned long)efi.systab->tables;
+	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime	 = (unsigned long)efi.systab->runtime;
+
 	/*
 	 * Show what we know for posterity
 	 */
diff -puN drivers/firmware/efi/efi.c~efi-export-more-efi-table-variable-to-sysfs drivers/firmware/efi/efi.c
--- a/drivers/firmware/efi/efi.c~efi-export-more-efi-table-variable-to-sysfs
+++ a/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_table  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -71,13 +74,49 @@ static ssize_t systab_show(struct kobjec
 static struct kobj_attribute efi_attr_systab =
 			__ATTR(systab, 0400, systab_show, NULL);
 
+#define EFI_FIELD(var) efi.var
+
+#define EFI_ATTR_SHOW(name) \
+static ssize_t name##_show(struct kobject *kobj, \
+				struct kobj_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
+}
+
+EFI_ATTR_SHOW(fw_vendor);
+EFI_ATTR_SHOW(runtime);
+EFI_ATTR_SHOW(config_table);
+
+static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
+static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
+static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
+	&efi_attr_fw_vendor.attr,
+	&efi_attr_runtime.attr,
+	&efi_attr_config_table.attr,
 	NULL,	/* maybe more in the future? */
 };
 
+static umode_t efi_attr_is_visible(struct kobject *kobj,
+				   struct attribute *attr, int n)
+{
+	umode_t mode = attr->mode;
+
+	if (attr == &efi_attr_fw_vendor.attr)
+		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_runtime.attr)
+		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_config_table.attr)
+		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+
+	return mode;
+}
+
 static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
+	.is_visible = efi_attr_is_visible,
 };
 
 static struct efivars generic_efivars;
diff -puN include/linux/efi.h~efi-export-more-efi-table-variable-to-sysfs include/linux/efi.h
--- a/include/linux/efi.h~efi-export-more-efi-table-variable-to-sysfs
+++ a/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;	/* fw_vendor */
+	unsigned long runtime;		/* runtime table */
+	unsigned long config_table;	/* config tables */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
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

