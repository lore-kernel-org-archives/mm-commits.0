From: akpm@linux-foundation.org
Subject: + pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:18:08 -0800
Message-ID: <201001260018.o0Q0I8ei019742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab0AZASW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:18:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, travis@sgi.com


The patch titled
     pci-update-pci_set_vga_state-to-call-arch-functions-fix
has been added to the -mm tree.  Its filename is
     pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch

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
Subject: pci-update-pci_set_vga_state-to-call-arch-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

Make pci_register_set_vga_state() __init.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pci.c~pci-update-pci_set_vga_state-to-call-arch-functions-fix drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-update-pci_set_vga_state-to-call-arch-functions-fix
+++ a/drivers/pci/pci.c
@@ -2757,7 +2757,7 @@ int pci_resource_bar(struct pci_dev *dev
 /* Some architectures require additional programming to enable VGA */
 static arch_set_vga_state_t arch_set_vga_state;
 
-void pci_register_set_vga_state(arch_set_vga_state_t func)
+void __init pci_register_set_vga_state(arch_set_vga_state_t func)
 {
 	arch_set_vga_state = func;	/* NULL disables */
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
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

