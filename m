From: akpm@linux-foundation.org
Subject: + drivers-char-memc-cleanups-fix.patch added to -mm tree
Date: Mon, 08 Feb 2010 15:12:39 -0800
Message-ID: <201002082312.o18NCdDh009064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab0BHXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 18:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     drivers-char-memc-cleanups-fix
has been added to the -mm tree.  Its filename is
     drivers-char-memc-cleanups-fix.patch

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
drivers-char-memc-cleanups-fix.patch
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

