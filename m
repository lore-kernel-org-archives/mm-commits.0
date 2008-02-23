From: akpm@linux-foundation.org
Subject: + arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:36 -0800
Message-ID: <200802230731.m1N7VPwx017993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYBWHuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:50:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl


The patch titled
     arch/sh/drivers/heartbeat.c ioremap is expected to succeed
has been added to the -mm tree.  Its filename is
     arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch

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

ufs-fix-parenthesisation-in-ufs_set_fs_state.patch
git-alsa.patch
git-cifs.patch
git-dvb.patch
drivers-media-video-sn9c102-sn9c102_corec-fix-unlikelyx-==-y.patch
arch-sh-drivers-heartbeatc-ioremap-is-expected-to-succeed.patch
