From: akpm@linux-foundation.org
Subject: + drivers-char-memc-cleanups.patch added to -mm tree
Date: Mon, 08 Feb 2010 15:10:27 -0800
Message-ID: <201002082310.o18NARB0008939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046Ab0BHXKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 18:10:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     drivers/char/mem.c: cleanups
has been added to the -mm tree.  Its filename is
     drivers-char-memc-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |  139 +++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 70 deletions(-)

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
@@ -49,11 +49,12 @@ static inline unsigned long size_inside_
  * outside of main memory.
  *
  */
-static inline int uncached_access(struct file *file, unsigned long addr)
+static int uncached_access(struct file *file, unsigned long addr)
 {
 #if defined(CONFIG_IA64)
 	/*
-	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory
+	 * attribute aliases.
 	 */
 	return !(efi_mem_attributes(addr) & EFI_MEMORY_WB);
 #elif defined(CONFIG_MIPS)
@@ -65,7 +66,8 @@ static inline int uncached_access(struct
 	}
 #else
 	/*
-	 * Accessing memory above the top the kernel knows about or through a file pointer
+	 * Accessing memory above the top the kernel knows about or through a
+	 * file pointer
 	 * that was marked O_DSYNC will be done non-cached.
 	 */
 	if (file->f_flags & O_DSYNC)
@@ -115,15 +117,15 @@ static inline int range_is_allowed(unsig
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
@@ -140,10 +142,10 @@ static ssize_t read_mem(struct file * fi
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
@@ -157,9 +159,9 @@ static ssize_t read_mem(struct file * fi
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
@@ -180,7 +182,7 @@ static ssize_t read_mem(struct file * fi
 	return read;
 }
 
-static ssize_t write_mem(struct file * file, const char __user * buf, 
+static ssize_t write_mem(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -212,9 +214,9 @@ static ssize_t write_mem(struct file * f
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
@@ -242,7 +244,7 @@ static ssize_t write_mem(struct file * f
 	return written;
 }
 
-int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
+int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
 {
 	return 1;
@@ -294,7 +296,7 @@ static const struct vm_operations_struct
 #endif
 };
 
-static int mmap_mem(struct file * file, struct vm_area_struct * vma)
+static int mmap_mem(struct file *file, struct vm_area_struct *vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
 
@@ -329,7 +331,7 @@ static int mmap_mem(struct file * file, 
 }
 
 #ifdef CONFIG_DEVKMEM
-static int mmap_kmem(struct file * file, struct vm_area_struct * vma)
+static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long pfn;
 
@@ -337,9 +339,9 @@ static int mmap_kmem(struct file * file,
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
@@ -389,7 +391,7 @@ static ssize_t read_oldmem(struct file *
 /*
  * This function reads the *virtual* memory as seen by the kernel.
  */
-static ssize_t read_kmem(struct file *file, char __user *buf, 
+static ssize_t read_kmem(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
@@ -400,8 +402,8 @@ static ssize_t read_kmem(struct file *fi
 	read = 0;
 	if (p < (unsigned long) high_memory) {
 		low_count = count;
-		if (count > (unsigned long) high_memory - p)
-			low_count = (unsigned long) high_memory - p;
+		if (count > (unsigned long)high_memory - p)
+			low_count = (unsigned long)high_memory - p;
 
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 		/* we don't have page 0 mapped on sparc and m68k.. */
@@ -465,9 +467,8 @@ static ssize_t read_kmem(struct file *fi
 }
 
 
-static inline ssize_t
-do_write_kmem(unsigned long p, const char __user *buf,
-	      size_t count, loff_t *ppos)
+static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
 	ssize_t written, sz;
 	unsigned long copied;
@@ -491,9 +492,9 @@ do_write_kmem(unsigned long p, const cha
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
 
@@ -514,11 +515,10 @@ do_write_kmem(unsigned long p, const cha
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
@@ -570,17 +570,17 @@ static ssize_t write_kmem(struct file * 
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
+		if (__put_user(inb(i),tmp) < 0)
+			return -EFAULT;
 		i++;
 		tmp++;
 	}
@@ -588,7 +588,7 @@ static ssize_t read_port(struct file * f
 	return tmp-buf;
 }
 
-static ssize_t write_port(struct file * file, const char __user * buf,
+static ssize_t write_port(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	unsigned long i = *ppos;
@@ -601,7 +601,7 @@ static ssize_t write_port(struct file * 
 		if (__get_user(c, tmp)) {
 			if (tmp > buf)
 				break;
-			return -EFAULT; 
+			return -EFAULT;
 		}
 		outb(c,i);
 		i++;
@@ -612,13 +612,13 @@ static ssize_t write_port(struct file * 
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
@@ -636,7 +636,7 @@ static ssize_t splice_write_null(struct 
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
 }
 
-static ssize_t read_zero(struct file * file, char __user * buf, 
+static ssize_t read_zero(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	size_t written;
@@ -667,7 +667,7 @@ static ssize_t read_zero(struct file * f
 	return written ? written : -EFAULT;
 }
 
-static int mmap_zero(struct file * file, struct vm_area_struct * vma)
+static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 {
 #ifndef CONFIG_MMU
 	return -ENOSYS;
@@ -677,7 +677,7 @@ static int mmap_zero(struct file * file,
 	return 0;
 }
 
-static ssize_t write_full(struct file * file, const char __user * buf,
+static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return -ENOSPC;
@@ -688,8 +688,7 @@ static ssize_t write_full(struct file * 
  * can fopen() both devices with "a" now.  This was previously impossible.
  * -- SRB.
  */
-
-static loff_t null_lseek(struct file * file, loff_t offset, int orig)
+static loff_t null_lseek(struct file *file, loff_t offset, int orig)
 {
 	return file->f_pos = 0;
 }
@@ -702,31 +701,31 @@ static loff_t null_lseek(struct file * f
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
@@ -810,7 +809,7 @@ static const struct file_operations oldm
 };
 #endif
 
-static ssize_t kmsg_write(struct file * file, const char __user * buf,
+static ssize_t kmsg_write(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	char *tmp;
@@ -887,7 +886,7 @@ static int memory_open(struct inode *ino
 }
 
 static const struct file_operations memory_fops = {
-	.open		= memory_open,
+	.open = memory_open,
 };
 
 static char *mem_devnode(struct device *dev, mode_t *mode)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

