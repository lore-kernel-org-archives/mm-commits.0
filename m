From: akpm@linux-foundation.org
Subject: + ps-2-serio-driver-for-avr32-devices-fix.patch added to -mm tree
Date: Fri, 07 Mar 2008 13:18:33 -0800
Message-ID: <200803072118.m27LIX3I017794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760319AbYCGVTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 16:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, dtor@mail.ru, hskinnemoen@atmel.com, jikos@jikos.cz


The patch titled
     ps-2-serio-driver-for-avr32-devices-fix
has been added to the -mm tree.  Its filename is
     ps-2-serio-driver-for-avr32-devices-fix.patch

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
Subject: ps-2-serio-driver-for-avr32-devices-fix
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/at32psif.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN drivers/input/serio/at32psif.c~ps-2-serio-driver-for-avr32-devices-fix drivers/input/serio/at32psif.c
--- a/drivers/input/serio/at32psif.c~ps-2-serio-driver-for-avr32-devices-fix
+++ a/drivers/input/serio/at32psif.c
@@ -23,10 +23,6 @@
 
 #define PSIF_BUF_SIZE		16
 
-#define ring_is_empty(_psif)	(_psif->head == _psif->tail)
-#define ring_next_head(_psif)	((_psif->head + 1) & (PSIF_BUF_SIZE - 1))
-#define ring_next_tail(_psif)	((_psif->tail + 1) & (PSIF_BUF_SIZE - 1))
-
 struct psif {
 	struct platform_device	*pdev;
 	struct clk		*pclk;
@@ -42,6 +38,21 @@ struct psif {
 	unsigned char		buffer[PSIF_BUF_SIZE];
 };
 
+static int ring_is_empty(struct psif *psif)
+{
+	return (psif->head == psif->tail);
+}
+
+static unsigned int ring_next_head(struct psif *psif)
+{
+	return ((psif->head + 1) & (PSIF_BUF_SIZE - 1));
+}
+
+static unsigned int ring_next_tail(struct psif *psif)
+{
+	return ((psif->tail + 1) & (PSIF_BUF_SIZE - 1));
+}
+
 static irqreturn_t psif_interrupt(int irq, void *_ptr)
 {
 	struct psif *psif = _ptr;
@@ -151,6 +162,11 @@ static void psif_close(struct serio *io)
 	psif_writel(psif, IDR, ~0UL);
 	psif_writel(psif, CR, PSIF_BIT(CR_TXDIS) | PSIF_BIT(CR_RXDIS));
 
+	del_timer_sync(&psif->tx_timer);
+
+	/* Reset circular buffer. */
+	psif->tail = psif->head;
+
 	clk_disable(psif->pclk);
 }
 
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-alsa.patch
git-avr32.patch
input-core-driver-for-wm97xx-touchscreens-update.patch
input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
ps-2-serio-driver-for-avr32-devices.patch
ps-2-serio-driver-for-avr32-devices-fix.patch
at73c213-fix-error-checking-for-clk-api.patch
at73c213-monaural-support.patch

