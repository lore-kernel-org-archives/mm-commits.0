From: akpm@linux-foundation.org
Subject: - git-alsa-fix-git-conflicts.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:38:42 -0700
Message-ID: <200803111838.m2BIcggo021263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYCKSj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-alsa-fix-git-conflicts
has been removed from the -mm tree.  Its filename was
     git-alsa-fix-git-conflicts.patch

This patch was dropped because it is obsolete

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
@@ -1837,17 +1837,6 @@ static int __devinit azx_create(struct s
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
@@ -1858,7 +1847,6 @@ static int __devinit azx_create(struct s
 	chip->capture_streams = (gcap >> 8) & 0x0f;
 	chip->playback_streams = (gcap >> 12) & 0x0f;
 	if (!chip->playback_streams && !chip->capture_streams) {
->>>>>>> FETCH_HEAD:sound/pci/hda/hda_intel.c
 		/* gcap didn't give any info, switching to old method */
 
 		switch (chip->driver_type) {
diff -puN sound/pci/hda/patch_realtek.c~git-alsa-fix-git-conflicts sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~git-alsa-fix-git-conflicts
+++ a/sound/pci/hda/patch_realtek.c
@@ -5256,13 +5256,9 @@ static int alc882_mux_enum_put(struct sn
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
 
@@ -6509,38 +6505,8 @@ static struct hda_input_mux alc883_fujit
 
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
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-alsa-fix-git-conflicts.patch
git-arm-master.patch
cifs-hack-around-biuld-error.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
git-net.patch
git-net-fix-build-with-config_net=n.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
revert-acpi-thermal-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

