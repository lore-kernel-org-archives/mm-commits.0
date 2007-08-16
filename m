From: akpm@linux-foundation.org
Subject: + ps3-fix-no-storage-devices-found.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:24:50 -0700
Message-ID: <200708162024.l7GKOo1m005135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbXHPUZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, paulus@samba.org


The patch titled
     ps3: fix no storage devices found
has been added to the -mm tree.  Its filename is
     ps3-fix-no-storage-devices-found.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3: fix no storage devices found
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Fix probing of PS3 storage devices: in the success case, we should set
`error' to zero, not `result'.

Without this patch no storage devices are found.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/device-init.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/ps3/device-init.c~ps3-fix-no-storage-devices-found arch/powerpc/platforms/ps3/device-init.c
--- a/arch/powerpc/platforms/ps3/device-init.c~ps3-fix-no-storage-devices-found
+++ a/arch/powerpc/platforms/ps3/device-init.c
@@ -372,7 +372,7 @@ static int ps3_storage_wait_for_device(c
 		    notify_event->dev_type == repo->dev_type) {
 			pr_debug("%s:%u: device ready: dev_id %u\n", __func__,
 				 __LINE__, repo->dev_id);
-			result = 0;
+			error = 0;
 			break;
 		}
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

ps3-fix-no-storage-devices-found.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
