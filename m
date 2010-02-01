From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch added to -mm tree
Date: Mon, 01 Feb 2010 15:52:07 -0800
Message-ID: <201002020017.o120HXmL021378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827Ab0BBARx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 19:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, manu@linuxtv.org, mchehab@redhat.com


The patch titled
     drivers/media/dvb/frontends/stv090x.c: fix use-uninitlalised
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch

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
Subject: drivers/media/dvb/frontends/stv090x.c: fix use-uninitlalised
From: Andrew Morton <akpm@linux-foundation.org>

Mad guess.

Cc: Manu Abraham <manu@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stv090x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised drivers/media/dvb/frontends/stv090x.c
--- a/drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised
+++ a/drivers/media/dvb/frontends/stv090x.c
@@ -2047,7 +2047,7 @@ static int stv090x_chk_tmg(struct stv090
 	u32 reg;
 	s32 tmg_cpt = 0, i;
 	u8 freq, tmg_thh, tmg_thl;
-	int tmg_lock;
+	int tmg_lock = 0;
 
 	freq = STV090x_READ_DEMOD(state, CARFREQ);
 	tmg_thh = STV090x_READ_DEMOD(state, TMGTHRISE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-char-randomc-fix-unused-var-warning.patch
memory-hotplug-fix-a-bug-on-dev-mem-for-64-bit-kernels-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-gpu-drm-radeon-radeon_agpc-fix-printk-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh-fix.patch
drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch

