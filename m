From: akpm@linux-foundation.org
Subject: - parport_serial-fix-array-overflow.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:20 -0800
Message-ID: <200812021838.mB2IcKk7006851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbYLBSic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     parport_serial: fix array overflow
has been removed from the -mm tree.  Its filename was
     parport_serial-fix-array-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@kernel.org>
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

linux-next.patch
check-fops_get-return-value.patch
remove-lots-of-double-semicolons.patch

