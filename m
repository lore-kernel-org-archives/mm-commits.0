From: akpm@linux-foundation.org
Subject: + parport_serial-fix-array-overflow.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:16:29 -0800
Message-ID: <200811212216.mALMGT0j018752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbYKUWQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de


The patch titled
     parport_serial: fix array overflow
has been added to the -mm tree.  Its filename is
     parport_serial-fix-array-overflow.patch

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
Subject: parport_serial: fix array overflow
From: Takashi Iwai <tiwai@suse.de>

The netmos_9xx5_combo type assumes that PCI SSID provides always the
correct value for the number of parallel and serial ports, but there are
indeed broken devices with wrong numbers, which may result in Oops.

This patch simply adds the check of the array range.

Reference: Novell bnc#447067
	https://bugzilla.novell.com/show_bug.cgi?id=447067

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_serial.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/parport/parport_serial.c~parport_serial-fix-array-overflow drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport_serial-fix-array-overflow
+++ a/drivers/parport/parport_serial.c
@@ -70,6 +70,8 @@ static int __devinit netmos_parallel_ini
 	 * parallel ports and <S> is the number of serial ports.
 	 */
 	card->numports = (dev->subsystem_device & 0xf0) >> 4;
+	if (card->numports > ARRAY_SIZE(card->addr))
+		card->numports = ARRAY_SIZE(card->addr);
 	return 0;
 }
 
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
parport_serial-fix-array-overflow.patch
linux-next.patch
check-fops_get-return-value.patch

