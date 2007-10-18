From: akpm@linux-foundation.org
Subject: + ps3av-remove-unused-fields-in-ps3av_monitor_quirks.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:14:57 -0700
Message-ID: <200710182114.l9ILEvVZ031501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759788AbXJRVPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3av: remove unused fields in ps3av_monitor_quirks
has been added to the -mm tree.  Its filename is
     ps3av-remove-unused-fields-in-ps3av_monitor_quirks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3av: remove unused fields in ps3av_monitor_quirks
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Remove the `clear_50' and `clear_vesa' fields of struct
ps3av_monitor_quirk, as they're currently unused.  We can always re-add
them when we really need them.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/ps3av.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/ps3/ps3av.c~ps3av-remove-unused-fields-in-ps3av_monitor_quirks drivers/ps3/ps3av.c
--- a/drivers/ps3/ps3av.c~ps3av-remove-unused-fields-in-ps3av_monitor_quirks
+++ a/drivers/ps3/ps3av.c
@@ -729,7 +729,7 @@ static void ps3av_monitor_info_dump(cons
 
 static const struct ps3av_monitor_quirk {
 	const char *monitor_name;
-	u32 clear_60, clear_50, clear_vesa;
+	u32 clear_60;
 } ps3av_monitor_quirks[] = {
 	{
 		.monitor_name	= "DELL 2007WFP",
@@ -757,10 +757,6 @@ static void ps3av_fixup_monitor_info(str
 				quirk->monitor_name);
 			info->res_60.res_bits &= ~quirk->clear_60;
 			info->res_60.native &= ~quirk->clear_60;
-			info->res_50.res_bits &= ~quirk->clear_50;
-			info->res_50.native &= ~quirk->clear_50;
-			info->res_vesa.res_bits &= ~quirk->clear_vesa;
-			info->res_vesa.native &= ~quirk->clear_vesa;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fb-modedb-refactor-confusing-mode_option-assignment.patch
ps3av-remove-unused-fields-in-ps3av_monitor_quirks.patch
