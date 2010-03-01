From: akpm@linux-foundation.org
Subject: [merged] jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:44 -0800
Message-ID: <201003011946.o21JkiVE028693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463Ab0CATrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:47:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, rdiezmail-kernelbugzilla@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     jffs2: avoid using C++ keyword `new' in userspace-visible header
has been removed from the -mm tree.  Its filename was
     jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2: avoid using C++ keyword `new' in userspace-visible header
From: Andrew Morton <akpm@linux-foundation.org>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14995

Reported-by: R. Diez <rdiezmail-kernelbugzilla@yahoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/fs.c         |   10 +++++-----
 fs/jffs2/nodelist.h   |    8 ++++----
 include/linux/jffs2.h |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/jffs2/fs.c~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/fs/jffs2/fs.c
@@ -313,8 +313,8 @@ struct inode *jffs2_iget(struct super_bl
 	case S_IFBLK:
 	case S_IFCHR:
 		/* Read the device numbers from the media */
-		if (f->metadata->size != sizeof(jdev.old) &&
-		    f->metadata->size != sizeof(jdev.new)) {
+		if (f->metadata->size != sizeof(jdev.old_id) &&
+		    f->metadata->size != sizeof(jdev.new_id)) {
 			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
 			goto error_io;
 		}
@@ -325,10 +325,10 @@ struct inode *jffs2_iget(struct super_bl
 			printk(KERN_NOTICE "Read device numbers for inode %lu failed\n", (unsigned long)inode->i_ino);
 			goto error;
 		}
-		if (f->metadata->size == sizeof(jdev.old))
-			rdev = old_decode_dev(je16_to_cpu(jdev.old));
+		if (f->metadata->size == sizeof(jdev.old_id))
+			rdev = old_decode_dev(je16_to_cpu(jdev.old_id));
 		else
-			rdev = new_decode_dev(je32_to_cpu(jdev.new));
+			rdev = new_decode_dev(je32_to_cpu(jdev.new_id));
 
 	case S_IFSOCK:
 	case S_IFIFO:
diff -puN fs/jffs2/nodelist.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header fs/jffs2/nodelist.h
--- a/fs/jffs2/nodelist.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/fs/jffs2/nodelist.h
@@ -312,11 +312,11 @@ static inline int jffs2_blocks_use_vmall
 static inline int jffs2_encode_dev(union jffs2_device_node *jdev, dev_t rdev)
 {
 	if (old_valid_dev(rdev)) {
-		jdev->old = cpu_to_je16(old_encode_dev(rdev));
-		return sizeof(jdev->old);
+		jdev->old_id = cpu_to_je16(old_encode_dev(rdev));
+		return sizeof(jdev->old_id);
 	} else {
-		jdev->new = cpu_to_je32(new_encode_dev(rdev));
-		return sizeof(jdev->new);
+		jdev->new_id = cpu_to_je32(new_encode_dev(rdev));
+		return sizeof(jdev->new_id);
 	}
 }
 
diff -puN include/linux/jffs2.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header include/linux/jffs2.h
--- a/include/linux/jffs2.h~jffs2-avoid-using-c-keyword-new-in-userspace-visible-header
+++ a/include/linux/jffs2.h
@@ -215,8 +215,8 @@ union jffs2_node_union
 
 /* Data payload for device nodes. */
 union jffs2_device_node {
-	jint16_t old;
-	jint32_t new;
+	jint16_t old_id;
+	jint32_t new_id;
 };
 
 #endif /* __LINUX_JFFS2_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
serial-spi-add-spi-uart-driver-for-maxim-3110-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
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
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

