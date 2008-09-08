From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 08 Sep 2008 12:00:13 -0700
Message-ID: <200809081900.m88J0Dbv005249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557AbYIHTAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:00:47 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m88J0DU6003805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 8 Sep 2008 12:00:14 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     introduce-generic-header-file-for-the-software-io-tlb-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce-generic-header-file-for-the-software-io-tlb-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/dsbr100.c         |    4 ---
 drivers/media/video/Makefile          |    5 ----
 drivers/media/video/cx18/cx18-queue.c |   12 ---------
 drivers/media/video/gspca/sonixb.c    |    6 ----
 drivers/media/video/gspca/spca561.c   |   23 ------------------
 include/asm-x86/cpufeature.h          |    3 --
 net/mac80211/mlme.c                   |   30 ------------------------
 7 files changed, 1 insertion(+), 82 deletions(-)

diff -puN drivers/media/radio/dsbr100.c~linux-next-git-rejects drivers/media/radio/dsbr100.c
--- a/drivers/media/radio/dsbr100.c~linux-next-git-rejects
+++ a/drivers/media/radio/dsbr100.c
@@ -500,11 +500,7 @@ static int usb_dsbr100_probe(struct usb_
 	radio->curfreq = FREQ_MIN*FREQ_MUL;
 	video_set_drvdata(radio->videodev, radio);
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr) < 0) {
-<<<<<<< HEAD:drivers/media/radio/dsbr100.c
-		warn("Could not register video device");
-=======
 		dev_warn(&intf->dev, "Could not register video device\n");
->>>>>>> FETCH_HEAD:drivers/media/radio/dsbr100.c
 		video_device_release(radio->videodev);
 		kfree(radio->transfer_buffer);
 		kfree(radio);
diff -puN drivers/media/video/Makefile~linux-next-git-rejects drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~linux-next-git-rejects
+++ a/drivers/media/video/Makefile
@@ -84,11 +84,6 @@ obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
 obj-$(CONFIG_VIDEO_MXB) += mxb.o
 obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
-<<<<<<< HEAD:drivers/media/video/Makefile
-obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
-obj-$(CONFIG_TUNER_3036) += tuner-3036.o
-=======
->>>>>>> FETCH_HEAD:drivers/media/video/Makefile
 
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
diff -puN drivers/media/video/cx18/cx18-queue.c~linux-next-git-rejects drivers/media/video/cx18/cx18-queue.c
--- a/drivers/media/video/cx18/cx18-queue.c~linux-next-git-rejects
+++ a/drivers/media/video/cx18/cx18-queue.c
@@ -92,15 +92,8 @@ struct cx18_buffer *cx18_queue_get_buf_i
 		/* the transport buffers are handled differently,
 		   they are not moved to the full queue */
 		if (s->type != CX18_ENC_STREAM_TYPE_TS) {
-<<<<<<< HEAD:drivers/media/video/cx18/cx18-queue.c
-			s->q_free.buffers--;
-			s->q_free.length -= s->buf_size;
-			s->q_full.buffers++;
-			s->q_full.length += s->buf_size;
-=======
 			atomic_dec(&s->q_free.buffers);
 			atomic_inc(&s->q_full.buffers);
->>>>>>> FETCH_HEAD:drivers/media/video/cx18/cx18-queue.c
 			s->q_full.bytesused += buf->bytesused;
 			list_move_tail(&buf->list, &s->q_full.list);
 		}
@@ -126,12 +119,7 @@ static void cx18_queue_flush(struct cx18
 		buf = list_entry(q->list.next, struct cx18_buffer, list);
 		list_move_tail(q->list.next, &s->q_free.list);
 		buf->bytesused = buf->readpos = buf->b_flags = 0;
-<<<<<<< HEAD:drivers/media/video/cx18/cx18-queue.c
-		s->q_free.buffers++;
-		s->q_free.length += s->buf_size;
-=======
 		atomic_inc(&s->q_free.buffers);
->>>>>>> FETCH_HEAD:drivers/media/video/cx18/cx18-queue.c
 	}
 	cx18_queue_init(q);
 	spin_unlock_irqrestore(&s->qlock, flags);
diff -puN drivers/media/video/gspca/sonixb.c~linux-next-git-rejects drivers/media/video/gspca/sonixb.c
--- a/drivers/media/video/gspca/sonixb.c~linux-next-git-rejects
+++ a/drivers/media/video/gspca/sonixb.c
@@ -231,14 +231,11 @@ static struct ctrl sd_ctrls[] = {
 
 static struct v4l2_pix_format vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-<<<<<<< HEAD:drivers/media/video/gspca/sonixb.c
 		.bytesperline = 160,
 		.sizeimage = 160 * 120 * 5 / 4,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 2 | MODE_RAW},
 	{160, 120, V4L2_PIX_FMT_SN9C10X, V4L2_FIELD_NONE,
-=======
->>>>>>> FETCH_HEAD:drivers/media/video/gspca/sonixb.c
 		.bytesperline = 160,
 		.sizeimage = 160 * 120 * 5 / 4,
 		.colorspace = V4L2_COLORSPACE_SRGB,
@@ -271,14 +268,11 @@ static struct v4l2_pix_format sif_mode[]
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 1 | MODE_REDUCED_SIF},
 	{176, 144, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-<<<<<<< HEAD:drivers/media/video/gspca/sonixb.c
 		.bytesperline = 176,
 		.sizeimage = 176 * 144 * 5 / 4,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 1 | MODE_RAW},
 	{176, 144, V4L2_PIX_FMT_SN9C10X, V4L2_FIELD_NONE,
-=======
->>>>>>> FETCH_HEAD:drivers/media/video/gspca/sonixb.c
 		.bytesperline = 176,
 		.sizeimage = 176 * 144 * 5 / 4,
 		.colorspace = V4L2_COLORSPACE_SRGB,
diff -puN drivers/media/video/gspca/spca561.c~linux-next-git-rejects drivers/media/video/gspca/spca561.c
--- a/drivers/media/video/gspca/spca561.c~linux-next-git-rejects
+++ a/drivers/media/video/gspca/spca561.c
@@ -223,11 +223,7 @@ static int i2c_read(struct gspca_dev *gs
 	reg_w_val(gspca_dev->dev, 0x8804, 0x92);
 	reg_w_val(gspca_dev->dev, 0x8801, reg);
 	reg_w_val(gspca_dev->dev, 0x8802, (mode | 0x01));
-<<<<<<< HEAD:drivers/media/video/gspca/spca561.c
 	do {
-=======
-	while (retry--) {
->>>>>>> FETCH_HEAD:drivers/media/video/gspca/spca561.c
 		reg_r(gspca_dev, 0x8803, 1);
 		if (!gspca_dev->usb_buf)
 			break;
@@ -680,7 +676,6 @@ static void setexposure(struct gspca_dev
 	data[0] = expo;
 	data[1] = expo >> 8;
 	reg_w_buf(gspca_dev, 0x8309, data, 2);
-<<<<<<< HEAD:drivers/media/video/gspca/spca561.c
 }
 
 /* rev 12a only */
@@ -697,24 +692,6 @@ static void setgain(struct gspca_dev *gs
 static void setautogain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-=======
-}
-
-/* rev 12a only */
-static void setgain(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-	__u8 data[2];
-
-	data[0] = sd->gain;
-	data[1] = 0;
-	reg_w_buf(gspca_dev, 0x8335, data, 2);
-}
-
-static void setautogain(struct gspca_dev *gspca_dev)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
->>>>>>> FETCH_HEAD:drivers/media/video/gspca/spca561.c
 
 	if (sd->autogain)
 		sd->ag_cnt = AG_CNT_START;
diff -puN include/asm-x86/cpufeature.h~linux-next-git-rejects include/asm-x86/cpufeature.h
--- a/include/asm-x86/cpufeature.h~linux-next-git-rejects
+++ a/include/asm-x86/cpufeature.h
@@ -81,10 +81,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-<<<<<<< HEAD:include/asm-x86/cpufeature.h
-=======
 #define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
->>>>>>> FETCH_HEAD:include/asm-x86/cpufeature.h
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff -puN net/mac80211/mlme.c~linux-next-git-rejects net/mac80211/mlme.c
--- a/net/mac80211/mlme.c~linux-next-git-rejects
+++ a/net/mac80211/mlme.c
@@ -502,7 +502,6 @@ static void ieee80211_sta_send_associnfo
 {
 	char *buf;
 	size_t len;
-	int i;
 	union iwreq_data wrqu;
 
 	if (!ifsta->assocreq_ies && !ifsta->assocresp_ies)
@@ -515,48 +514,21 @@ static void ieee80211_sta_send_associnfo
 
 	len = sprintf(buf, "ASSOCINFO(");
 	if (ifsta->assocreq_ies) {
-<<<<<<< HEAD:net/mac80211/mlme.c
-		len += sprintf(buf + len, "ReqIEs=");
-		for (i = 0; i < ifsta->assocreq_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocreq_ies[i]);
-		}
-=======
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = ifsta->assocreq_ies_len;
 		wireless_send_event(sdata->dev, IWEVASSOCREQIE, &wrqu,
 				    ifsta->assocreq_ies);
->>>>>>> FETCH_HEAD:net/mac80211/mlme.c
 	}
 	if (ifsta->assocresp_ies) {
-<<<<<<< HEAD:net/mac80211/mlme.c
-		if (ifsta->assocreq_ies)
-			len += sprintf(buf + len, " ");
-		len += sprintf(buf + len, "RespIEs=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
-		}
-	}
-	len += sprintf(buf + len, ")");
-
-	if (len > IW_CUSTOM_MAX) {
-		len = sprintf(buf, "ASSOCRESPIE=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
-		}
-=======
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = ifsta->assocresp_ies_len;
 		wireless_send_event(sdata->dev, IWEVASSOCRESPIE, &wrqu,
 				    ifsta->assocresp_ies);
->>>>>>> FETCH_HEAD:net/mac80211/mlme.c
 	}
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.data.length = len;
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+	wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
 
 	kfree(buf);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
security-selinux-include-netlabelh-fix-two-build-errors.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
revert-acpi-ec-do-transaction-from-interrupt-context.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
git-alsa-tiwai.patch
git-powerpc.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
git-drm.patch
git-dlm.patch
fs-dlm-configc-choose-better-identifiers.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
git-mtd.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
git-battery.patch
git-pci-next.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
arch-s390-kernel-ptracec-fix-build.patch
sched-clarify-ifdef-tangle.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-usb-musb-disable-it-on-superh.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
drivers-net-mlx4-allocc-needs-mmh.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
make-taint-bit-reliable-v3-fix.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

