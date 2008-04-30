From: akpm@linux-foundation.org
Subject: - proc-remove-proc_bus.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:55 -0700
Message-ID: <200804300545.m3U5jt2x029555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbYD3GFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove proc_bus
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove proc_bus
From: Alexey Dobriyan <adobriyan@gmail.com>

Remove proc_bus export and variable itself. Using pathnames works fine
and is slightly more understandable and greppable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ecard.c    |    2 +-
 drivers/input/input.c      |    6 +++---
 drivers/nubus/proc.c       |    2 +-
 drivers/pci/proc.c         |    2 +-
 drivers/pnp/isapnp/proc.c  |    2 +-
 drivers/pnp/pnpbios/proc.c |    4 ++--
 drivers/usb/core/inode.c   |    4 ++--
 drivers/zorro/proc.c       |    2 +-
 fs/proc/root.c             |    5 ++---
 include/linux/proc_fs.h    |    2 --
 10 files changed, 14 insertions(+), 17 deletions(-)

diff -puN arch/arm/kernel/ecard.c~proc-remove-proc_bus arch/arm/kernel/ecard.c
--- a/arch/arm/kernel/ecard.c~proc-remove-proc_bus
+++ a/arch/arm/kernel/ecard.c
@@ -778,7 +778,7 @@ static struct proc_dir_entry *proc_bus_e
 
 static void ecard_proc_init(void)
 {
-	proc_bus_ecard_dir = proc_mkdir("ecard", proc_bus);
+	proc_bus_ecard_dir = proc_mkdir("bus/ecard", NULL);
 	create_proc_info_entry("devices", 0, proc_bus_ecard_dir,
 		get_ecard_dev_info);
 }
diff -puN drivers/input/input.c~proc-remove-proc_bus drivers/input/input.c
--- a/drivers/input/input.c~proc-remove-proc_bus
+++ a/drivers/input/input.c
@@ -898,7 +898,7 @@ static int __init input_proc_init(void)
 {
 	struct proc_dir_entry *entry;
 
-	proc_bus_input_dir = proc_mkdir("input", proc_bus);
+	proc_bus_input_dir = proc_mkdir("bus/input", NULL);
 	if (!proc_bus_input_dir)
 		return -ENOMEM;
 
@@ -921,7 +921,7 @@ static int __init input_proc_init(void)
 	return 0;
 
  fail2:	remove_proc_entry("devices", proc_bus_input_dir);
- fail1: remove_proc_entry("input", proc_bus);
+ fail1: remove_proc_entry("bus/input", NULL);
 	return -ENOMEM;
 }
 
@@ -929,7 +929,7 @@ static void input_proc_exit(void)
 {
 	remove_proc_entry("devices", proc_bus_input_dir);
 	remove_proc_entry("handlers", proc_bus_input_dir);
-	remove_proc_entry("input", proc_bus);
+	remove_proc_entry("bus/input", NULL);
 }
 
 #else /* !CONFIG_PROC_FS */
diff -puN drivers/nubus/proc.c~proc-remove-proc_bus drivers/nubus/proc.c
--- a/drivers/nubus/proc.c~proc-remove-proc_bus
+++ a/drivers/nubus/proc.c
@@ -171,7 +171,7 @@ void __init nubus_proc_init(void)
 {
 	if (!MACH_IS_MAC)
 		return;
-	proc_bus_nubus_dir = proc_mkdir("nubus", proc_bus);
+	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
 	create_proc_info_entry("devices", 0, proc_bus_nubus_dir,
 				get_nubus_dev_info);
 	proc_bus_nubus_add_devices();
diff -puN drivers/pci/proc.c~proc-remove-proc_bus drivers/pci/proc.c
--- a/drivers/pci/proc.c~proc-remove-proc_bus
+++ a/drivers/pci/proc.c
@@ -472,7 +472,7 @@ static int __init pci_proc_init(void)
 {
 	struct proc_dir_entry *entry;
 	struct pci_dev *dev = NULL;
-	proc_bus_pci_dir = proc_mkdir("pci", proc_bus);
+	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
 	entry = create_proc_entry("devices", 0, proc_bus_pci_dir);
 	if (entry)
 		entry->proc_fops = &proc_bus_pci_dev_operations;
diff -puN drivers/pnp/isapnp/proc.c~proc-remove-proc_bus drivers/pnp/isapnp/proc.c
--- a/drivers/pnp/isapnp/proc.c~proc-remove-proc_bus
+++ a/drivers/pnp/isapnp/proc.c
@@ -116,7 +116,7 @@ int __init isapnp_proc_init(void)
 {
 	struct pnp_dev *dev;
 
-	isapnp_proc_bus_dir = proc_mkdir("isapnp", proc_bus);
+	isapnp_proc_bus_dir = proc_mkdir("bus/isapnp", NULL);
 	protocol_for_each_dev(&isapnp_protocol, dev) {
 		isapnp_proc_attach_device(dev);
 	}
diff -puN drivers/pnp/pnpbios/proc.c~proc-remove-proc_bus drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~proc-remove-proc_bus
+++ a/drivers/pnp/pnpbios/proc.c
@@ -256,7 +256,7 @@ int pnpbios_interface_attach_device(stru
  */
 int __init pnpbios_proc_init(void)
 {
-	proc_pnp = proc_mkdir("pnp", proc_bus);
+	proc_pnp = proc_mkdir("bus/pnp", NULL);
 	if (!proc_pnp)
 		return -EIO;
 	proc_pnp_boot = proc_mkdir("boot", proc_pnp);
@@ -294,5 +294,5 @@ void __exit pnpbios_proc_exit(void)
 	remove_proc_entry("configuration_info", proc_pnp);
 	remove_proc_entry("devices", proc_pnp);
 	remove_proc_entry("boot", proc_pnp);
-	remove_proc_entry("pnp", proc_bus);
+	remove_proc_entry("bus/pnp", NULL);
 }
diff -puN drivers/usb/core/inode.c~proc-remove-proc_bus drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~proc-remove-proc_bus
+++ a/drivers/usb/core/inode.c
@@ -773,7 +773,7 @@ int __init usbfs_init(void)
 	usb_register_notify(&usbfs_nb);
 
 	/* create mount point for usbfs */
-	usbdir = proc_mkdir("usb", proc_bus);
+	usbdir = proc_mkdir("bus/usb", NULL);
 
 	return 0;
 }
@@ -783,6 +783,6 @@ void usbfs_cleanup(void)
 	usb_unregister_notify(&usbfs_nb);
 	unregister_filesystem(&usb_fs_type);
 	if (usbdir)
-		remove_proc_entry("usb", proc_bus);
+		remove_proc_entry("bus/usb", NULL);
 }
 
diff -puN drivers/zorro/proc.c~proc-remove-proc_bus drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~proc-remove-proc_bus
+++ a/drivers/zorro/proc.c
@@ -128,7 +128,7 @@ static int __init zorro_proc_init(void)
 	u_int slot;
 
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(ZORRO)) {
-		proc_bus_zorro_dir = proc_mkdir("zorro", proc_bus);
+		proc_bus_zorro_dir = proc_mkdir("bus/zorro", NULL);
 		create_proc_info_entry("devices", 0, proc_bus_zorro_dir,
 				       get_zorro_dev_info);
 		for (slot = 0; slot < zorro_num_autocon; slot++)
diff -puN fs/proc/root.c~proc-remove-proc_bus fs/proc/root.c
--- a/fs/proc/root.c~proc-remove-proc_bus
+++ a/fs/proc/root.c
@@ -22,7 +22,7 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_bus, *proc_root_fs, *proc_root_driver;
+struct proc_dir_entry *proc_root_fs, *proc_root_driver;
 
 static int proc_test_super(struct super_block *sb, void *data)
 {
@@ -137,7 +137,7 @@ void __init proc_root_init(void)
 #ifdef CONFIG_PROC_DEVICETREE
 	proc_device_tree_init();
 #endif
-	proc_bus = proc_mkdir("bus", NULL);
+	proc_mkdir("bus", NULL);
 	proc_sys_init();
 }
 
@@ -236,5 +236,4 @@ EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
 EXPORT_SYMBOL(proc_root_fs);
-EXPORT_SYMBOL(proc_bus);
 EXPORT_SYMBOL(proc_root_driver);
diff -puN include/linux/proc_fs.h~proc-remove-proc_bus include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-remove-proc_bus
+++ a/include/linux/proc_fs.h
@@ -98,7 +98,6 @@ struct vmcore {
 
 extern struct proc_dir_entry proc_root;
 extern struct proc_dir_entry *proc_root_fs;
-extern struct proc_dir_entry *proc_bus;
 extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
@@ -214,7 +213,6 @@ extern void dup_mm_exe_file(struct mm_st
 #else
 
 #define proc_root_driver NULL
-#define proc_bus NULL
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
 static inline void proc_net_remove(struct net *net, const char *name) {}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

