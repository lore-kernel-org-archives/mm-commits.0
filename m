From: akpm@linux-foundation.org
Subject: + git-dvb-fixup.patch added to -mm tree
Date: Mon, 05 Nov 2007 21:49:50 -0800
Message-ID: <200711060549.lA65noFG006844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbXKFFue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     git-dvb-fixup
has been added to the -mm tree.  Its filename is
     git-dvb-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
revert-gregkh-driver-block-device.patch
git-dvb-fixup.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-handle-broken-cable-reporting-checkpatch-fixes.patch
ide-arm-hack.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int-checkpatch-fixes.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-make-i8259_64-more-_32-like-checkpatch-fixes.patch
git-perfmon-fixup.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
remove-__attribute_used__-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
