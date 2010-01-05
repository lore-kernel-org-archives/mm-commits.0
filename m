From: akpm@linux-foundation.org
Subject: [merged] net-sctp-socketc-squish-warning.patch removed from -mm tree
Date: Tue, 05 Jan 2010 13:12:38 -0800
Message-ID: <201001052112.o05LCc9Q019873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab0AEVMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 16:12:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrei@iptel.org, davem@davemloft.net, vladislav.yasevich@hp.com, mm-commits@vger.kernel.org


The patch titled
     net/sctp/socket.c: squish warning
has been removed from the -mm tree.  Its filename was
     net-sctp-socketc-squish-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/sctp/socket.c: squish warning
From: Andrew Morton <akpm@linux-foundation.org>

net/sctp/socket.c: In function 'sctp_setsockopt_autoclose':
net/sctp/socket.c:2090: warning: comparison is always false due to limited range of data type

Cc: Andrei Pelinescu-Onciul <andrei@iptel.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/socket.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/sctp/socket.c~net-sctp-socketc-squish-warning net/sctp/socket.c
--- a/net/sctp/socket.c~net-sctp-socketc-squish-warning
+++ a/net/sctp/socket.c
@@ -2087,8 +2087,7 @@ static int sctp_setsockopt_autoclose(str
 	if (copy_from_user(&sp->autoclose, optval, optlen))
 		return -EFAULT;
 	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
-	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
-		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
+	sp->autoclose = min_t(long, sp->autoclose, MAX_SCHEDULE_TIMEOUT / HZ);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

