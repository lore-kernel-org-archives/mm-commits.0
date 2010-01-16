From: akpm@linux-foundation.org
Subject: [folded] ttyh-make-function-static-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2010 16:53:14 -0800
Message-ID: <201001160053.o0G0rEdf008455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758366Ab0APAx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Jan 2010 19:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ttyh-make-function-static-fix
has been removed from the -mm tree.  Its filename was
     ttyh-make-function-static-fix.patch

This patch was dropped because it was folded into ttyh-make-function-static.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ttyh-make-function-static-fix
From: Andrew Morton <akpm@linux-foundation.org>

May as well convert tty_port_users() also.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tty.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/tty.h~ttyh-make-function-static-fix include/linux/tty.h
--- a/include/linux/tty.h~ttyh-make-function-static-fix
+++ a/include/linux/tty.h
@@ -486,7 +486,7 @@ extern void tty_port_close(struct tty_po
 				struct tty_struct *tty, struct file *filp);
 extern int tty_port_open(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
-extern inline int tty_port_users(struct tty_port *port)
+static inline int tty_port_users(struct tty_port *port)
 {
 	return port->count + port->blocked_open;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ttyh-make-function-static.patch
ttyh-make-function-static-fix.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
revert-clockevents-prevent-clockevent_devices-list-corruption-on-cpu-hotplug.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
drivers-usb-core-sysfsc-set_reset_quirk-remove-unused-local.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
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
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

