From: akpm@linux-foundation.org
Subject: [merged] jbd2-dont-use-__gfp_nofail-in-journal_init_common.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:31:43 -0800
Message-ID: <200912292131.nBTLVh0E008509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZL2Vbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:31:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, casteyde.christian@free.fr, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     jbd2: don't use __GFP_NOFAIL in journal_init_common()
has been removed from the -mm tree.  Its filename was
     jbd2-dont-use-__gfp_nofail-in-journal_init_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: don't use __GFP_NOFAIL in journal_init_common()
From: Andrew Morton <akpm@linux-foundation.org>

It triggers the warning in get_page_from_freelist(), and it isn't
appropriate to use __GFP_NOFAIL here anyway.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14843

Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd2/journal.c~jbd2-dont-use-__gfp_nofail-in-journal_init_common fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-dont-use-__gfp_nofail-in-journal_init_common
+++ a/fs/jbd2/journal.c
@@ -814,7 +814,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
hid-logitech-g13-driver-002-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

