From: akpm@linux-foundation.org
Subject: [obsolete] sound-core-initc-fix-deadlock.patch removed from -mm tree
Date: Thu, 04 Jun 2009 13:13:14 -0700
Message-ID: <200906042013.n54KDEhl027094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbZFDUNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2009 16:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/core/init.c: fix deadlock
has been removed from the -mm tree.  Its filename was
     sound-core-initc-fix-deadlock.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/core/init.c: fix deadlock
From: Andrew Morton <akpm@linux-foundation.org>

[  341.381805] work_for_cpu  D 0000000000000000     0  1372      2 0x00000000
[  341.381805]  ffff880253527d10 0000000000000046 ffff880253527d60 ffffffff8100c5ce
[  341.381805]  ffff880253527d10 ffff88025f1ed7c0 ffff88025f149800 ffff88025f1edb60
[  341.381805]  ffffffff81552e49 ffff880253527fd8 ffff880028066000 0000000000000000
[  341.381805] Call Trace:
[  341.381805]  [<ffffffff8100c5ce>] ? apic_timer_interrupt+0xe/0x20
[  341.381805]  [<ffffffff8134d2f0>] __mutex_lock_slowpath+0xd0/0x126
[  341.381805]  [<ffffffff8134d1b6>] mutex_lock+0x2c/0x43
[  341.381805]  [<ffffffffa004899e>] snd_card_set_id+0x130/0x202 [snd]
[  341.381805]  [<ffffffffa0048ac5>] snd_card_register+0x55/0xda [snd]
[  341.381805]  [<ffffffffa011d626>] azx_probe+0x8cf/0x941 [snd_hda_intel]
[  341.381805]  [<ffffffffa011b7d0>] ? azx_send_cmd+0x0/0x127 [snd_hda_intel]
[  341.381805]  [<ffffffffa011cb3f>] ? azx_get_response+0x0/0x1dd [snd_hda_intel]
[  341.381805]  [<ffffffffa011c16c>] ? azx_attach_pcm_stream+0x0/0x18c [snd_hda_intel]
[  341.381805]  [<ffffffffa011bdce>] ? azx_bus_reset+0x0/0x7d [snd_hda_intel]
[  341.381805]  [<ffffffff8104fac0>] ? do_work_for_cpu+0x0/0x22
[  341.381805]  [<ffffffff811903b4>] local_pci_probe+0x12/0x16
[  341.381805]  [<ffffffff8104fad0>] do_work_for_cpu+0x10/0x22
[  341.381805]  [<ffffffff810530ee>] kthread+0x88/0x90
[  341.381805]  [<ffffffff8100caba>] child_rip+0xa/0x20
[  341.381805]  [<ffffffff81053066>] ? kthread+0x0/0x90
[  341.381805]  [<ffffffff8100cab0>] ? child_rip+0x0/0x20

snd_card_register() calls snd_card_set_id() under snd_card_mutex, so taking it
again doesn't work very well.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/init.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN sound/core/init.c~sound-core-initc-fix-deadlock sound/core/init.c
--- a/sound/core/init.c~sound-core-initc-fix-deadlock
+++ a/sound/core/init.c
@@ -529,14 +529,12 @@ void snd_card_set_id(struct snd_card *ca
       		}
 	      	if (!snd_info_check_reserved_words(id))
       			goto __change;
-		mutex_lock(&snd_card_mutex);
 		for (i = 0; i < snd_ecards_limit; i++) {
 			if (snd_cards[i] && !strcmp(snd_cards[i]->id, id)) {
 				mutex_unlock(&snd_card_mutex);
 				goto __change;
 			}
 		}
-		mutex_unlock(&snd_card_mutex);
 		break;
 
 	      __change:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
ds_selftest-is-borked.patch
sound-core-initc-fix-deadlock.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device-cleanup.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
proc-merge-arrayc-into-basec-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix.patch
gpio-driver-for-primecell-pl061-gpio-controller-fix-fix.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

