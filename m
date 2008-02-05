From: akpm@linux-foundation.org
Subject: - git-dvb-fixup.patch removed from -mm tree
Date: Mon, 04 Feb 2008 23:37:32 -0800
Message-ID: <200802050737.m157bEoa009979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbYBEHh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 02:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     git-dvb-fixup
has been removed from the -mm tree.  Its filename was
     git-dvb-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-dvb-fixup
From: Andrew Morton <akpm@linux-foundation.org>

fix git conflicts.  Probably wrong.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/video4linux/CARDLIST.em28xx |    7 
 drivers/media/dvb/ttpci/Kconfig           |    3 
 drivers/media/video/bt8xx/bttv-driver.c   |  338 --------------------
 3 files changed, 348 deletions(-)

diff -puN Documentation/video4linux/CARDLIST.em28xx~git-dvb-fixup Documentation/video4linux/CARDLIST.em28xx
--- a/Documentation/video4linux/CARDLIST.em28xx~git-dvb-fixup
+++ a/Documentation/video4linux/CARDLIST.em28xx
@@ -8,16 +8,9 @@
   7 -> Leadtek Winfast USB II                   (em2800)
   8 -> Kworld USB2800                           (em2800)
   9 -> Pinnacle Dazzle DVC 90                   (em2820/em2840) [2304:0207]
-<<<<<<< HEAD:Documentation/video4linux/CARDLIST.em28xx
- 10 -> Hauppauge WinTV HVR 900                  (em2880)
-=======
  10 -> Hauppauge WinTV HVR 900/950              (em2880)
->>>>>>> FETCH_HEAD:Documentation/video4linux/CARDLIST.em28xx
  11 -> Terratec Hybrid XS                       (em2880)
  12 -> Kworld PVR TV 2800 RF                    (em2820/em2840)
  13 -> Terratec Prodigy XS                      (em2880)
-<<<<<<< HEAD:Documentation/video4linux/CARDLIST.em28xx
-=======
  14 -> Pixelview Prolink PlayTV USB 2.0         (em2820/em2840)
  15 -> V-Gear PocketTV                          (em2800)
->>>>>>> FETCH_HEAD:Documentation/video4linux/CARDLIST.em28xx
diff -puN drivers/media/dvb/ttpci/Kconfig~git-dvb-fixup drivers/media/dvb/ttpci/Kconfig
--- a/drivers/media/dvb/ttpci/Kconfig~git-dvb-fixup
+++ a/drivers/media/dvb/ttpci/Kconfig
@@ -99,12 +99,9 @@ config DVB_BUDGET
 
 config DVB_BUDGET_CI
 	tristate "Budget cards with onboard CI connector"
-<<<<<<< HEAD:drivers/media/dvb/ttpci/Kconfig
 	depends on DVB_CORE && PCI && I2C && VIDEO_V4L1 && INPUT
 	select VIDEO_SAA7146
-=======
 	depends on DVB_BUDGET_CORE && I2C
->>>>>>> FETCH_HEAD:drivers/media/dvb/ttpci/Kconfig
 	select DVB_STV0297 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
diff -puN drivers/media/video/bt8xx/bttv-driver.c~git-dvb-fixup drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~git-dvb-fixup
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -2537,241 +2537,7 @@ static int bttv_do_ioctl(struct inode *i
 	};
 
 	switch (cmd) {
-<<<<<<< HEAD:drivers/media/video/bt8xx/bttv-driver.c
-
-	/* ***  v4l1  *** ************************************************ */
-	case VIDIOCGCAP:
-	{
-		struct video_capability *cap = arg;
-
-		memset(cap,0,sizeof(*cap));
-		strcpy(cap->name,btv->video_dev->name);
-		if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
-			/* vbi */
-			cap->type = VID_TYPE_TUNER|VID_TYPE_TELETEXT;
-		} else {
-			/* others */
-			cap->type = VID_TYPE_CAPTURE|
-				VID_TYPE_TUNER|
-				VID_TYPE_CLIPPING|
-				VID_TYPE_SCALES;
-			if (no_overlay <= 0)
-				cap->type |= VID_TYPE_OVERLAY;
-
-			cap->maxwidth  = bttv_tvnorms[btv->tvnorm].swidth;
-			cap->maxheight = bttv_tvnorms[btv->tvnorm].sheight;
-			cap->minwidth  = 48;
-			cap->minheight = 32;
-		}
-		cap->channels  = bttv_tvcards[btv->c.type].video_inputs;
-		cap->audios    = bttv_tvcards[btv->c.type].audio_inputs;
-		return 0;
-	}
-
-	case VIDIOCGPICT:
-	{
-		struct video_picture *pic = arg;
-
-		memset(pic,0,sizeof(*pic));
-		pic->brightness = btv->bright;
-		pic->contrast   = btv->contrast;
-		pic->hue        = btv->hue;
-		pic->colour     = btv->saturation;
-		if (fh->fmt) {
-			pic->depth   = fh->fmt->depth;
-			pic->palette = fh->fmt->palette;
-		}
-		return 0;
-	}
-	case VIDIOCSPICT:
-	{
-		struct video_picture *pic = arg;
-		const struct bttv_format *fmt;
-
-		fmt = format_by_palette(pic->palette);
-		if (NULL == fmt)
-			return -EINVAL;
-		mutex_lock(&fh->cap.lock);
-		if (fmt->flags & FORMAT_FLAGS_RAW) {
-			/* VIDIOCMCAPTURE uses gbufsize, not RAW_BPL *
-			   RAW_LINES * 2. F1 is stored at offset 0, F2
-			   at buffer size / 2. */
-			fh->width = RAW_BPL;
-			fh->height = gbufsize / RAW_BPL;
-			btv->init.width  = RAW_BPL;
-			btv->init.height = gbufsize / RAW_BPL;
-		}
-		fh->ovfmt   = fmt;
-		fh->fmt     = fmt;
-		btv->init.ovfmt   = fmt;
-		btv->init.fmt     = fmt;
-		if (bigendian) {
-			/* dirty hack time:  swap bytes for overlay if the
-			   display adaptor is big endian (insmod option) */
-			if (fmt->palette == VIDEO_PALETTE_RGB555 ||
-			    fmt->palette == VIDEO_PALETTE_RGB565 ||
-			    fmt->palette == VIDEO_PALETTE_RGB32) {
-				fh->ovfmt = fmt+1;
-			}
-		}
-		bt848_bright(btv,pic->brightness);
-		bt848_contrast(btv,pic->contrast);
-		bt848_hue(btv,pic->hue);
-		bt848_sat(btv,pic->colour);
-		mutex_unlock(&fh->cap.lock);
-		return 0;
-	}
-
-	case VIDIOCGWIN:
-	{
-		struct video_window *win = arg;
-
-		memset(win,0,sizeof(*win));
-		win->x      = fh->ov.w.left;
-		win->y      = fh->ov.w.top;
-		win->width  = fh->ov.w.width;
-		win->height = fh->ov.w.height;
-		return 0;
-	}
-	case VIDIOCSWIN:
-	{
-		struct video_window *win = arg;
-		struct v4l2_window w2;
-
-		if (no_overlay > 0) {
-			printk ("VIDIOCSWIN: no_overlay\n");
-			return -EINVAL;
-		}
-
-		w2.field = V4L2_FIELD_ANY;
-		w2.w.left    = win->x;
-		w2.w.top     = win->y;
-		w2.w.width   = win->width;
-		w2.w.height  = win->height;
-		w2.clipcount = win->clipcount;
-		w2.clips     = (struct v4l2_clip __user *)win->clips;
-		retval = setup_window(fh, btv, &w2, 0);
-		if (0 == retval) {
-			/* on v4l1 this ioctl affects the read() size too */
-			fh->width  = fh->ov.w.width;
-			fh->height = fh->ov.w.height;
-			btv->init.width  = fh->ov.w.width;
-			btv->init.height = fh->ov.w.height;
-		}
-		return retval;
-	}
-
-	case VIDIOCGFBUF:
-	{
-		struct video_buffer *fbuf = arg;
-
-		fbuf->base          = btv->fbuf.base;
-		fbuf->width         = btv->fbuf.fmt.width;
-		fbuf->height        = btv->fbuf.fmt.height;
-		fbuf->bytesperline  = btv->fbuf.fmt.bytesperline;
-		if (fh->ovfmt)
-			fbuf->depth = fh->ovfmt->depth;
-		else {
-			if (fbuf->width)
-				fbuf->depth   = ((fbuf->bytesperline<<3)
-						  + (fbuf->width-1) )
-						  /fbuf->width;
-			else
-				fbuf->depth = 0;
-		}
-		return 0;
-	}
-	case VIDIOCSFBUF:
-	{
-		struct video_buffer *fbuf = arg;
-		const struct bttv_format *fmt;
-		unsigned long end;
-
-		if(!capable(CAP_SYS_ADMIN) &&
-		   !capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		end = (unsigned long)fbuf->base +
-			fbuf->height * fbuf->bytesperline;
-		mutex_lock(&fh->cap.lock);
-		retval = -EINVAL;
-
-		switch (fbuf->depth) {
-		case 8:
-			fmt = format_by_palette(VIDEO_PALETTE_HI240);
-			break;
-		case 16:
-			fmt = format_by_palette(VIDEO_PALETTE_RGB565);
-			break;
-		case 24:
-			fmt = format_by_palette(VIDEO_PALETTE_RGB24);
-			break;
-		case 32:
-			fmt = format_by_palette(VIDEO_PALETTE_RGB32);
-			break;
-		case 15:
-			fbuf->depth = 16;
-			fmt = format_by_palette(VIDEO_PALETTE_RGB555);
-			break;
-		default:
-			fmt = NULL;
-			break;
-		}
-		if (NULL == fmt)
-			goto fh_unlock_and_return;
-
-		fh->ovfmt = fmt;
-		fh->fmt   = fmt;
-		btv->init.ovfmt = fmt;
-		btv->init.fmt   = fmt;
-		btv->fbuf.base             = fbuf->base;
-		btv->fbuf.fmt.width        = fbuf->width;
-		btv->fbuf.fmt.height       = fbuf->height;
-		if (fbuf->bytesperline)
-			btv->fbuf.fmt.bytesperline = fbuf->bytesperline;
-		else
-			btv->fbuf.fmt.bytesperline = btv->fbuf.fmt.width*fbuf->depth/8;
-		mutex_unlock(&fh->cap.lock);
-		return 0;
-	}
-
-	case VIDIOCCAPTURE:
-	case VIDIOC_OVERLAY:
-	{
-		struct bttv_buffer *new;
-		int *on = arg;
-
-		if (*on) {
-			/* verify args */
-			if (NULL == btv->fbuf.base)
-				return -EINVAL;
-			if (!fh->ov.setup_ok) {
-				dprintk("bttv%d: overlay: !setup_ok\n",btv->c.nr);
-				return -EINVAL;
-			}
-		}
-
-		if (!check_alloc_btres(btv,fh,RESOURCE_OVERLAY))
-			return -EBUSY;
-
-		mutex_lock(&fh->cap.lock);
-		if (*on) {
-			fh->ov.tvnorm = btv->tvnorm;
-			new = videobuf_pci_alloc(sizeof(*new));
-			new->crop = btv->crop[!!fh->do_crop].rect;
-			bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
-		} else {
-			new = NULL;
-		}
-
-		/* switch over */
-		retval = bttv_switch_overlay(btv,fh,new);
-		mutex_unlock(&fh->cap.lock);
-		return retval;
-	}
-
-=======
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
->>>>>>> FETCH_HEAD:drivers/media/video/bt8xx/bttv-driver.c
 	case VIDIOCGMBUF:
 	{
 		struct video_mbuf *mbuf = arg;
@@ -2792,111 +2558,7 @@ static int bttv_do_ioctl(struct inode *i
 		mutex_unlock(&fh->cap.lock);
 		return 0;
 	}
-<<<<<<< HEAD:drivers/media/video/bt8xx/bttv-driver.c
-	case VIDIOCMCAPTURE:
-	{
-		struct video_mmap *vm = arg;
-		struct bttv_buffer *buf;
-		enum v4l2_field field;
-		__s32 height2;
-		int res;
-
-		if (vm->frame >= VIDEO_MAX_FRAME)
-			return -EINVAL;
-
-		res = bttv_resource(fh);
-		if (!check_alloc_btres(btv, fh, res))
-			return -EBUSY;
-
-		mutex_lock(&fh->cap.lock);
-		retval = -EINVAL;
-		buf = (struct bttv_buffer *)fh->cap.bufs[vm->frame];
-		if (NULL == buf)
-			goto fh_unlock_and_return;
-		if (0 == buf->vb.baddr)
-			goto fh_unlock_and_return;
-		if (buf->vb.state == STATE_QUEUED ||
-		    buf->vb.state == STATE_ACTIVE)
-			goto fh_unlock_and_return;
-
-		height2 = btv->crop[!!fh->do_crop].rect.height >> 1;
-		field = (vm->height > height2)
-			? V4L2_FIELD_INTERLACED
-			: V4L2_FIELD_BOTTOM;
-		retval = bttv_prepare_buffer(&fh->cap,btv,buf,
-					     format_by_palette(vm->format),
-					     vm->width,vm->height,field);
-		if (0 != retval)
-			goto fh_unlock_and_return;
-		btv->init.width = vm->width;
-		btv->init.height = vm->height;
-		spin_lock_irqsave(&btv->s_lock,flags);
-		buffer_queue(&fh->cap,&buf->vb);
-		spin_unlock_irqrestore(&btv->s_lock,flags);
-		mutex_unlock(&fh->cap.lock);
-		return 0;
-	}
-	case VIDIOCSYNC:
-	{
-		int *frame = arg;
-		struct bttv_buffer *buf;
-
-		if (*frame >= VIDEO_MAX_FRAME)
-			return -EINVAL;
-
-		mutex_lock(&fh->cap.lock);
-		retval = -EINVAL;
-		buf = (struct bttv_buffer *)fh->cap.bufs[*frame];
-		if (NULL == buf)
-			goto fh_unlock_and_return;
-		retval = videobuf_waiton(&buf->vb,0,1);
-		if (0 != retval)
-			goto fh_unlock_and_return;
-		switch (buf->vb.state) {
-		case STATE_ERROR:
-			retval = -EIO;
-			/* fall through */
-		case STATE_DONE:
-		{
-			struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
-			videobuf_dma_sync(&fh->cap,dma);
-			bttv_dma_free(&fh->cap,btv,buf);
-			break;
-		}
-		default:
-			retval = -EINVAL;
-			break;
-		}
-		mutex_unlock(&fh->cap.lock);
-		return retval;
-	}
-
-	case VIDIOCGVBIFMT:
-		if (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE) {
-			retval = bttv_switch_type(fh,V4L2_BUF_TYPE_VBI_CAPTURE);
-			if (0 != retval)
-				return retval;
-		}
-
-		/* fall through */
-
-	case VIDIOCSVBIFMT:
-		return v4l_compat_translate_ioctl(inode, file, cmd,
-						  arg, bttv_do_ioctl);
-
-	case BTTV_VERSION:
-	case VIDIOCGFREQ:
-	case VIDIOCSFREQ:
-	case VIDIOCGTUNER:
-	case VIDIOCSTUNER:
-	case VIDIOCGCHAN:
-	case VIDIOCSCHAN:
-	case VIDIOCGAUDIO:
-	case VIDIOCSAUDIO:
-		return bttv_common_ioctls(btv,cmd,arg);
-=======
 #endif
->>>>>>> FETCH_HEAD:drivers/media/video/bt8xx/bttv-driver.c
 
 	/* ***  v4l2  *** ************************************************ */
 	case VIDIOC_QUERYCAP:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kvm-i386-fix.patch
drivers-net-wireless-b43-mainc-needs-ioh.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
timerfd-v3-new-timerfd-api.patch
include-asm-powerpc-nvramh-needs-listh.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
bufferhead-revert-constructor-removal.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
maps4-rework-task_size-macros.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
page-allocator-clean-up-pcp-draining-functions.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-remove-fastcall-from-mm.patch
page-migraton-handle-orphaned-pages.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
dio-array_size-cleanup.patch
uml-get-rid-of-asmlinkage.patch
uml-improve-detection-of-host-cmov.patch
uml-further-bugsc-tidying.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume.patch
git-agpgart.patch
git-agpgart-fix.patch
git-audit-printk-warning-fix.patch
cifs-fix-warning.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
revert-git-hrt.patch
git-ia64.patch
i8042-non-x86-build-fix.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
git-netdev-all-fix-conflicts-fix.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
bluetooth-uninlining.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-v9fs-fix-git-conflicts.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
b43-fix-build-with-config_ssb_pcihost=n.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
x86-amd-thermal-interrupt-support-fix-2.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
md-change-interate_mddev-to-for_each_mddev-fix.patch
md-change-iterate_rdev-to-rdev_for_each-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
