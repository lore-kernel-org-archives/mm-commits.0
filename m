From: akpm@linux-foundation.org
Subject: [merged] media-dvb-siano-fix-memory-leak.patch removed from -mm tree
Date: Thu, 14 Jan 2010 13:20:44 -0800
Message-ID: <201001142120.o0ELKig7031623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab0ANVVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 16:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mchehab@infradead.org, mkrufky@linuxtv.org, uris@siano-ms.com, mm-commits@vger.kernel.org


The patch titled
     media: dvb/siano, fix memory leak
has been removed from the -mm tree.  Its filename was
     media-dvb-siano-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media: dvb/siano, fix memory leak
From: Jiri Slaby <jslaby@suse.cz>

Stanse found a memory leak in smscore_gpio_configure. buffer is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Uri Shkolnik <uris@siano-ms.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/siano/smscoreapi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/siano/smscoreapi.c~media-dvb-siano-fix-memory-leak drivers/media/dvb/siano/smscoreapi.c
--- a/drivers/media/dvb/siano/smscoreapi.c~media-dvb-siano-fix-memory-leak
+++ a/drivers/media/dvb/siano/smscoreapi.c
@@ -1459,8 +1459,10 @@ int smscore_gpio_configure(struct smscor
 	if (!(coredev->device_flags & SMS_DEVICE_FAMILY2)) {
 		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_REQ;
 		if (GetGpioPinParams(PinNum, &TranslatedPinNum, &GroupNum,
-				&groupCfg) != 0)
-			return -EINVAL;
+				&groupCfg) != 0) {
+			rc = -EINVAL;
+			goto free;
+		}
 
 		pMsg->msgData[1] = TranslatedPinNum;
 		pMsg->msgData[2] = GroupNum;
@@ -1490,6 +1492,7 @@ int smscore_gpio_configure(struct smscor
 		else
 			sms_err("smscore_gpio_configure error");
 	}
+free:
 	kfree(buffer);
 
 	return rc;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
infiniband-use-rlimit-helpers.patch
char-synclink-remove-unnecessary-checks.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

