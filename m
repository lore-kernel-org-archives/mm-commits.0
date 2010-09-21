From: akpm@linux-foundation.org
Subject: + viafb-add-function-to-change-sync-polarity-per-device.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:17 -0700
Message-ID: <201009212237.o8LMbHlK006804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab0IUWlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: add function to change sync polarity per device
has been added to the -mm tree.  Its filename is
     viafb-add-function-to-change-sync-polarity-per-device.patch

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
Subject: viafb: add function to change sync polarity per device
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

At the moment only the sync polarity for CRT is handled but there are also
bits for controlling the sync polarity for other output devices.  Add a
function to change those similar to the other output device functions.

There is no runtime change yet as the code still handles only CRT.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c |   24 +++++++++++++++++++++---
 drivers/video/via/hw.h |    5 +++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-add-function-to-change-sync-polarity-per-device drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-add-function-to-change-sync-polarity-per-device
+++ a/drivers/video/via/hw.c
@@ -1151,6 +1151,24 @@ void via_set_state(u32 devices, u8 state
 		set_lvds2_state(state);
 }
 
+void via_set_sync_polarity(u32 devices, u8 polarity)
+{
+	if (polarity & ~(VIA_HSYNC_NEGATIVE | VIA_VSYNC_NEGATIVE)) {
+		printk(KERN_WARNING "viafb: Unsupported polarity: %d\n",
+			polarity);
+		return;
+	}
+
+	if (devices & VIA_CRT)
+		via_write_misc_reg_mask(polarity << 6, 0xC0);
+	if (devices & VIA_DVP1)
+		via_write_reg_mask(VIACR, 0x9B, polarity << 5, 0x60);
+	if (devices & VIA_LVDS1)
+		via_write_reg_mask(VIACR, 0x99, polarity << 5, 0x60);
+	if (devices & VIA_LVDS2)
+		via_write_reg_mask(VIACR, 0x97, polarity << 5, 0x60);
+}
+
 u32 via_parse_odev(char *input, char **end)
 {
 	char *ptr = input;
@@ -2026,10 +2044,10 @@ void viafb_fill_crtc_timing(struct crt_m
 
 	/* update polarity for CRT timing */
 	if (crt_table[index].h_sync_polarity == NEGATIVE)
-		polarity |= BIT6;
+		polarity |= VIA_HSYNC_NEGATIVE;
 	if (crt_table[index].v_sync_polarity == NEGATIVE)
-		polarity |= BIT7;
-	via_write_misc_reg_mask(polarity, BIT6 | BIT7);
+		polarity |= VIA_VSYNC_NEGATIVE;
+	via_set_sync_polarity(VIA_CRT, polarity);
 
 	if (set_iga == IGA1) {
 		viafb_unlock_crt();
diff -puN drivers/video/via/hw.h~viafb-add-function-to-change-sync-polarity-per-device drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-add-function-to-change-sync-polarity-per-device
+++ a/drivers/video/via/hw.h
@@ -47,6 +47,10 @@
 #define VIA_STATE_SUSPEND	2
 #define VIA_STATE_OFF		3
 
+/* VIA output device sync polarity */
+#define VIA_HSYNC_NEGATIVE	0x01
+#define VIA_VSYNC_NEGATIVE	0x02
+
 /***************************************************
 * Definition IGA1 Design Method of CRTC Registers *
 ****************************************************/
@@ -912,6 +916,7 @@ void viafb_load_reg(int timing_value, in
 	      int io_type);
 void via_set_source(u32 devices, u8 iga);
 void via_set_state(u32 devices, u8 state);
+void via_set_sync_polarity(u32 devices, u8 polarity);
 u32 via_parse_odev(char *input, char **end);
 void via_odev_to_seq(struct seq_file *m, u32 odev);
 void init_ad9389(void);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch

