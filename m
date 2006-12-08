From: akpm@osdl.org
Subject: - pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:44:26 -0800
Message-ID: <200612080844.kB88iQpY013760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36562 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032531AbWLHIoj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, balagi@justmail.de, jens.axboe@oracle.com, petero2@telia.com, mm-commits@vger.kernel.org


The patch titled
     pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix
has been removed from the -mm tree.  Its filename was
     pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch

This patch was dropped because it was folded into pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch

------------------------------------------------------
Subject: pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix
From: Andrew Morton <akpm@osdl.org>

This got renamed.

Cc: Thomas Maier <balagi@justmail.de>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix
+++ a/drivers/block/pktcdvd.c
@@ -2199,7 +2199,7 @@ static int pkt_make_request(request_queu
 		blk_set_queue_congested(q, WRITE);
 		do {
 			spin_unlock(&pd->lock);
-			blk_congestion_wait(WRITE, HZ);
+			congestion_wait(WRITE, HZ);
 			spin_lock(&pd->lock);
 		} while(pd->bio_queue_size > pd->write_congestion_off);
 	}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch

