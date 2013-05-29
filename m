From: akpm@linux-foundation.org
Subject: + dev-oldmem-remove-the-interface.patch added to -mm tree
Date: Wed, 29 May 2013 15:20:19 -0700
Message-ID: <51a67f23.OwRFRsER4NugMTYb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2WUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, tony.luck@intel.com, schwidefsky@de.ibm.com, ralf@linux-mips.org, paulus@samba.org, matt.fleming@intel.com, hpa@zytor.com, holzheu@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, ebiederm@xmission.com, dave@sr71.net, benh@kernel.crashing.org, zhangyanfei@cn.fujitsu.com

Subject: + dev-oldmem-remove-the-interface.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,benh@kernel.crashing.org,dave@sr71.net,ebiederm@xmission.com,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,holzheu@linux.vnet.ibm.com,hpa@zytor.com,matt.fleming@intel.com,paulus@samba.org,ralf@linux-mips.org,schwidefsky@de.ibm.com,tony.luck@intel.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:20:19 -0700


The patch titled
     Subject: /dev/oldmem: Remove the interface
has been added to the -mm tree.  Its filename is
     dev-oldmem-remove-the-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 drivers/char/mem.c |   47 -------------------------------------------
 1 file changed, 47 deletions(-)

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

linux-next.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

