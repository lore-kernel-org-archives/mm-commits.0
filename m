From: akpm@linux-foundation.org
Subject: + git-alsa-fix-git-conflicts.patch added to -mm tree
Date: Fri, 29 Feb 2008 16:37:07 -0800
Message-ID: <200803010037.m210b7og028644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbYCAAhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:37:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, perex@perex.cz, tiwai@suse.de


The patch titled
     git-alsa-fix-git-conflicts
has been added to the -mm tree.  Its filename is
     git-alsa-fix-git-conflicts.patch

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
Subject: git-alsa-fix-git-conflicts
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c      |   12 ----------
 sound/pci/hda/patch_realtek.c  |   34 -------------------------------
 sound/soc/codecs/tlv320aic3x.c |    3 --
 3 files changed, 49 deletions(-)

diff -puN sound/pci/hda/hda_intel.c~git-alsa-fix-git-conflicts sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~git-alsa-fix-git-conflicts
+++ a/sound/pci/hda/hda_intel.c
@@ -1836,17 +1836,6 @@ static int __devinit azx_create(struct s
 	gcap = azx_readw(chip, GCAP);
 	snd_printdd("chipset global capabilities = 0x%x\n", gcap);
 
-<<<<<<< HEAD:sound/pci/hda/hda_intel.c
-	if (gcap) {
-		/* read number of streams from GCAP register instead of using
-		 * hardcoded value
-		 */
-		chip->playback_streams = (gcap & (0xF << 12)) >> 12;
-		chip->capture_streams = (gcap & (0xF << 8)) >> 8;
-		chip->playback_index_offset = chip->capture_streams;
-		chip->capture_index_offset = 0;
-	} else {
-=======
 	/* allow 64bit DMA address if supported by H/W */
 	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_64BIT_MASK))
 		pci_set_consistent_dma_mask(pci, DMA_64BIT_MASK);
@@ -1857,7 +1846,6 @@ static int __devinit azx_create(struct s
 	chip->capture_streams = (gcap >> 8) & 0x0f;
 	chip->playback_streams = (gcap >> 12) & 0x0f;
 	if (!chip->playback_streams && !chip->capture_streams) {
->>>>>>> FETCH_HEAD:sound/pci/hda/hda_intel.c
 		/* gcap didn't give any info, switching to old method */
 
 		switch (chip->driver_type) {
diff -puN sound/pci/hda/patch_realtek.c~git-alsa-fix-git-conflicts sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~git-alsa-fix-git-conflicts
+++ a/sound/pci/hda/patch_realtek.c
@@ -5254,13 +5254,9 @@ static int alc882_mux_enum_put(struct sn
 	struct alc_spec *spec = codec->spec;
 	const struct hda_input_mux *imux = spec->input_mux;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
-<<<<<<< HEAD:sound/pci/hda/patch_realtek.c
 	static hda_nid_t capture_mixers[3] = { 0x24, 0x23, 0x22 };
-	hda_nid_t nid;
-=======
 	hda_nid_t nid = spec->capsrc_nids ?
 		spec->capsrc_nids[adc_idx] : spec->adc_nids[adc_idx];
->>>>>>> FETCH_HEAD:sound/pci/hda/patch_realtek.c
 	unsigned int *cur_val = &spec->cur_mux[adc_idx];
 	unsigned int i, idx;
 
@@ -6494,38 +6490,8 @@ static struct hda_input_mux alc883_lenov
 
 #define alc883_mux_enum_info alc_mux_enum_info
 #define alc883_mux_enum_get alc_mux_enum_get
-<<<<<<< HEAD:sound/pci/hda/patch_realtek.c
-
-static int alc883_mux_enum_put(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *ucontrol)
-{
-	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct alc_spec *spec = codec->spec;
-	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
-	static hda_nid_t capture_mixers[2] = { 0x23, 0x22 };
-	hda_nid_t nid = capture_mixers[adc_idx];
-	unsigned int *cur_val = &spec->cur_mux[adc_idx];
-	unsigned int i, idx;
-
-	idx = ucontrol->value.enumerated.item[0];
-	if (idx >= imux->num_items)
-		idx = imux->num_items - 1;
-	if (*cur_val == idx)
-		return 0;
-	for (i = 0; i < imux->num_items; i++) {
-		unsigned int v = (i == idx) ? 0 : HDA_AMP_MUTE;
-		snd_hda_codec_amp_stereo(codec, nid, HDA_INPUT,
-					 imux->items[i].index,
-					 HDA_AMP_MUTE, v);
-	}
-	*cur_val = idx;
-	return 1;
-}
-=======
 /* ALC883 has the ALC882-type input selection */
 #define alc883_mux_enum_put alc882_mux_enum_put
->>>>>>> FETCH_HEAD:sound/pci/hda/patch_realtek.c
 
 /*
  * 2ch mode
diff -puN sound/soc/codecs/tlv320aic3x.c~git-alsa-fix-git-conflicts sound/soc/codecs/tlv320aic3x.c
--- a/sound/soc/codecs/tlv320aic3x.c~git-alsa-fix-git-conflicts
+++ a/sound/soc/codecs/tlv320aic3x.c
@@ -688,10 +688,7 @@ static const struct aic3x_rate_divs aic3
 	{22579200, 48000, 48000, 0x0, 8, 7075},
 	{33868800, 48000, 48000, 0x0, 5, 8049},
 	/* 64k */
-<<<<<<< HEAD:sound/soc/codecs/tlv320aic3x.c
-=======
 	{12000000, 64000, 96000, 0x1, 16, 3840},
->>>>>>> FETCH_HEAD:sound/soc/codecs/tlv320aic3x.c
 	{22579200, 64000, 96000, 0x1, 8, 7075},
 	{33868800, 64000, 96000, 0x1, 5, 8049},
 	/* 88.2k */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
zlc_setup-handle-jiffies-wraparound-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-ocfs2-dlm-dlmdomainc-fix-printk-warning.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
git-v9fs.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
use-page_cache_xxx-in-ext2-fix.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

