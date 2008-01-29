From: akpm@linux-foundation.org
Subject: - ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:28 -0800
Message-ID: <200801290150.m0T1oSSr027571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYA2B5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3: checkpatch drivers/ps3/ps3-sys-manager.c
has been removed from the -mm tree.  Its filename was
     ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3: checkpatch drivers/ps3/ps3-sys-manager.c
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3-sys-manager.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/ps3/ps3-sys-manager.c~ps3-checkpatch-drivers-ps3-ps3-sys-managerc drivers/ps3/ps3-sys-manager.c
--- a/drivers/ps3/ps3-sys-manager.c~ps3-checkpatch-drivers-ps3-ps3-sys-managerc
+++ a/drivers/ps3/ps3-sys-manager.c
@@ -452,7 +452,7 @@ static int ps3_sys_manager_handle_event(
 	case PS3_SM_EVENT_THERMAL_ALERT:
 		dev_dbg(&dev->core, "%s:%d: THERMAL_ALERT (zone %u)\n",
 			__func__, __LINE__, event.value);
-		printk(KERN_INFO "PS3 Thermal Alert Zone %u\n", event.value);
+		pr_info("PS3 Thermal Alert Zone %u\n", event.value);
 		break;
 	case PS3_SM_EVENT_THERMAL_CLEARED:
 		dev_dbg(&dev->core, "%s:%d: THERMAL_CLEARED (zone %u)\n",
@@ -488,7 +488,7 @@ static int ps3_sys_manager_handle_cmd(st
 	result = ps3_vuart_read(dev, &cmd, sizeof(cmd));
 	BUG_ON(result && "need to retry here");
 
-	if(result)
+	if (result)
 		return result;
 
 	if (cmd.version != 1) {
@@ -521,7 +521,7 @@ static int ps3_sys_manager_handle_msg(st
 	result = ps3_vuart_read(dev, &header,
 		sizeof(struct ps3_sys_manager_header));
 
-	if(result)
+	if (result)
 		return result;
 
 	if (header.version != 1) {
@@ -589,9 +589,9 @@ static void ps3_sys_manager_final_power_
 		PS3_SM_WAKE_DEFAULT);
 	ps3_sys_manager_send_request_shutdown(dev);
 
-	printk(KERN_EMERG "System Halted, OK to turn off power\n");
+	pr_emerg("System Halted, OK to turn off power\n");
 
-	while(1)
+	while (1)
 		ps3_sys_manager_handle_msg(dev);
 }
 
@@ -626,9 +626,9 @@ static void ps3_sys_manager_final_restar
 		PS3_SM_WAKE_DEFAULT);
 	ps3_sys_manager_send_request_shutdown(dev);
 
-	printk(KERN_EMERG "System Halted, OK to turn off power\n");
+	pr_emerg("System Halted, OK to turn off power\n");
 
-	while(1)
+	while (1)
 		ps3_sys_manager_handle_msg(dev);
 }
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
