From: akpm@linux-foundation.org
Subject: + mtd-maps-physmap-fix-oops-in-suspend-resume-shutdown-ops.patch added to -mm tree
Date: Thu, 27 Mar 2008 14:29:54 -0700
Message-ID: <200803272129.m2RLTsbI022876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758371AbYC0VbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 17:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, david-b@pacbell.net, dwmw2@infradead.org


The patch titled
     mtd: maps/physmap: fix oops in suspend/resume/shutdown ops
has been added to the -mm tree.  Its filename is
     mtd-maps-physmap-fix-oops-in-suspend-resume-shutdown-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: maps/physmap: fix oops in suspend/resume/shutdown ops
From: Anton Vorontsov <cbouatmailru@gmail.com>

# reboot
...
[   42.351266] Flash device refused suspend due to active operation (state 0)
[   42.358195] Unable to handle kernel NULL pointer dereference at virtual address 00000078
[   42.360060] pgd = c7d9c000
[   42.362769] [00000078] *pgd=a7d8d031, *pte=00000000, *ppte=00000000
[   42.372902] Internal error: Oops: 17 [#1]
[   42.376911] Modules linked in:
[   42.379980] CPU: 0    Not tainted  (2.6.25-rc2-10642-ge8f2594-dirty #73)
[   42.380000] PC is at physmap_flash_shutdown+0x28/0x54
...
[   42.380000] Backtrace:
[   42.380000] [<c0130c1c>] (physmap_flash_shutdown+0x0/0x54) from [<c01207c0>] (platform_drv_shutdown+0x20/0x24)
[   42.380000]  r5:28121969 r4:c0229e08
[   42.380000] [<c01207a0>] (platform_drv_shutdown+0x0/0x24) from [<c011cd40>] (device_shutdown+0x60/0x88)
[   42.380000] [<c011cce0>] (device_shutdown+0x0/0x88) from [<c003e8a4>] (kernel_restart_prepare+0x2c/0x3c)
[   42.380000]  r4:00000000
[   42.380000] [<c003e878>] (kernel_restart_prepare+0x0/0x3c) from [<c003ea00>] (kernel_restart+0x14/0x48)
[   42.380000] [<c003e9ec>] (kernel_restart+0x0/0x48) from [<c003fdc0>] (sys_reboot+0xe8/0x1f8)
[   42.380000]  r4:01234567
[   42.380000] [<c003fcd8>] (sys_reboot+0x0/0x1f8) from [<c001aa00>] (ret_fast_syscall+0x0/0x2c)
[   42.380000]  r7:00000058 r6:00000004 r5:00000001 r4:00000000
[   42.380000] Code: 0a000009 e7953004 e1a00003 e1a0e00f (e593f078)
[   42.650051] ---[ end trace 6d6c26a0fc3141de ]---
Segmentation fault
INIT: no more processes left in this runlevel


While looping for mtd[i]s, we should stop at the mtd[i] == NULL.

This patch also removes unnecessary "if (info)" checks:
suspend/resume/shutdown ops are executed only if probe() is succeeded, so info
is guaranteed to be !NULL.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~mtd-maps-physmap-fix-oops-in-suspend-resume-shutdown-ops drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-maps-physmap-fix-oops-in-suspend-resume-shutdown-ops
+++ a/drivers/mtd/maps/physmap.c
@@ -202,9 +202,8 @@ static int physmap_flash_suspend(struct 
 	int ret = 0;
 	int i;
 
-	if (info)
-		for (i = 0; i < MAX_RESOURCES; i++)
-			ret |= info->mtd[i]->suspend(info->mtd[i]);
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		ret |= info->mtd[i]->suspend(info->mtd[i]);
 
 	return ret;
 }
@@ -214,9 +213,9 @@ static int physmap_flash_resume(struct p
 	struct physmap_flash_info *info = platform_get_drvdata(dev);
 	int i;
 
-	if (info)
-		for (i = 0; i < MAX_RESOURCES; i++)
-			info->mtd[i]->resume(info->mtd[i]);
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		info->mtd[i]->resume(info->mtd[i]);
+
 	return 0;
 }
 
@@ -225,8 +224,8 @@ static void physmap_flash_shutdown(struc
 	struct physmap_flash_info *info = platform_get_drvdata(dev);
 	int i;
 
-	for (i = 0; i < MAX_RESOURCES; i++)
-		if (info && info->mtd[i]->suspend(info->mtd[i]) == 0)
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		if (info->mtd[i]->suspend(info->mtd[i]) == 0)
 			info->mtd[i]->resume(info->mtd[i]);
 }
 #else
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

mtd-maps-physmap-fix-oops-in-suspend-resume-shutdown-ops.patch

