From: akpm@linux-foundation.org
Subject: - ps3av-add-quirk-database-for-broken-monitors.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:16 -0700
Message-ID: <200710162045.l9GKjGCw016246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965466AbXJPU47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ps3av: add quirk database for broken monitors
has been removed from the -mm tree.  Its filename was
     ps3av-add-quirk-database-for-broken-monitors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3av: add quirk database for broken monitors
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

add a quirk database for broken monitors where the `best' advertised
video mode doesn't work

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

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

origin.patch
