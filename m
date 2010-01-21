From: akpm@linux-foundation.org
Subject: [alternative-merged] sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:16:53 -0800
Message-ID: <201001212116.o0LLGspo030099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab0AUVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, gregkh@suse.de, shaohui.zheng@intel.com, mm-commits@vger.kernel.org


The patch titled
     sysdev: fix prototype for memory_sysdev_class show/store functions
has been removed from the -mm tree.  Its filename was
     sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysdev: fix prototype for memory_sysdev_class show/store functions
From: Wu Fengguang <fengguang.wu@intel.com>

The function prototype mismatches in call stack:

                [<ffffffff81494268>] print_block_size+0x58/0x60
                [<ffffffff81487e3f>] sysdev_class_show+0x1f/0x30
                [<ffffffff811d629b>] sysfs_read_file+0xcb/0x1f0
                [<ffffffff81176328>] vfs_read+0xc8/0x180

Due to prototype mismatch, print_block_size() will sprintf() into
*attribute instead of *buf, hence user space will read the initial
zeros from *buf:
	$ hexdump /sys/devices/system/memory/block_size_bytes
	0000000 0000 0000 0000 0000
	0000008

After patch:
	cat /sys/devices/system/memory/block_size_bytes
	0x8000000

This complements commits c29af9636 and 4a0b2b4dbe.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Zheng, Shaohui" <shaohui.zheng@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN drivers/base/memory.c~sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions drivers/base/memory.c
--- a/drivers/base/memory.c~sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions
+++ a/drivers/base/memory.c
@@ -309,17 +309,19 @@ static SYSDEV_ATTR(removable, 0444, show
  * Block size attribute stuff
  */
 static ssize_t
-print_block_size(struct class *class, char *buf)
+print_block_size(struct sysdev_class *class,
+		 struct sysdev_class_attribute *class_attr,
+		 char *buf)
 {
 	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
-static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
+static SYSDEV_CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
 static int block_size_init(void)
 {
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_block_size_bytes.attr);
+				&attr_block_size_bytes.attr);
 }
 
 /*
@@ -330,7 +332,9 @@ static int block_size_init(void)
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
-memory_probe_store(struct class *class, const char *buf, size_t count)
+memory_probe_store(struct sysdev_class *class,
+		   struct sysdev_class_attribute *class_attr,
+		   const char *buf, size_t count)
 {
 	u64 phys_addr;
 	int nid;
@@ -346,12 +350,12 @@ memory_probe_store(struct class *class, 
 
 	return count;
 }
-static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
+static SYSDEV_CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_probe.attr);
+				&attr_probe.attr);
 }
 #else
 static inline int memory_probe_init(void)
@@ -367,7 +371,9 @@ static inline int memory_probe_init(void
 
 /* Soft offline a page */
 static ssize_t
-store_soft_offline_page(struct class *class, const char *buf, size_t count)
+store_soft_offline_page(struct sysdev_class *class,
+			struct sysdev_class_attribute *class_attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -384,7 +390,9 @@ store_soft_offline_page(struct class *cl
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-store_hard_offline_page(struct class *class, const char *buf, size_t count)
+store_hard_offline_page(struct sysdev_class *class,
+			struct sysdev_class_attribute *class_attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -397,18 +405,18 @@ store_hard_offline_page(struct class *cl
 	return ret ? ret : count;
 }
 
-static CLASS_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
-static CLASS_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
+static SYSDEV_CLASS_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
+static SYSDEV_CLASS_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
 
 static __init int memory_fail_init(void)
 {
 	int err;
 
 	err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_soft_offline_page.attr);
+				&attr_soft_offline_page.attr);
 	if (!err)
 		err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&class_attr_hard_offline_page.attr);
+				&attr_hard_offline_page.attr);
 	return err;
 }
 #else
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch

