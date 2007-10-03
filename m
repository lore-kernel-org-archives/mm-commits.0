From: akpm@linux-foundation.org
Subject: + ps3av-add-quirk-database-for-broken-monitors.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:22 -0700
Message-ID: <200710032053.l93KrMYP008104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756902AbXJCUx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com


The patch titled
     ps3av: add quirk database for broken monitors
has been added to the -mm tree.  Its filename is
     ps3av-add-quirk-database-for-broken-monitors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: add quirk database for broken monitors
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

add a quirk database for broken monitors where the `best' advertised
video mode doesn't work

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ps3/ps3av.c~ps3av-add-quirk-database-for-broken-monitors drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-add-quirk-database-for-broken-monitors
+++ a/drivers/ps3/ps3av.c
@@ -721,6 +721,45 @@ static void ps3av_monitor_info_dump(cons
 	}
 }
 
+static const struct ps3av_monitor_quirk {
+	const char *monitor_name;
+	u32 clear_60, clear_50, clear_vesa;
+} ps3av_monitor_quirks[] = {
+	{
+		.monitor_name	= "DELL 2007WFP",
+		.clear_60	= PS3AV_RESBIT_1920x1080I
+	}, {
+		.monitor_name	= "L226WTQ",
+		.clear_60	= PS3AV_RESBIT_1920x1080I |
+				  PS3AV_RESBIT_1920x1080P
+	}, {
+		.monitor_name	= "SyncMaster",
+		.clear_60	= PS3AV_RESBIT_1920x1080I
+	}
+};
+
+static void ps3av_fixup_monitor_info(struct ps3av_info_monitor *info)
+{
+	unsigned int i;
+	const struct ps3av_monitor_quirk *quirk;
+
+	for (i = 0; i < ARRAY_SIZE(ps3av_monitor_quirks); i++) {
+		quirk = &ps3av_monitor_quirks[i];
+		if (!strncmp(info->monitor_name, quirk->monitor_name,
+			     sizeof(info->monitor_name))) {
+			pr_info("%s: Applying quirk for %s\n", __func__,
+				quirk->monitor_name);
+			info->res_60.res_bits &= ~quirk->clear_60;
+			info->res_60.native &= ~quirk->clear_60;
+			info->res_50.res_bits &= ~quirk->clear_50;
+			info->res_50.native &= ~quirk->clear_50;
+			info->res_vesa.res_bits &= ~quirk->clear_vesa;
+			info->res_vesa.native &= ~quirk->clear_vesa;
+			break;
+		}
+	}
+}
+
 static int ps3av_auto_videomode(struct ps3av_pkt_av_get_hw_conf *av_hw_conf,
 				int boot)
 {
@@ -739,6 +778,8 @@ static int ps3av_auto_videomode(struct p
 		ps3av_monitor_info_dump(&monitor_info);
 
 		info = &monitor_info.info;
+		ps3av_fixup_monitor_info(info);
+
 		switch (info->monitor_type) {
 		case PS3AV_MONITOR_TYPE_DVI:
 			dvi = PS3AV_MODE_DVI;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
