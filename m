From: akpm@linux-foundation.org
Subject: - revert-ac97-fix-microphone-and-line_in-selection-logic.patch removed from -mm tree
Date: Tue, 27 Mar 2007 08:27:03 -0800
Message-ID: <200703271627.l2RGR3o2020426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXC0Qa1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 12:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@stusta.de, michal.k.k.piotrowski@gmail.com, perex@suse.cz, rcushman_linux@earthlink.net, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     revert "ac97 - fix microphone and line_in selection logic"
has been removed from the -mm tree.  Its filename was
     revert-ac97-fix-microphone-and-line_in-selection-logic.patch

This patch was dropped because it is obsolete

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
@@ -178,28 +178,14 @@ static inline int is_clfe_on(struct snd_
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
 
 
@@ -2476,12 +2462,12 @@ static void alc650_update_jacks(struct s
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
@@ -2611,12 +2597,12 @@ static void alc655_update_jacks(struct s
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
@@ -2761,16 +2747,16 @@ static void alc850_update_jacks(struct s
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
@@ -2843,9 +2829,9 @@ static int patch_alc850(struct snd_ac97 
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
@@ -2927,12 +2913,12 @@ static const struct snd_kcontrol_new snd
 
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
@@ -3044,8 +3030,8 @@ static void cm9761_update_jacks(struct s
 
 	val |= surr_on[ac97->spec.dev_flags][is_surround_on(ac97)];
 	val |= clfe_on[ac97->spec.dev_flags][is_clfe_on(ac97)];
-	val |= surr_shared[ac97->spec.dev_flags][is_shared_surrout(ac97)];
-	val |= clfe_shared[ac97->spec.dev_flags][is_shared_clfeout(ac97)];
+	val |= surr_shared[ac97->spec.dev_flags][is_shared_linein(ac97)];
+	val |= clfe_shared[ac97->spec.dev_flags][is_shared_micin(ac97)];
 
 	snd_ac97_update_bits(ac97, AC97_CM9761_MULTI_CHAN, 0x3c88, val);
 }
@@ -3388,12 +3374,12 @@ int patch_vt1617a(struct snd_ac97 * ac97
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

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
make-aout-executables-work-again.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
time-smp-friendly-alignment-of-struct-clocksource-fix.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch
