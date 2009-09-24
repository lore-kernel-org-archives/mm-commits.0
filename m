From: akpm@linux-foundation.org
Subject: [merged] drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:24 -0700
Message-ID: <200909241936.n8OJaON1002415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbZIXTgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/uv_mmtimer.c: add memory mapped RTC driver for UV
has been removed from the -mm tree.  Its filename was
     drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/uv_mmtimer.c: add memory mapped RTC driver for UV
From: Dimitri Sivanich <sivanich@sgi.com>

This driver memory maps the UV Hub RTC.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    1 
 drivers/char/Kconfig                 |    8 
 drivers/char/Makefile                |    1 
 drivers/char/uv_mmtimer.c            |  216 +++++++++++++++++++++++++
 4 files changed, 226 insertions(+)

diff -puN Documentation/ioctl/ioctl-number.txt~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -135,6 +135,7 @@ Code	Seq#	Include File		Comments
 					<http://mikonos.dia.unisa.it/tcfs>
 'l'	40-7F	linux/udf_fs_i.h	in development:
 					<http://sourceforge.net/projects/linux-udf/>
+'m'	00-09	linux/mmtimer.h
 'm'	all	linux/mtio.h		conflict!
 'm'	all	linux/soundcard.h	conflict!
 'm'	all	linux/synclink.h	conflict!
diff -puN drivers/char/Kconfig~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv drivers/char/Kconfig
--- a/drivers/char/Kconfig~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv
+++ a/drivers/char/Kconfig
@@ -1087,6 +1087,14 @@ config MMTIMER
 	  The mmtimer device allows direct userspace access to the
 	  Altix system timer.
 
+config UV_MMTIMER
+	tristate "UV_MMTIMER Memory mapped RTC for SGI UV"
+	depends on X86_UV
+	default m
+	help
+	  The uv_mmtimer device allows direct userspace access to the
+	  UV system timer.
+
 source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
diff -puN drivers/char/Makefile~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv drivers/char/Makefile
--- a/drivers/char/Makefile~drivers-char-uv_mmtimerc-add-memory-mapped-rtc-driver-for-uv
+++ a/drivers/char/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_MMTIMER)		+= mmtimer.o
+obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
 obj-$(CONFIG_VIOTAPE)		+= viotape.o
 obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
diff -puN /dev/null drivers/char/uv_mmtimer.c
--- /dev/null
+++ a/drivers/char/uv_mmtimer.c
@@ -0,0 +1,216 @@
+/*
+ * Timer device implementation for SGI UV platform.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2009 Silicon Graphics, Inc.  All rights reserved.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ioctl.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/mmtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/posix-timers.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/math64.h>
+#include <linux/smp_lock.h>
+
+#include <asm/genapic.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/bios.h>
+#include <asm/uv/uv.h>
+
+MODULE_AUTHOR("Dimitri Sivanich <sivanich@sgi.com>");
+MODULE_DESCRIPTION("SGI UV Memory Mapped RTC Timer");
+MODULE_LICENSE("GPL");
+
+/* name of the device, usually in /dev */
+#define UV_MMTIMER_NAME "mmtimer"
+#define UV_MMTIMER_DESC "SGI UV Memory Mapped RTC Timer"
+#define UV_MMTIMER_VERSION "1.0"
+
+static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg);
+static int uv_mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
+
+/*
+ * Period in femtoseconds (10^-15 s)
+ */
+static unsigned long uv_mmtimer_femtoperiod;
+
+static const struct file_operations uv_mmtimer_fops = {
+	.owner = THIS_MODULE,
+	.mmap =	uv_mmtimer_mmap,
+	.unlocked_ioctl = uv_mmtimer_ioctl,
+};
+
+/**
+ * uv_mmtimer_ioctl - ioctl interface for /dev/uv_mmtimer
+ * @file: file structure for the device
+ * @cmd: command to execute
+ * @arg: optional argument to command
+ *
+ * Executes the command specified by @cmd.  Returns 0 for success, < 0 for
+ * failure.
+ *
+ * Valid commands:
+ *
+ * %MMTIMER_GETOFFSET - Should return the offset (relative to the start
+ * of the page where the registers are mapped) for the counter in question.
+ *
+ * %MMTIMER_GETRES - Returns the resolution of the clock in femto (10^-15)
+ * seconds
+ *
+ * %MMTIMER_GETFREQ - Copies the frequency of the clock in Hz to the address
+ * specified by @arg
+ *
+ * %MMTIMER_GETBITS - Returns the number of bits in the clock's counter
+ *
+ * %MMTIMER_MMAPAVAIL - Returns 1 if registers can be mmap'd into userspace
+ *
+ * %MMTIMER_GETCOUNTER - Gets the current value in the counter and places it
+ * in the address specified by @arg.
+ */
+static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case MMTIMER_GETOFFSET:	/* offset of the counter */
+		/*
+		 * UV RTC register is on its own page
+		 */
+		if (PAGE_SIZE <= (1 << 16))
+			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
+				/ 8;
+		else
+			ret = -ENOSYS;
+		break;
+
+	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
+		if (copy_to_user((unsigned long __user *)arg,
+				&uv_mmtimer_femtoperiod, sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+
+	case MMTIMER_GETFREQ: /* frequency in Hz */
+		if (copy_to_user((unsigned long __user *)arg,
+				&sn_rtc_cycles_per_second,
+				sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+
+	case MMTIMER_GETBITS: /* number of bits in the clock */
+		ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
+		break;
+
+	case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
+		ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
+		break;
+
+	case MMTIMER_GETCOUNTER:
+		if (copy_to_user((unsigned long __user *)arg,
+				(unsigned long *)uv_local_mmr_address(UVH_RTC),
+				sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+	return ret;
+}
+
+/**
+ * uv_mmtimer_mmap - maps the clock's registers into userspace
+ * @file: file structure for the device
+ * @vma: VMA to map the registers into
+ *
+ * Calls remap_pfn_range() to map the clock's registers into
+ * the calling process' address space.
+ */
+static int uv_mmtimer_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long uv_mmtimer_addr;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	if (PAGE_SIZE > (1 << 16))
+		return -ENOSYS;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	uv_mmtimer_addr = UV_LOCAL_MMR_BASE | UVH_RTC;
+	uv_mmtimer_addr &= ~(PAGE_SIZE - 1);
+	uv_mmtimer_addr &= 0xfffffffffffffffUL;
+
+	if (remap_pfn_range(vma, vma->vm_start, uv_mmtimer_addr >> PAGE_SHIFT,
+					PAGE_SIZE, vma->vm_page_prot)) {
+		printk(KERN_ERR "remap_pfn_range failed in uv_mmtimer_mmap\n");
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static struct miscdevice uv_mmtimer_miscdev = {
+	MISC_DYNAMIC_MINOR,
+	UV_MMTIMER_NAME,
+	&uv_mmtimer_fops
+};
+
+
+/**
+ * uv_mmtimer_init - device initialization routine
+ *
+ * Does initial setup for the uv_mmtimer device.
+ */
+static int __init uv_mmtimer_init(void)
+{
+	if (!is_uv_system()) {
+		printk(KERN_ERR "%s: Hardware unsupported\n", UV_MMTIMER_NAME);
+		return -1;
+	}
+
+	/*
+	 * Sanity check the cycles/sec variable
+	 */
+	if (sn_rtc_cycles_per_second < 100000) {
+		printk(KERN_ERR "%s: unable to determine clock frequency\n",
+		       UV_MMTIMER_NAME);
+		return -1;
+	}
+
+	uv_mmtimer_femtoperiod = ((unsigned long)1E15 +
+				sn_rtc_cycles_per_second / 2) /
+				sn_rtc_cycles_per_second;
+
+	if (misc_register(&uv_mmtimer_miscdev)) {
+		printk(KERN_ERR "%s: failed to register device\n",
+		       UV_MMTIMER_NAME);
+		return -1;
+	}
+
+	printk(KERN_INFO "%s: v%s, %ld MHz\n", UV_MMTIMER_DESC,
+		UV_MMTIMER_VERSION,
+		sn_rtc_cycles_per_second/(unsigned long)1E6);
+
+	return 0;
+}
+
+module_init(uv_mmtimer_init);
_

Patches currently in -mm which might be from sivanich@sgi.com are

origin.patch

