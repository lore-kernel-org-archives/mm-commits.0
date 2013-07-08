From: akpm@linux-foundation.org
Subject: [merged] dev-oldmem-remove-the-interface.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:36:17 -0700
Message-ID: <51db14b1.utKpt6/4oSaUBK2S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GHTgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] dev-oldmem-remove-the-interface.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:17 -0700


The patch titled
     Subject: /dev/oldmem: Remove the interface
has been removed from the -mm tree.  Its filename was
     dev-oldmem-remove-the-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: /dev/oldmem: Remove the interface

/dev/oldmem provides the interface for us to access the "old memory" in
the dump-capture kernel.  Unfortunately, no one actually uses this
interface.

And this interface could actually cause some real problems if used on ia64
where the cached/uncached accesses are mixed.  See the discussion from the
link: https://lkml.org/lkml/2013/4/12/386.

So Eric suggested that we should remove /dev/oldmem as an unused piece of
code.

[akpm@linux-foundation.org: mention /dev/oldmem obsolescence in devices.txt]
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt |    3 --
 drivers/char/mem.c        |   47 ------------------------------------
 2 files changed, 1 insertion(+), 49 deletions(-)

diff -puN Documentation/devices.txt~dev-oldmem-remove-the-interface Documentation/devices.txt
--- a/Documentation/devices.txt~dev-oldmem-remove-the-interface
+++ a/Documentation/devices.txt
@@ -100,8 +100,7 @@ Your cooperation is appreciated.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's, reads
 					export the buffered printk records.
-		 12 = /dev/oldmem	Used by crashdump kernels to access
-					the memory of the kernel that crashed.
+		 12 = /dev/oldmem	OBSOLETE - replaced by /proc/vmcore
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
diff -puN drivers/char/mem.c~dev-oldmem-remove-the-interface drivers/char/mem.c
--- a/drivers/char/mem.c~dev-oldmem-remove-the-interface
+++ a/drivers/char/mem.c
@@ -21,7 +21,6 @@
 #include <linux/ptrace.h>
 #include <linux/device.h>
 #include <linux/highmem.h>
-#include <linux/crash_dump.h>
 #include <linux/backing-dev.h>
 #include <linux/bootmem.h>
 #include <linux/splice.h>
@@ -357,40 +356,6 @@ static int mmap_kmem(struct file *file,
 }
 #endif
 
-#ifdef CONFIG_CRASH_DUMP
-/*
- * Read memory corresponding to the old kernel.
- */
-static ssize_t read_oldmem(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	unsigned long pfn, offset;
-	size_t read = 0, csize;
-	int rc = 0;
-
-	while (count) {
-		pfn = *ppos / PAGE_SIZE;
-		if (pfn > saved_max_pfn)
-			return read;
-
-		offset = (unsigned long)(*ppos % PAGE_SIZE);
-		if (count > PAGE_SIZE - offset)
-			csize = PAGE_SIZE - offset;
-		else
-			csize = count;
-
-		rc = copy_oldmem_page(pfn, buf, csize, offset, 1);
-		if (rc < 0)
-			return rc;
-		buf += csize;
-		*ppos += csize;
-		read += csize;
-		count -= csize;
-	}
-	return read;
-}
-#endif
-
 #ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
@@ -772,7 +737,6 @@ static int open_port(struct inode *inode
 #define aio_write_zero	aio_write_null
 #define open_mem	open_port
 #define open_kmem	open_mem
-#define open_oldmem	open_mem
 
 static const struct file_operations mem_fops = {
 	.llseek		= memory_lseek,
@@ -837,14 +801,6 @@ static const struct file_operations full
 	.write		= write_full,
 };
 
-#ifdef CONFIG_CRASH_DUMP
-static const struct file_operations oldmem_fops = {
-	.read	= read_oldmem,
-	.open	= open_oldmem,
-	.llseek = default_llseek,
-};
-#endif
-
 static const struct memdev {
 	const char *name;
 	umode_t mode;
@@ -866,9 +822,6 @@ static const struct memdev {
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #endif
-#ifdef CONFIG_CRASH_DUMP
-	[12] = { "oldmem", 0, &oldmem_fops, NULL },
-#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
mm-vmallocc-remove-dead-code-in-vb_alloc.patch
mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch
mm-vmallocc-remove-alloc_map-from-vmap_block.patch
mm-vmallocc-emit-the-failure-message-before-return.patch
mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch
mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch
mm-remove-zone_type-argument-of-build_zonelists_node.patch
mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch
mm-remove-unlikely-from-the-current_order-test.patch
mm-remove-unused-__put_page.patch
mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch
mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch

