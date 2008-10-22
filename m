From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:04:24 -0700
Message-ID: <200810222004.m9MK4OvG013064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbYJVUE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:04:58 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9MK4O6k009404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2008 13:04:25 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/Kconfig |    3 ---
 drivers/pci/probe.c      |   28 ----------------------------
 fs/proc/vmcore.c         |    7 +------
 include/linux/mm_types.h |    3 ---
 kernel/sysctl.c          |    3 ---
 mm/Makefile              |    4 ----
 mm/hugetlb.c             |    9 ---------
 mm/migrate.c             |    3 ---
 8 files changed, 1 insertion(+), 59 deletions(-)

diff -puN drivers/mtd/nand/Kconfig~linux-next-git-rejects drivers/mtd/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~linux-next-git-rejects
+++ a/drivers/mtd/nand/Kconfig
@@ -56,15 +56,12 @@ config MTD_NAND_H1900
 	help
 	  This enables the driver for the iPAQ h1900 flash.
 
-<<<<<<< HEAD:drivers/mtd/nand/Kconfig
 config MTD_NAND_GPIO
 	tristate "GPIO NAND Flash driver"
 	depends on GENERIC_GPIO && ARM
 	help
 	  This enables a GPIO based NAND flash driver.
 
-=======
->>>>>>> FETCH_HEAD:drivers/mtd/nand/Kconfig
 config MTD_NAND_SPIA
 	tristate "NAND Flash device on SPIA board"
 	depends on ARCH_P720T
diff -puN drivers/pci/probe.c~linux-next-git-rejects drivers/pci/probe.c
--- a/drivers/pci/probe.c~linux-next-git-rejects
+++ a/drivers/pci/probe.c
@@ -236,15 +236,10 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-<<<<<<< HEAD:drivers/pci/probe.c
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: %pR\n",
-				pci_name(dev), pos, res);
-=======
 			dev_printk(KERN_DEBUG, &dev->dev,
 				"reg %x 64bit mmio: [%#llx-%#llx]\n", pos,
 				(unsigned long long)res->start,
 				(unsigned long long)res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -254,16 +249,9 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
-<<<<<<< HEAD:drivers/pci/probe.c
-		printk(KERN_DEBUG "PCI: %s reg %x %s: %pR\n",
-		       pci_name(dev), pos,
-		       (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
-		       res);
-=======
 		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: [%#llx-%#llx]\n", pos,
 			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
 			(unsigned long long)res->start, (unsigned long long)res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
  out:
@@ -334,14 +322,9 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-<<<<<<< HEAD:drivers/pci/probe.c
-		printk(KERN_DEBUG "PCI: bridge %s io port: %pR\n",
-		       pci_name(dev), res);
-=======
 		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: [%#llx-%#llx]\n",
 			(unsigned long long) res->start,
 			(unsigned long long) res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
 	res = child->resource[1];
@@ -353,14 +336,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-<<<<<<< HEAD:drivers/pci/probe.c
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: %pR\n",
-		       pci_name(dev), res);
-=======
 		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: [%#llx-%#llx]\n",
 			(unsigned long long) res->start,
 			(unsigned long long) res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 
 	res = child->resource[2];
@@ -396,15 +374,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-<<<<<<< HEAD:drivers/pci/probe.c
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: %pR\n",
-		       pci_name(dev),
-		       (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64":"32", res);
-=======
 		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: [%#llx-%#llx]\n",
 			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
->>>>>>> FETCH_HEAD:drivers/pci/probe.c
 	}
 }
 
diff -puN fs/proc/vmcore.c~linux-next-git-rejects fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~linux-next-git-rejects
+++ a/fs/proc/vmcore.c
@@ -32,15 +32,10 @@ static size_t elfcorebuf_sz;
 /* Total size of vmcore file. */
 static u64 vmcore_size;
 
-<<<<<<< HEAD:fs/proc/vmcore.c
-struct proc_dir_entry *proc_vmcore = NULL;
-=======
+static struct proc_dir_entry *proc_vmcore = NULL;
 /* Stores the physical address of elf header of crash image. */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
 
-static struct proc_dir_entry *proc_vmcore = NULL;
->>>>>>> FETCH_HEAD:fs/proc/vmcore.c
-
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
diff -puN include/linux/mm_types.h~linux-next-git-rejects include/linux/mm_types.h
--- a/include/linux/mm_types.h~linux-next-git-rejects
+++ a/include/linux/mm_types.h
@@ -94,8 +94,6 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
-<<<<<<< HEAD:include/linux/mm_types.h
-=======
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	unsigned long page_cgroup;
 #endif
@@ -103,7 +101,6 @@ struct page {
 #ifdef CONFIG_KMEMCHECK
 	void *shadow;
 #endif
->>>>>>> FETCH_HEAD:include/linux/mm_types.h
 };
 
 /*
diff -puN kernel/sysctl.c~linux-next-git-rejects kernel/sysctl.c
--- a/kernel/sysctl.c~linux-next-git-rejects
+++ a/kernel/sysctl.c
@@ -834,7 +834,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-<<<<<<< HEAD:kernel/sysctl.c
 #ifdef CONFIG_UNEVICTABLE_LRU
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -845,9 +844,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &scan_unevictable_handler,
 	},
 #endif
-=======
 
->>>>>>> FETCH_HEAD:kernel/sysctl.c
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -puN mm/Makefile~linux-next-git-rejects mm/Makefile
--- a/mm/Makefile~linux-next-git-rejects
+++ a/mm/Makefile
@@ -34,9 +34,5 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-<<<<<<< HEAD:mm/Makefile
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
-=======
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
->>>>>>> FETCH_HEAD:mm/Makefile
diff -puN mm/hugetlb.c~linux-next-git-rejects mm/hugetlb.c
--- a/mm/hugetlb.c~linux-next-git-rejects
+++ a/mm/hugetlb.c
@@ -1459,21 +1459,12 @@ int hugetlb_overcommit_handler(struct ct
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
-<<<<<<< HEAD:mm/hugetlb.c
-	return sprintf(buf,
-			"HugePages_Total:   %5lu\n"
-			"HugePages_Free:    %5lu\n"
-			"HugePages_Rsvd:    %5lu\n"
-			"HugePages_Surp:    %5lu\n"
-			"Hugepagesize:   %8lu kB\n",
-=======
 	seq_printf(m,
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
 			"HugePages_Surp:  %5lu\n"
 			"Hugepagesize:    %5lu kB\n",
->>>>>>> FETCH_HEAD:mm/hugetlb.c
 			h->nr_huge_pages,
 			h->free_huge_pages,
 			h->resv_huge_pages,
diff -puN mm/migrate.c~linux-next-git-rejects mm/migrate.c
--- a/mm/migrate.c~linux-next-git-rejects
+++ a/mm/migrate.c
@@ -1045,12 +1045,9 @@ asmlinkage long sys_move_pages(pid_t pid
 			const int __user *nodes,
 			int __user *status, int flags)
 {
-<<<<<<< HEAD:mm/migrate.c
-=======
 	const struct cred *cred = current_cred(), *tcred;
 	int err = 0;
 	int i;
->>>>>>> FETCH_HEAD:mm/migrate.c
 	struct task_struct *task;
 	struct mm_struct *mm;
 	int err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-page_cgroup-allocation-fix.patch
memcg-fix-page_cgroup-allocation-fix-2.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-unbork-meminfo.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-sh.patch
git-tests-git-rejects.patch
git-acpi.patch
revert-i7300_idle-driver-v155.patch
git-tip.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
why-does-this-keep-happening.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

