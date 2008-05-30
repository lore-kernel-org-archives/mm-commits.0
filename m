From: akpm@linux-foundation.org
Subject: - dvb-usb-gp8pskc-return-errno-rather-than-errno.patch removed from -mm tree
Date: Fri, 30 May 2008 15:38:40 -0700
Message-ID: <200805302238.m4UMceG9014847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbYE3Wj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, lizf@cn.fujitsu.cn, mm-commits@vger.kernel.org


The patch titled
     dvb-usb/gp8psk.c: return -errno rather than errno
has been removed from the -mm tree.  Its filename was
     dvb-usb-gp8pskc-return-errno-rather-than-errno.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb-usb/gp8psk.c: return -errno rather than errno
From: Li Zefan <lizf@cn.fujitsu.com>

gp8psk_power_ctrl() returns -EINVAL in some failing paths, but returns
EINVAL in some other paths.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/gp8psk.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8pskc-return-errno-rather-than-errno drivers/media/dvb/dvb-usb/gp8psk.c
--- a/drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8pskc-return-errno-rather-than-errno
+++ a/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -146,24 +146,24 @@ static int gp8psk_power_ctrl(struct dvb_
 		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
 			if (! (status & bm8pskFW_Loaded)) /* BCM4500 firmware loaded */
 				if(gp8psk_load_bcm4500fw(d))
-					return EINVAL;
+					return -EINVAL;
 
 		if (! (status & bmIntersilOn)) /* LNB Power */
 			if (gp8psk_usb_in_op(d, START_INTERSIL, 1, 0,
 					&buf, 1))
-				return EINVAL;
+				return -EINVAL;
 
 		/* Set DVB mode to 1 */
 		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
 			if (gp8psk_usb_out_op(d, SET_DVB_MODE, 1, 0, NULL, 0))
-				return EINVAL;
+				return -EINVAL;
 		/* Abort possible TS (if previous tune crashed) */
 		if (gp8psk_usb_out_op(d, ARM_TRANSFER, 0, 0, NULL, 0))
-			return EINVAL;
+			return -EINVAL;
 	} else {
 		/* Turn off LNB power */
 		if (gp8psk_usb_in_op(d, START_INTERSIL, 0, 0, &buf, 1))
-			return EINVAL;
+			return -EINVAL;
 		/* Turn off 8psk power */
 		if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
 			return -EINVAL;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
leds-fix-unsigned-value-overflow-in-for-loop.patch
scsi-libiscsic-return-errno-rather-than-errno.patch
call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

