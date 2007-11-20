From: akpm@linux-foundation.org
Subject: + nubus-kill-drivers-nubus-nubus_symsc.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:01 -0800
Message-ID: <200711200215.lAK2F1vJ008943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762609AbXKTCPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     nubus: kill drivers/nubus/nubus_syms.c
has been added to the -mm tree.  Its filename is
     nubus-kill-drivers-nubus-nubus_symsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nubus: kill drivers/nubus/nubus_syms.c
From: Adrian Bunk <bunk@kernel.org>

nubus: kill drivers/nubus/nubus_syms.c

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/Makefile     |    1 -
 drivers/nubus/nubus.c      |   13 +++++++++++++
 drivers/nubus/nubus_syms.c |   28 ----------------------------
 drivers/nubus/proc.c       |    4 ++++
 4 files changed, 17 insertions(+), 29 deletions(-)

diff -puN drivers/nubus/Makefile~nubus-kill-drivers-nubus-nubus_symsc drivers/nubus/Makefile
--- a/drivers/nubus/Makefile~nubus-kill-drivers-nubus-nubus_symsc
+++ a/drivers/nubus/Makefile
@@ -4,5 +4,4 @@
 
 obj-y   := nubus.o
 
-obj-$(CONFIG_MODULES) += nubus_syms.o 
 obj-$(CONFIG_PROC_FS) += proc.o
diff -puN drivers/nubus/nubus.c~nubus-kill-drivers-nubus-nubus_symsc drivers/nubus/nubus.c
--- a/drivers/nubus/nubus.c~nubus-kill-drivers-nubus-nubus_symsc
+++ a/drivers/nubus/nubus.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/page.h>
@@ -186,6 +187,7 @@ void nubus_get_rsrc_mem(void *dest, cons
 		len--;
 	}
 }
+EXPORT_SYMBOL(nubus_get_rsrc_mem);
 
 void nubus_get_rsrc_str(void *dest, const struct nubus_dirent* dirent,
 			int len)
@@ -200,6 +202,7 @@ void nubus_get_rsrc_str(void *dest, cons
 		len--;
 	}
 }
+EXPORT_SYMBOL(nubus_get_rsrc_str);
 
 int nubus_get_root_dir(const struct nubus_board* board,
 		       struct nubus_dir* dir)
@@ -209,6 +212,7 @@ int nubus_get_root_dir(const struct nubu
 	dir->mask = board->lanes;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_root_dir);
 
 /* This is a slyly renamed version of the above */
 int nubus_get_func_dir(const struct nubus_dev* dev,
@@ -219,6 +223,7 @@ int nubus_get_func_dir(const struct nubu
 	dir->mask = dev->board->lanes;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_func_dir);
 
 int nubus_get_board_dir(const struct nubus_board* board,
 			struct nubus_dir* dir)
@@ -237,6 +242,7 @@ int nubus_get_board_dir(const struct nub
 		return -1;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_board_dir);
 
 int nubus_get_subdir(const struct nubus_dirent *ent,
 		     struct nubus_dir *dir)
@@ -246,6 +252,7 @@ int nubus_get_subdir(const struct nubus_
 	dir->mask = ent->mask;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_subdir);
 
 int nubus_readdir(struct nubus_dir *nd, struct nubus_dirent *ent)
 {
@@ -274,12 +281,14 @@ int nubus_readdir(struct nubus_dir *nd, 
 	ent->mask  = nd->mask;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_readdir);
 
 int nubus_rewinddir(struct nubus_dir* dir)
 {
 	dir->ptr = dir->base;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_rewinddir);
 
 /* Driver interface functions, more or less like in pci.c */
 
@@ -303,6 +312,7 @@ nubus_find_device(unsigned short categor
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_device);
 
 struct nubus_dev*
 nubus_find_type(unsigned short category,
@@ -320,6 +330,7 @@ nubus_find_type(unsigned short category,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_type);
 
 struct nubus_dev*
 nubus_find_slot(unsigned int slot,
@@ -335,6 +346,7 @@ nubus_find_slot(unsigned int slot,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_slot);
 
 int
 nubus_find_rsrc(struct nubus_dir* dir, unsigned char rsrc_type,
@@ -346,6 +358,7 @@ nubus_find_rsrc(struct nubus_dir* dir, u
 	}	
 	return -1;
 }
+EXPORT_SYMBOL(nubus_find_rsrc);
 
 /* Initialization functions - decide which slots contain stuff worth
    looking at, and print out lots and lots of information from the
diff -puN drivers/nubus/nubus_syms.c~nubus-kill-drivers-nubus-nubus_symsc /dev/null
--- a/drivers/nubus/nubus_syms.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/* Exported symbols for NuBus services
-
-   (c) 1999 David Huggins-Daines <dhd@debian.org> */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/nubus.h>
-
-#ifdef CONFIG_PROC_FS
-EXPORT_SYMBOL(nubus_proc_attach_device);
-EXPORT_SYMBOL(nubus_proc_detach_device);
-#endif
-
-MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(nubus_find_device);
-EXPORT_SYMBOL(nubus_find_type);
-EXPORT_SYMBOL(nubus_find_slot);
-EXPORT_SYMBOL(nubus_get_root_dir);
-EXPORT_SYMBOL(nubus_get_board_dir);
-EXPORT_SYMBOL(nubus_get_func_dir);
-EXPORT_SYMBOL(nubus_readdir);
-EXPORT_SYMBOL(nubus_find_rsrc);
-EXPORT_SYMBOL(nubus_rewinddir);
-EXPORT_SYMBOL(nubus_get_subdir);
-EXPORT_SYMBOL(nubus_get_rsrc_mem);
-EXPORT_SYMBOL(nubus_get_rsrc_str);
-
diff -puN drivers/nubus/proc.c~nubus-kill-drivers-nubus-nubus_symsc drivers/nubus/proc.c
--- a/drivers/nubus/proc.c~nubus-kill-drivers-nubus-nubus_symsc
+++ a/drivers/nubus/proc.c
@@ -22,6 +22,8 @@
 #include <linux/nubus.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
+#include <linux/module.h>
+
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
@@ -140,6 +142,7 @@ int nubus_proc_attach_device(struct nubu
 
 	return 0;
 }
+EXPORT_SYMBOL(nubus_proc_attach_device);
 
 /* FIXME: this is certainly broken! */
 int nubus_proc_detach_device(struct nubus_dev *dev)
@@ -154,6 +157,7 @@ int nubus_proc_detach_device(struct nubu
 	}
 	return 0;
 }
+EXPORT_SYMBOL(nubus_proc_detach_device);
 
 void __init proc_bus_nubus_add_devices(void)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

m68k-export-atari_keyb_init.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
