From: akpm@linux-foundation.org
Subject: [folded] drivers-char-memc-cleanups-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:51:23 -0800
Message-ID: <201003102251.o2AMpNNJ008636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419Ab0CJWv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:51:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     drivers-char-memc-cleanups-fix
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-cleanups-fix.patch

This patch was dropped because it was folded into drivers-char-memc-cleanups.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-char-memc-cleanups-fix
From: Andrew Morton <akpm@linux-foundation.org>

More repairs

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-cleanups-fix drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-cleanups-fix
+++ a/drivers/char/mem.c
@@ -579,7 +579,7 @@ static ssize_t read_port(struct file *fi
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-		if (__put_user(inb(i),tmp) < 0)
+		if (__put_user(inb(i), tmp) < 0)
 			return -EFAULT;
 		i++;
 		tmp++;
@@ -594,7 +594,7 @@ static ssize_t write_port(struct file *f
 	unsigned long i = *ppos;
 	const char __user * tmp = buf;
 
-	if (!access_ok(VERIFY_READ,buf,count))
+	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
 		char c;
@@ -603,7 +603,7 @@ static ssize_t write_port(struct file *f
 				break;
 			return -EFAULT;
 		}
-		outb(c,i);
+		outb(c, i);
 		i++;
 		tmp++;
 	}
@@ -630,7 +630,7 @@ static int pipe_to_null(struct pipe_inod
 	return sd->len;
 }
 
-static ssize_t splice_write_null(struct pipe_inode_info *pipe,struct file *out,
+static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
 				 loff_t *ppos, size_t len, unsigned int flags)
 {
 	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
@@ -831,7 +831,7 @@ static ssize_t kmsg_write(struct file *f
 }
 
 static const struct file_operations kmsg_fops = {
-	.write =	kmsg_write,
+	.write = kmsg_write,
 };
 
 static const struct memdev {
@@ -907,7 +907,7 @@ static int __init chr_dev_init(void)
 	if (err)
 		return err;
 
-	if (register_chrdev(MEM_MAJOR,"mem",&memory_fops))
+	if (register_chrdev(MEM_MAJOR, "mem", &memory_fops))
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper.patch
broadsheetfb-support-storing-waveform.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
pps-serial-clients-support-warning-fixes.patch
sysctl-extern-cleanup-binfmts-fix.patch
sysctl-extern-cleanup-module-fix.patch
linux-next.patch
linux-next-fixups.patch
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
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
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

