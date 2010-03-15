From: akpm@linux-foundation.org
Subject: [merged] drivers-char-memc-cleanups.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:34 -0400
Message-ID: <201003150658.o2F6w7AM016420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935683Ab0COG6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/mem.c: cleanups
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/mem.c: cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- fix switch statement layout

- fix whitespace stuff

- fix comment layout

- remove unneeded inlining

- use __weak

- remove trailing whitespace

- move uncached_access() inside `#ifndef __HAVE_PHYS_MEM_ACCESS_PROT' - it
  is otherwise unused.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |  204 +++++++++++++++++++++----------------------
 1 file changed, 102 insertions(+), 102 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-cleanups drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-cleanups
+++ a/drivers/char/mem.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
- *  Added devfs support. 
+ *  Added devfs support.
  *    Jan-11-1998, C. Scott Ananian <cananian@alumni.princeton.edu>
  *  Shared /dev/zero mmapping support, Feb 2000, Kanoj Sarcar <kanoj@sgi.com>
  */
@@ -44,36 +44,6 @@ static inline unsigned long size_inside_
 	return min(sz, size);
 }
 
-/*
- * Architectures vary in how they handle caching for addresses
- * outside of main memory.
- *
- */
-static inline int uncached_access(struct file *file, unsigned long addr)
-{
-#if defined(CONFIG_IA64)
-	/*
-	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.
-	 */
-	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
-#elif defined(CONFIG_MIPS)
-	{
-		extern int __uncached_access(struct file *file,
-					     unsigned long addr);
-
-		return __uncached_access(file, addr);
-	}
-#else
-	/*
-	 * Accessing memory above the top the kernel knows about or through a file pointer
-	 * that was marked O_DSYNC will be done non-cached.
-	 */
-	if (file->f_flags & O_DSYNC)
-		return 1;
-	return addr >= __pa(high_memory);
-#endif
-}
-
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
 static inline int valid_phys_addr_range(unsigned long addr, size_t count)
 {
@@ -115,15 +85,15 @@ static inline int range_is_allowed(unsig
 }
 #endif
 
-void __attribute__((weak)) unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
 }
 
 /*
- * This funcion reads the *physical* memory. The f_pos points directly to the 
- * memory location. 
+ * This funcion reads the *physical* memory. The f_pos points directly to the
+ * memory location.
  */
-static ssize_t read_mem(struct file * file, char __user * buf,
+static ssize_t read_mem(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -140,10 +110,10 @@ static ssize_t read_mem(struct file * fi
 		if (sz > 0) {
 			if (clear_user(buf, sz))
 				return -EFAULT;
-			buf += sz; 
-			p += sz; 
-			count -= sz; 
-			read += sz; 
+			buf += sz;
+			p += sz;
+			count -= sz;
+			read += sz;
 		}
 	}
 #endif
@@ -157,9 +127,9 @@ static ssize_t read_mem(struct file * fi
 			return -EPERM;
 
 		/*
-		 * On ia64 if a page has been mapped somewhere as
-		 * uncached, then it must also be accessed uncached
-		 * by the kernel or data corruption may occur
+		 * On ia64 if a page has been mapped somewhere as uncached, then
+		 * it must also be accessed uncached by the kernel or data
+		 * corruption may occur.
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 		if (!ptr)
@@ -180,7 +150,7 @@ static ssize_t read_mem(struct file * fi
 	return read;
 }
 
-static ssize_t write_mem(struct file * file, const char __user * buf, 
+static ssize_t write_mem(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -212,9 +182,9 @@ static ssize_t write_mem(struct file * f
 			return -EPERM;
 
 		/*
-		 * On ia64 if a page has been mapped somewhere as
-		 * uncached, then it must also be accessed uncached
-		 * by the kernel or data corruption may occur
+		 * On ia64 if a page has been mapped somewhere as uncached, then
+		 * it must also be accessed uncached by the kernel or data
+		 * corruption may occur.
 		 */
 		ptr = xlate_dev_mem_ptr(p);
 		if (!ptr) {
@@ -242,13 +212,46 @@ static ssize_t write_mem(struct file * f
 	return written;
 }
 
-int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
+int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
 {
 	return 1;
 }
 
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
+
+/*
+ * Architectures vary in how they handle caching for addresses
+ * outside of main memory.
+ *
+ */
+static int uncached_access(struct file *file, unsigned long addr)
+{
+#if defined(CONFIG_IA64)
+	/*
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory
+	 * attribute aliases.
+	 */
+	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
+#elif defined(CONFIG_MIPS)
+	{
+		extern int __uncached_access(struct file *file,
+					     unsigned long addr);
+
+		return __uncached_access(file, addr);
+	}
+#else
+	/*
+	 * Accessing memory above the top the kernel knows about or through a
+	 * file pointer
+	 * that was marked O_DSYNC will be done non-cached.
+	 */
+	if (file->f_flags & O_DSYNC)
+		return 1;
+	return addr >= __pa(high_memory);
+#endif
+}
+
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
 {
@@ -294,7 +297,7 @@ static const struct vm_operations_struct
 #endif
 };
 
-static int mmap_mem(struct file * file, struct vm_area_struct * vma)
+static int mmap_mem(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
 
@@ -329,7 +332,7 @@ static int mmap_mem(struct file * file, 
 }
 
 #ifdef CONFIG_DEVKMEM
-static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
+static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long pfn;
 
@@ -337,9 +340,9 @@ static int mmap_kmem(struct file * file,
 	pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
 
 	/*
-	 * RED-PEN: on some architectures there is more mapped memory
-	 * than available in mem_map which pfn_valid checks
-	 * for. Perhaps should add a new macro here.
+	 * RED-PEN: on some architectures there is more mapped memory than
+	 * available in mem_map which pfn_valid checks for. Perhaps should add a
+	 * new macro here.
 	 *
 	 * RED-PEN: vmalloc is not supported right now.
 	 */
@@ -389,7 +392,7 @@ static ssize_t read_oldmem(struct file *
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
-static ssize_t read_kmem(struct file *file, char __user *buf, 
+static ssize_t read_kmem(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -400,8 +403,8 @@ static ssize_t read_kmem(struct file *fi
 	read = 0;
 	if (p < (unsigned long) high_memory) {
 		low_count = count;
-		if (count > (unsigned long) high_memory - p)
-			low_count = (unsigned long) high_memory - p;
+		if (count > (unsigned long)high_memory - p)
+			low_count = (unsigned long)high_memory - p;
 
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 		/* we don't have page 0 mapped on sparc and m68k.. */
@@ -465,9 +468,8 @@ static ssize_t read_kmem(struct file *fi
 }
 
 
-static inline ssize_t
-do_write_kmem(unsigned long p, const char __user *buf,
-	      size_t count, loff_t *ppos)
+static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
 	ssize_t written, sz;
 	unsigned long copied;
@@ -491,9 +493,9 @@ do_write_kmem(unsigned long p, const cha
 		sz = size_inside_page(p, count);
 
 		/*
-		 * On ia64 if a page has been mapped somewhere as
-		 * uncached, then it must also be accessed uncached
-		 * by the kernel or data corruption may occur
+		 * On ia64 if a page has been mapped somewhere as uncached, then
+		 * it must also be accessed uncached by the kernel or data
+		 * corruption may occur.
 		 */
 		ptr = xlate_dev_kmem_ptr((char *)p);
 
@@ -514,11 +516,10 @@ do_write_kmem(unsigned long p, const cha
 	return written;
 }
 
-
 /*
  * This function writes to the *virtual* memory as seen by the kernel.
  */
-static ssize_t write_kmem(struct file * file, const char __user * buf, 
+static ssize_t write_kmem(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -570,17 +571,17 @@ static ssize_t write_kmem(struct file * 
 #endif
 
 #ifdef CONFIG_DEVPORT
-static ssize_t read_port(struct file * file, char __user * buf,
+static ssize_t read_port(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	unsigned long i = *ppos;
 	char __user *tmp = buf;
 
 	if (!access_ok(VERIFY_WRITE, buf, count))
-		return -EFAULT; 
+		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-		if (__put_user(inb(i),tmp) < 0) 
-			return -EFAULT;  
+		if (__put_user(inb(i), tmp) < 0)
+			return -EFAULT;
 		i++;
 		tmp++;
 	}
@@ -588,22 +589,22 @@ static ssize_t read_port(struct file * f
 	return tmp-buf;
 }
 
-static ssize_t write_port(struct file * file, const char __user * buf,
+static ssize_t write_port(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	unsigned long i = *ppos;
 	const char __user * tmp = buf;
 
-	if (!access_ok(VERIFY_READ,buf,count))
+	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
 		char c;
 		if (__get_user(c, tmp)) {
 			if (tmp > buf)
 				break;
-			return -EFAULT; 
+			return -EFAULT;
 		}
-		outb(c,i);
+		outb(c, i);
 		i++;
 		tmp++;
 	}
@@ -612,13 +613,13 @@ static ssize_t write_port(struct file * 
 }
 #endif
 
-static ssize_t read_null(struct file * file, char __user * buf,
+static ssize_t read_null(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
-static ssize_t write_null(struct file * file, const char __user * buf,
+static ssize_t write_null(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return count;
@@ -630,13 +631,13 @@ static int pipe_to_null(struct pipe_inod
 	return sd->len;
 }
 
-static ssize_t splice_write_null(struct pipe_inode_info *pipe,struct file *out,
+static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 				 loff_t *ppos, size_t len, unsigned int flags)
 {
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
 }
 
-static ssize_t read_zero(struct file * file, char __user * buf, 
+static ssize_t read_zero(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	size_t written;
@@ -667,7 +668,7 @@ static ssize_t read_zero(struct file * f
 	return written ? written : -EFAULT;
 }
 
-static int mmap_zero(struct file * file, struct vm_area_struct * vma)
+static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
 	return -ENOSYS;
@@ -677,7 +678,7 @@ static int mmap_zero(struct file * file,
 	return 0;
 }
 
-static ssize_t write_full(struct file * file, const char __user * buf,
+static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return -ENOSPC;
@@ -688,8 +689,7 @@ static ssize_t write_full(struct file * 
  * can fopen() both devices with "a" now.  This was previously impossible.
  * -- SRB.
  */
-
-static loff_t null_lseek(struct file * file, loff_t offset, int orig)
+static loff_t null_lseek(struct file *file, loff_t offset, int orig)
 {
 	return file->f_pos = 0;
 }
@@ -702,31 +702,31 @@ static loff_t null_lseek(struct file * f
  * also note that seeking relative to the "end of file" isn't supported:
  * it has no meaning, so it returns -EINVAL.
  */
-static loff_t memory_lseek(struct file * file, loff_t offset, int orig)
+static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
 
 	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch (orig) {
-		case SEEK_CUR:
-			offset += file->f_pos;
-			if ((unsigned long long)offset <
-			    (unsigned long long)file->f_pos) {
-				ret = -EOVERFLOW;
-				break;
-			}
-		case SEEK_SET:
-			/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
-			if ((unsigned long long)offset >= ~0xFFFULL) {
-				ret = -EOVERFLOW;
-				break;
-			}
-			file->f_pos = offset;
-			ret = file->f_pos;
-			force_successful_syscall_return();
+	case SEEK_CUR:
+		offset += file->f_pos;
+		if ((unsigned long long)offset <
+		    (unsigned long long)file->f_pos) {
+			ret = -EOVERFLOW;
+			break;
+		}
+	case SEEK_SET:
+		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
+		if ((unsigned long long)offset >= ~0xFFFULL) {
+			ret = -EOVERFLOW;
 			break;
-		default:
-			ret = -EINVAL;
+		}
+		file->f_pos = offset;
+		ret = file->f_pos;
+		force_successful_syscall_return();
+		break;
+	default:
+		ret = -EINVAL;
 	}
 	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 	return ret;
@@ -810,7 +810,7 @@ static const struct file_operations oldm
 };
 #endif
 
-static ssize_t kmsg_write(struct file * file, const char __user * buf,
+static ssize_t kmsg_write(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	char *tmp;
@@ -832,7 +832,7 @@ static ssize_t kmsg_write(struct file * 
 }
 
 static const struct file_operations kmsg_fops = {
-	.write =	kmsg_write,
+	.write = kmsg_write,
 };
 
 static const struct memdev {
@@ -883,7 +883,7 @@ static int memory_open(struct inode *ino
 }
 
 static const struct file_operations memory_fops = {
-	.open		= memory_open,
+	.open = memory_open,
 };
 
 static char *mem_devnode(struct device *dev, mode_t *mode)
@@ -904,7 +904,7 @@ static int __init chr_dev_init(void)
 	if (err)
 		return err;
 
-	if (register_chrdev(MEM_MAJOR,"mem",&memory_fops))
+	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

