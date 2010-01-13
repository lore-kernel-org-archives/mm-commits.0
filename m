From: akpm@linux-foundation.org
Subject: + media-dvb-siano-fix-memory-leak.patch added to -mm tree
Date: Wed, 13 Jan 2010 13:35:11 -0800
Message-ID: <201001132135.o0DLZBbK029864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0AMVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 16:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, mchehab@infradead.org, mkrufky@linuxtv.org, uris@siano-ms.com


The patch titled
     media: dvb/siano, fix memory leak
has been added to the -mm tree.  Its filename is
     media-dvb-siano-fix-memory-leak.patch

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

linux-next.patch
media-dvb-siano-fix-memory-leak.patch
media-video-tuner-core-fix-memory-leak.patch
infiniband-use-rlimit-helpers.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

