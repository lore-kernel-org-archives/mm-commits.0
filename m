From: akpm@osdl.org
Subject: + git-alsa-fixups.patch added to -mm tree
Date: Thu, 21 Dec 2006 12:02:01 -0800
Message-ID: <200612212002.kBLK21W4003330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423068AbWLUUCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, perex@suse.cz, tiwai@suse.de


The patch titled
     git-alsa-fixups
has been added to the -mm tree.  Its filename is
     git-alsa-fixups.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-alsa-fixups
From: Andrew Morton <akpm@osdl.org>

Attempt to fix git conflicts due to git-alsa

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/pci/ac97/ac97_patch.c   |    6 --
 sound/pci/hda/patch_analog.c  |   46 ------------------
 sound/pci/hda/patch_realtek.c |   23 ---------
 sound/pci/via82xx.c           |   81 --------------------------------
 4 files changed, 156 deletions(-)

diff -puN sound/pci/ac97/ac97_patch.c~git-alsa-fixups sound/pci/ac97/ac97_patch.c
--- a/sound/pci/ac97/ac97_patch.c~git-alsa-fixups
+++ a/sound/pci/ac97/ac97_patch.c
@@ -2361,14 +2361,8 @@ int patch_alc655(struct snd_ac97 * ac97)
 	else { /* ALC655 */
 		if (ac97->subsystem_vendor == 0x1462 &&
 		    (ac97->subsystem_device == 0x0131 || /* MSI S270 laptop */
-<<<<<<< HEAD/sound/pci/ac97/ac97_patch.c
 		     ac97->subsystem_device == 0x0161 || /* LG K1 Express */
 		     ac97->subsystem_device == 0x0351))  /* MSI L725 laptop */
-=======
-		     ac97->subsystem_device == 0x0161 || /* LG K1 Express */
-		     ac97->subsystem_device == 0x0351 || /* MSI L725 laptop */
-		     ac97->subsystem_device == 0x0061))  /* MSI S250 laptop */
->>>>>>> /sound/pci/ac97/ac97_patch.c
 			val &= ~(1 << 1); /* Pin 47 is EAPD (for internal speaker) */
 		else
 			val |= (1 << 1); /* Pin 47 is spdif input pin */
diff -puN sound/pci/hda/patch_analog.c~git-alsa-fixups sound/pci/hda/patch_analog.c
--- a/sound/pci/hda/patch_analog.c~git-alsa-fixups
+++ a/sound/pci/hda/patch_analog.c
@@ -787,51 +787,6 @@ static struct hda_verb ad1986a_eapd_init
 };
 
 /* models */
-<<<<<<< HEAD/sound/pci/hda/patch_analog.c
-enum { AD1986A_6STACK, AD1986A_3STACK, AD1986A_LAPTOP, AD1986A_LAPTOP_EAPD };
-
-static struct hda_board_config ad1986a_cfg_tbl[] = {
-	{ .modelname = "6stack",	.config = AD1986A_6STACK },
-	{ .modelname = "3stack",	.config = AD1986A_3STACK },
-	{ .pci_subvendor = 0x10de, .pci_subdevice = 0xcb84,
-	  .config = AD1986A_3STACK }, /* ASUS A8N-VM CSM */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x817f,
-	  .config = AD1986A_3STACK }, /* ASUS P5P-L2 */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x81b3,
-	  .config = AD1986A_3STACK }, /* ASUS P5RD2-VM / P5GPL-X SE */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x81cb,
-	  .config = AD1986A_3STACK }, /* ASUS M2NPV-VM */
-	{ .modelname = "laptop",	.config = AD1986A_LAPTOP },
-	{ .pci_subvendor = 0x144d, .pci_subdevice = 0xc01e,
-	  .config = AD1986A_LAPTOP }, /* FSC V2060 */
-	{ .pci_subvendor = 0x17c0, .pci_subdevice = 0x2017,
-	  .config = AD1986A_LAPTOP }, /* Samsung M50 */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x818f,
-	  .config = AD1986A_LAPTOP }, /* ASUS P5GV-MX */
-	{ .modelname = "laptop-eapd",	.config = AD1986A_LAPTOP_EAPD },
-	{ .pci_subvendor = 0x144d, .pci_subdevice = 0xc023,
-	  .config = AD1986A_LAPTOP_EAPD }, /* Samsung X60 Chane */
-	{ .pci_subvendor = 0x144d, .pci_subdevice = 0xc024,
-	  .config = AD1986A_LAPTOP_EAPD }, /* Samsung R65-T2300 Charis */
-	{ .pci_subvendor = 0x144d, .pci_subdevice = 0xc026,
-	  .config = AD1986A_LAPTOP_EAPD }, /* Samsung X11-T2300 Culesa */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x1153,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS M9 */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x1213,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS A6J */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x11f7,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS U5A */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x1263,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS U5F */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x1297,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS Z62F */
-	{ .pci_subvendor = 0x1043, .pci_subdevice = 0x12b3,
-	  .config = AD1986A_LAPTOP_EAPD }, /* ASUS V1j */
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x30af,
-	  .config = AD1986A_LAPTOP_EAPD }, /* HP Compaq Presario B2800 */
-	{ .pci_subvendor = 0x17aa, .pci_subdevice = 0x2066,
-	  .config = AD1986A_LAPTOP_EAPD }, /* Lenovo 3000 N100-07684JU */
-=======
 enum {
 	AD1986A_6STACK,
 	AD1986A_3STACK,
@@ -869,7 +824,6 @@ static struct snd_pci_quirk ad1986a_cfg_
 	SND_PCI_QUIRK(0x17aa, 0x1017, "Lenovo A60", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x17aa, 0x2066, "Lenovo N100", AD1986A_LAPTOP_EAPD),
 	SND_PCI_QUIRK(0x17c0, 0x2017, "Samsung M50", AD1986A_LAPTOP),
->>>>>>> /sound/pci/hda/patch_analog.c
 	{}
 };
 
diff -puN sound/pci/hda/patch_realtek.c~git-alsa-fixups sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~git-alsa-fixups
+++ a/sound/pci/hda/patch_realtek.c
@@ -6491,28 +6491,6 @@ static void alc262_auto_init(struct hda_
 /*
  * configuration and preset
  */
-<<<<<<< HEAD/sound/pci/hda/patch_realtek.c
-static struct hda_board_config alc262_cfg_tbl[] = {
-	{ .modelname = "basic", .config = ALC262_BASIC },
-	{ .modelname = "fujitsu", .config = ALC262_FUJITSU },
-	{ .pci_subvendor = 0x10cf, .pci_subdevice = 0x1397,
-	  .config = ALC262_FUJITSU },
-	{ .modelname = "hp-bpc", .config = ALC262_HP_BPC },
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x280c,
-	  .config = ALC262_HP_BPC }, /* xw4400 */
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x2801,
-	  .config = ALC262_HP_BPC }, /* q965 */
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x3014,
-	  .config = ALC262_HP_BPC }, /* xw6400 */
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x3015,
-	  .config = ALC262_HP_BPC }, /* xw8400 */
-	{ .pci_subvendor = 0x103c, .pci_subdevice = 0x12fe,
-	  .config = ALC262_HP_BPC }, /* xw9400 */
-	{ .modelname = "benq", .config = ALC262_BENQ_ED8 },
-	{ .pci_subvendor = 0x17ff, .pci_subdevice = 0x0560,
-	  .config = ALC262_BENQ_ED8 },
-	{ .modelname = "auto", .config = ALC262_AUTO },
-=======
 static const char *alc262_models[ALC262_MODEL_LAST] = {
 	[ALC262_BASIC]		= "basic",
 	[ALC262_HIPPO]		= "hippo",
@@ -6534,7 +6512,6 @@ static struct snd_pci_quirk alc262_cfg_t
 	SND_PCI_QUIRK(0x10cf, 0x1397, "Fujitsu", ALC262_FUJITSU),
 	SND_PCI_QUIRK(0x17ff, 0x058f, "Benq Hippo", ALC262_HIPPO_1),
 	SND_PCI_QUIRK(0x17ff, 0x0560, "Benq ED8", ALC262_BENQ_ED8),
->>>>>>> /sound/pci/hda/patch_realtek.c
 	{}
 };
 
diff -puN sound/pci/via82xx.c~git-alsa-fixups sound/pci/via82xx.c
--- a/sound/pci/via82xx.c~git-alsa-fixups
+++ a/sound/pci/via82xx.c
@@ -2403,86 +2403,6 @@ static struct snd_pci_quirk dxs_whitelis
 
 static int __devinit check_dxs_list(struct pci_dev *pci, int revision)
 {
-<<<<<<< HEAD/sound/pci/via82xx.c
-	static struct dxs_whitelist whitelist[] __devinitdata = {
-		{ .subvendor = 0x1005, .subdevice = 0x4710, .action = VIA_DXS_ENABLE }, /* Avance Logic Mobo */
-		{ .subvendor = 0x1019, .subdevice = 0x0996, .action = VIA_DXS_48K },
-		{ .subvendor = 0x1019, .subdevice = 0x0a81, .action = VIA_DXS_NO_VRA }, /* ECS K7VTA3 v8.0 */
-		{ .subvendor = 0x1019, .subdevice = 0x0a85, .action = VIA_DXS_NO_VRA }, /* ECS L7VMM2 */
-		{ .subvendor = 0x1019, .subdevice = 0xa101, .action = VIA_DXS_SRC },
-		{ .subvendor = 0x1019, .subdevice = 0xaa01, .action = VIA_DXS_SRC }, /* ECS K8T890-A */
-		{ .subvendor = 0x1025, .subdevice = 0x0033, .action = VIA_DXS_NO_VRA }, /* Acer Inspire 1353LM */
-		{ .subvendor = 0x1025, .subdevice = 0x0046, .action = VIA_DXS_SRC }, /* Acer Aspire 1524 WLMi */
-		{ .subvendor = 0x1043, .subdevice = 0x8095, .action = VIA_DXS_NO_VRA }, /* ASUS A7V8X (FIXME: possibly VIA_DXS_ENABLE?)*/
-		{ .subvendor = 0x1043, .subdevice = 0x80a1, .action = VIA_DXS_NO_VRA }, /* ASUS A7V8-X */
-		{ .subvendor = 0x1043, .subdevice = 0x80b0, .action = VIA_DXS_NO_VRA }, /* ASUS A7V600 & K8V*/ 
-		{ .subvendor = 0x1043, .subdevice = 0x810d, .action = VIA_DXS_SRC }, /* ASUS */
-		{ .subvendor = 0x1043, .subdevice = 0x812a, .action = VIA_DXS_SRC    }, /* ASUS A8V Deluxe */ 
-		{ .subvendor = 0x1043, .subdevice = 0x8174, .action = VIA_DXS_SRC    }, /* ASUS */
-		{ .subvendor = 0x1043, .subdevice = 0x81b9, .action = VIA_DXS_SRC    }, /* ASUS A8V-MX */
-		{ .subvendor = 0x1071, .subdevice = 0x8375, .action = VIA_DXS_NO_VRA }, /* Vobis/Yakumo/Mitac notebook */
-		{ .subvendor = 0x1071, .subdevice = 0x8399, .action = VIA_DXS_NO_VRA }, /* Umax AB 595T (VIA K8N800A - VT8237) */
-		{ .subvendor = 0x10cf, .subdevice = 0x118e, .action = VIA_DXS_ENABLE }, /* FSC laptop */
-		{ .subvendor = 0x1106, .subdevice = 0x4161, .action = VIA_DXS_NO_VRA }, /* ASRock K7VT2 */
-		{ .subvendor = 0x1106, .subdevice = 0x4552, .action = VIA_DXS_NO_VRA }, /* QDI Kudoz 7X/600-6AL */
-		{ .subvendor = 0x1106, .subdevice = 0xaa01, .action = VIA_DXS_NO_VRA }, /* EPIA MII */
-		{ .subvendor = 0x1106, .subdevice = 0xc001, .action = VIA_DXS_SRC }, /* Insight P4-ITX */
-		{ .subvendor = 0x1297, .subdevice = 0xa232, .action = VIA_DXS_ENABLE }, /* Shuttle ?? */
-		{ .subvendor = 0x1297, .subdevice = 0xc160, .action = VIA_DXS_ENABLE }, /* Shuttle SK41G */
-		{ .subvendor = 0x1458, .subdevice = 0xa002, .action = VIA_DXS_ENABLE }, /* Gigabyte GA-7VAXP */
-		{ .subvendor = 0x1462, .subdevice = 0x0080, .action = VIA_DXS_SRC }, /* MSI K8T Neo-FIS2R */
-		{ .subvendor = 0x1462, .subdevice = 0x0430, .action = VIA_DXS_SRC }, /* MSI 7142 (K8MM-V) */
-		{ .subvendor = 0x1462, .subdevice = 0x0470, .action = VIA_DXS_SRC }, /* MSI KT880 Delta-FSR */
-		{ .subvendor = 0x1462, .subdevice = 0x3800, .action = VIA_DXS_ENABLE }, /* MSI KT266 */
-		{ .subvendor = 0x1462, .subdevice = 0x5901, .action = VIA_DXS_NO_VRA }, /* MSI KT6 Delta-SR */
-		{ .subvendor = 0x1462, .subdevice = 0x7023, .action = VIA_DXS_SRC }, /* MSI K8T Neo2-FI */
-		{ .subvendor = 0x1462, .subdevice = 0x7120, .action = VIA_DXS_ENABLE }, /* MSI KT4V */
-		{ .subvendor = 0x1462, .subdevice = 0x7142, .action = VIA_DXS_ENABLE }, /* MSI K8MM-V */
-		{ .subvendor = 0x1462, .subdevice = 0xb012, .action = VIA_DXS_SRC }, /* P4M800/VIA8237R */
-		{ .subvendor = 0x147b, .subdevice = 0x1401, .action = VIA_DXS_ENABLE }, /* ABIT KD7(-RAID) */
-		{ .subvendor = 0x147b, .subdevice = 0x1411, .action = VIA_DXS_ENABLE }, /* ABIT VA-20 */
-		{ .subvendor = 0x147b, .subdevice = 0x1413, .action = VIA_DXS_ENABLE }, /* ABIT KV8 Pro */
-		{ .subvendor = 0x147b, .subdevice = 0x1415, .action = VIA_DXS_NO_VRA }, /* Abit AV8 */
-		{ .subvendor = 0x14ff, .subdevice = 0x0403, .action = VIA_DXS_ENABLE }, /* Twinhead mobo */
-		{ .subvendor = 0x14ff, .subdevice = 0x0408, .action = VIA_DXS_SRC }, /* Twinhead laptop */
-		{ .subvendor = 0x1558, .subdevice = 0x4701, .action = VIA_DXS_SRC }, /* Clevo D470 */
-		{ .subvendor = 0x1584, .subdevice = 0x8120, .action = VIA_DXS_ENABLE }, /* Gericom/Targa/Vobis/Uniwill laptop */
-		{ .subvendor = 0x1584, .subdevice = 0x8123, .action = VIA_DXS_NO_VRA }, /* Uniwill (Targa Visionary XP-210) */
-		{ .subvendor = 0x161f, .subdevice = 0x202b, .action = VIA_DXS_NO_VRA }, /* Amira Note book */
-		{ .subvendor = 0x161f, .subdevice = 0x2032, .action = VIA_DXS_48K }, /* m680x machines */
-		{ .subvendor = 0x1631, .subdevice = 0xe004, .action = VIA_DXS_ENABLE }, /* Easy Note 3174, Packard Bell */
-		{ .subvendor = 0x1695, .subdevice = 0x3005, .action = VIA_DXS_ENABLE }, /* EPoX EP-8K9A */
-		{ .subvendor = 0x1695, .subdevice = 0x300c, .action = VIA_DXS_SRC }, /* EPoX EP-8KRAI */
-		{ .subvendor = 0x1695, .subdevice = 0x300e, .action = VIA_DXS_SRC }, /* EPoX 9HEAI */
-		{ .subvendor = 0x16f3, .subdevice = 0x6405, .action = VIA_DXS_SRC }, /* Jetway K8M8MS */
-		{ .subvendor = 0x1734, .subdevice = 0x1078, .action = VIA_DXS_SRC }, /* FSC Amilo L7300 */
-		{ .subvendor = 0x1734, .subdevice = 0x1093, .action = VIA_DXS_SRC }, /* FSC */
-		{ .subvendor = 0x1734, .subdevice = 0x10ab, .action = VIA_DXS_SRC }, /* FSC */
-		{ .subvendor = 0x1849, .subdevice = 0x3059, .action = VIA_DXS_NO_VRA }, /* ASRock K7VM2 */
-		{ .subvendor = 0x1849, .subdevice = 0x9739, .action = VIA_DXS_SRC }, /* ASRock mobo(?) */
-		{ .subvendor = 0x1849, .subdevice = 0x9761, .action = VIA_DXS_SRC }, /* ASRock mobo(?) */
-		{ .subvendor = 0x1919, .subdevice = 0x200a, .action = VIA_DXS_NO_VRA }, /* Soltek SL-K8Tpro-939 */
-		{ .subvendor = 0x4005, .subdevice = 0x4710, .action = VIA_DXS_SRC },	/* MSI K7T266 Pro2 (MS-6380 V2.0) BIOS 3.7 */
-		{ } /* terminator */
-	};
-	const struct dxs_whitelist *w;
-	unsigned short subsystem_vendor;
-	unsigned short subsystem_device;
-
-	pci_read_config_word(pci, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vendor);
-	pci_read_config_word(pci, PCI_SUBSYSTEM_ID, &subsystem_device);
-
-	for (w = whitelist; w->subvendor; w++) {
-		if (w->subvendor != subsystem_vendor)
-			continue;
-		if (w->mask) {
-			if ((w->mask & subsystem_device) == w->subdevice)
-				return w->action;
-		} else {
-			if (subsystem_device == w->subdevice)
-				return w->action;
-		}
-=======
 	const struct snd_pci_quirk *w;
 
 	w = snd_pci_quirk_lookup(pci, dxs_whitelist);
@@ -2490,7 +2410,6 @@ static int __devinit check_dxs_list(stru
 		snd_printdd(KERN_INFO "via82xx: DXS white list for %s found\n",
 			    w->name);
 		return w->value;
->>>>>>> /sound/pci/via82xx.c
 	}
 
 	/* for newer revision, default to DXS_SRC */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixups.patch
cifs-sprintf-fix.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

