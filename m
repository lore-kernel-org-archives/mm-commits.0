From: akpm@linux-foundation.org
Subject: + mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 17:17:34 -0800
Message-ID: <201002040143.o141h4UN032403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932983Ab0BDBnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 20:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com, rjw@sisk.pl, sebott@linux.vnet.ibm.com


The patch titled
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
has been added to the -mm tree.  Its filename is
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch

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
Subject: mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/built-in.o: In function `clear_gfp_allowed_mask':
: undefined reference to `pm_mutex'
mm/built-in.o: In function `set_gfp_allowed_mask':
: undefined reference to `pm_mutex'
make: *** [.tmp_vmlinux1] Error 1


Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix
+++ a/mm/page_alloc.c
@@ -77,6 +77,7 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+#ifdef CONFIG_PM
 /*
  * The following functions are used by the suspend/hibernate code to temporarily
  * change gfp_allowed_mask in order to avoid using I/O during memory allocations
@@ -85,7 +86,6 @@ gfp_t gfp_allowed_mask __read_mostly = G
  * only be modified with pm_mutex held, unless the suspend/hibernate code is
  * guaranteed not to run in parallel with that modification).
  */
-
 void set_gfp_allowed_mask(gfp_t mask)
 {
 	WARN_ON(!mutex_is_locked(&pm_mutex));
@@ -100,6 +100,7 @@ gfp_t clear_gfp_allowed_mask(gfp_t mask)
 	gfp_allowed_mask &= ~mask;
 	return ret;
 }
+#endif		/* CONFIG_PM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch
drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-rev-3-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

