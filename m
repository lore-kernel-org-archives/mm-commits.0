From: akpm@linux-foundation.org
Subject: + revert-ac97-fix-microphone-and-line_in-selection-logic.patch added to -mm tree
Date: Wed, 07 Mar 2007 11:50:48 -0800
Message-ID: <200703071950.l27JomiF007084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53285 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992517AbXCGTyK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 14:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@stusta.de, michal.k.k.piotrowski@gmail.com, perex@suse.cz, rcushman_linux@earthlink.net, tiwai@suse.de


The patch titled
     revert "ac97 - fix microphone and line_in selection logic"
has been added to the -mm tree.  Its filename is
     revert-ac97-fix-microphone-and-line_in-selection-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "ac97 - fix microphone and line_in selection logic"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 831466f4ad2b5fe23dff77edbe6a7c244435e973: "Michal Piotrowski"
<michal.k.k.piotrowski@gmail.com> reports that it broke his 3d surround.

Cc:"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: Randy Cushman <rcushman_linux@earthlink.net>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ac97/ac97_patch.c |   66 +++++++++++++---------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

diff -puN sound/pci/ac97/ac97_patch.c~revert-ac97-fix-microphone-and-line_in-selection-logic sound/pci/ac97/ac97_patch.c
--- a/sound/pci/ac97/ac97_patch.c~revert-ac97-fix-microphone-and-line_in-selection-logic
+++ a/sound/pci/ac97/ac97_patch.c
@@ -190,28 +190,14 @@ static inline int is_clfe_on(struct snd_
 	return ac97->channel_mode >= 2;
 }
 
-/* system has shared jacks with surround out enabled */
-static inline int is_shared_surrout(struct snd_ac97 *ac97)
-{
-	return !ac97->indep_surround && is_surround_on(ac97);
-}
-
-/* system has shared jacks with center/lfe out enabled */
-static inline int is_shared_clfeout(struct snd_ac97 *ac97)
-{
-	return !ac97->indep_surround && is_clfe_on(ac97);
-}
-
-/* system has shared jacks with line in enabled */
 static inline int is_shared_linein(struct snd_ac97 *ac97)
 {
-	return !ac97->indep_surround && !is_surround_on(ac97);
+	return ! ac97->indep_surround && is_surround_on(ac97);
 }
 
-/* system has shared jacks with mic in enabled */
 static inline int is_shared_micin(struct snd_ac97 *ac97)
 {
-	return !ac97->indep_surround && !is_clfe_on(ac97);
+	return ! ac97->indep_surround && is_clfe_on(ac97);
 }
 
 
@@ -2485,12 +2471,12 @@ static void alc650_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	snd_ac97_update_bits(ac97, AC97_ALC650_MULTICH, 1 << 9,
 			     shared ? (1 << 9) : 0);
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared Mic */
+	shared = is_shared_micin(ac97);
 	/* disable/enable vref */
 	snd_ac97_update_bits(ac97, AC97_ALC650_CLOCK, 1 << 12,
 			     shared ? (1 << 12) : 0);
@@ -2620,12 +2606,12 @@ static void alc655_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	ac97_update_bits_page(ac97, AC97_ALC650_MULTICH, 1 << 9,
 			      shared ? (1 << 9) : 0, 0);
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared mic */
+	shared = is_shared_micin(ac97);
 	/* misc control; vrefout disable */
 	snd_ac97_update_bits(ac97, AC97_ALC650_CLOCK, 1 << 12,
 			     shared ? (1 << 12) : 0);
@@ -2769,16 +2755,16 @@ static void alc850_update_jacks(struct s
 {
 	int shared;
 	
-	/* shared Line-In / Surround Out */
-	shared = is_shared_surrout(ac97);
+	/* shared Line-In */
+	shared = is_shared_linein(ac97);
 	/* SURR 1kOhm (bit4), Amp (bit5) */
 	snd_ac97_update_bits(ac97, AC97_ALC850_MISC1, (1<<4)|(1<<5),
 			     shared ? (1<<5) : (1<<4));
 	/* LINE-IN = 0, SURROUND = 2 */
 	snd_ac97_update_bits(ac97, AC97_ALC850_JACK_SELECT, 7 << 12,
 			     shared ? (2<<12) : (0<<12));
-	/* update shared Mic In / Center/LFE Out */
-	shared = is_shared_clfeout(ac97);
+	/* update shared mic */
+	shared = is_shared_micin(ac97);
 	/* Vref disable (bit12), 1kOhm (bit13) */
 	snd_ac97_update_bits(ac97, AC97_ALC850_MISC1, (1<<12)|(1<<13),
 			     shared ? (1<<12) : (1<<13));
@@ -2851,9 +2837,9 @@ int patch_alc850(struct snd_ac97 *ac97)
  */
 static void cm9738_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, AC97_CM9738_VENDOR_CTRL, 1 << 10,
-			     is_shared_surrout(ac97) ? (1 << 10) : 0);
+			     is_shared_linein(ac97) ? (1 << 10) : 0);
 }
 
 static const struct snd_kcontrol_new snd_ac97_cm9738_controls[] = {
@@ -2935,12 +2921,12 @@ static const struct snd_kcontrol_new snd
 
 static void cm9739_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, AC97_CM9739_MULTI_CHAN, 1 << 10,
-			     is_shared_surrout(ac97) ? (1 << 10) : 0);
-	/* shared Mic In / Center/LFE Out **/
+			     is_shared_linein(ac97) ? (1 << 10) : 0);
+	/* shared Mic */
 	snd_ac97_update_bits(ac97, AC97_CM9739_MULTI_CHAN, 0x3000,
-			     is_shared_clfeout(ac97) ? 0x1000 : 0x2000);
+			     is_shared_micin(ac97) ? 0x1000 : 0x2000);
 }
 
 static const struct snd_kcontrol_new snd_ac97_cm9739_controls[] = {
@@ -3052,8 +3038,8 @@ static void cm9761_update_jacks(struct s
 
 	val |= surr_on[ac97->spec.dev_flags][is_surround_on(ac97)];
 	val |= clfe_on[ac97->spec.dev_flags][is_clfe_on(ac97)];
-	val |= surr_shared[ac97->spec.dev_flags][is_shared_surrout(ac97)];
-	val |= clfe_shared[ac97->spec.dev_flags][is_shared_clfeout(ac97)];
+	val |= surr_shared[ac97->spec.dev_flags][is_shared_linein(ac97)];
+	val |= clfe_shared[ac97->spec.dev_flags][is_shared_micin(ac97)];
 
 	snd_ac97_update_bits(ac97, AC97_CM9761_MULTI_CHAN, 0x3c88, val);
 }
@@ -3301,12 +3287,12 @@ int patch_vt1617a(struct snd_ac97 * ac97
  */
 static void it2646_update_jacks(struct snd_ac97 *ac97)
 {
-	/* shared Line-In / Surround Out */
+	/* shared Line-In */
 	snd_ac97_update_bits(ac97, 0x76, 1 << 9,
-			     is_shared_surrout(ac97) ? (1<<9) : 0);
-	/* shared Mic / Center/LFE Out */
+			     is_shared_linein(ac97) ? (1<<9) : 0);
+	/* shared Mic */
 	snd_ac97_update_bits(ac97, 0x76, 1 << 10,
-			     is_shared_clfeout(ac97) ? (1<<10) : 0);
+			     is_shared_micin(ac97) ? (1<<10) : 0);
 }
 
 static const struct snd_kcontrol_new snd_ac97_controls_it2646[] = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-ac97-fix-microphone-and-line_in-selection-logic.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-fix.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
