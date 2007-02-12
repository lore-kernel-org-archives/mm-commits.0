From: akpm@linux-foundation.org
Subject: - ps3-disable-display-flipping-during-mode-changes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:26 -0800
Message-ID: <200702122250.l1CMoQkh014221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030407AbXBLWu4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3: disable display flipping during mode changes
has been removed from the -mm tree.  Its filename was
     ps3-disable-display-flipping-during-mode-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: disable display flipping during mode changes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

If ps3fb is available, we have to disable display flipping while changing the
audio or video mode.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av_cmd.c     |    5 ++++-
 include/asm-powerpc/ps3fb.h |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/ps3/ps3av_cmd.c~ps3-disable-display-flipping-during-mode-changes drivers/ps3/ps3av_cmd.c
--- a/drivers/ps3/ps3av_cmd.c~ps3-disable-display-flipping-during-mode-changes
+++ a/drivers/ps3/ps3av_cmd.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <asm/ps3av.h>
+#include <asm/ps3fb.h>
 #include <asm/ps3.h>
 
 #include "vuart.h"
@@ -851,8 +852,9 @@ int ps3av_cmd_avb_param(struct ps3av_pkt
 {
 	int res;
 
-	/* avb packet */
+	ps3fb_flip_ctl(0);	/* flip off */
 
+	/* avb packet */
 	res = ps3av_do_pkt(PS3AV_CID_AVB_PARAM, send_len, sizeof(*avb),
 			   &avb->send_hdr);
 	if (res < 0)
@@ -864,6 +866,7 @@ int ps3av_cmd_avb_param(struct ps3av_pkt
 			 res);
 
       out:
+	ps3fb_flip_ctl(1);	/* flip on */
 	return res;
 }
 
diff -puN include/asm-powerpc/ps3fb.h~ps3-disable-display-flipping-during-mode-changes include/asm-powerpc/ps3fb.h
--- a/include/asm-powerpc/ps3fb.h~ps3-disable-display-flipping-during-mode-changes
+++ a/include/asm-powerpc/ps3fb.h
@@ -41,4 +41,14 @@ struct ps3fb_ioctl_res {
 	__u32 num_frames; /* num of frame buffers */
 };
 
+#ifdef __KERNEL__
+
+#ifdef CONFIG_FB_PS3
+extern void ps3fb_flip_ctl(int on);
+#else
+static inline void ps3fb_flip_ctl(int on) {}
+#endif
+
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_POWERPC_PS3FB_H_ */
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
