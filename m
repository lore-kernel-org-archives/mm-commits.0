From: akpm@linux-foundation.org
Subject: - arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:52 -0800
Message-ID: <200802272216.m1RMGqiq000753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbYB0WTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     arch/sh/drivers/heartbeat.c ioremap is expected to succeed
has been removed from the -mm tree.  Its filename was
     arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/sh/drivers/heartbeat.c ioremap is expected to succeed
From: Roel Kluin <12o3l@tiscali.nl>

ioremap is expected to succeed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/drivers/heartbeat.c~arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed arch/sh/drivers/heartbeat.c
--- a/arch/sh/drivers/heartbeat.c~arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed
+++ a/arch/sh/drivers/heartbeat.c
@@ -93,7 +93,7 @@ static int heartbeat_drv_probe(struct pl
 	}
 
 	hd->base = ioremap_nocache(res->start, res->end - res->start + 1);
-	if (!unlikely(hd->base)) {
+	if (unlikely(!hd->base)) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 
 		if (!pdev->dev.platform_data)
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-alsa.patch
git-cifs.patch
git-dvb.patch
git-sh.patch
