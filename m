From: akpm@linux-foundation.org
Subject: - spi-spidev-check-message-size-before-copying.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:47 -0700
Message-ID: <200705291850.l4TIok7m008295@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbXE2SvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: domen.puncer@telargo.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi/spidev: check message size before copying
has been removed from the -mm tree.  Its filename was
     spi-spidev-check-message-size-before-copying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi/spidev: check message size before copying
From: Domen Puncer <domen.puncer@telargo.com>

Message size needs to be checked before copying, or bad things could
happen.

Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spidev.c~spi-spidev-check-message-size-before-copying drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-spidev-check-message-size-before-copying
+++ a/drivers/spi/spidev.c
@@ -168,6 +168,12 @@ static int spidev_message(struct spidev_
 			n--, k_tmp++, u_tmp++) {
 		k_tmp->len = u_tmp->len;
 
+		total += k_tmp->len;
+		if (total > bufsiz) {
+			status = -EMSGSIZE;
+			goto done;
+		}
+
 		if (u_tmp->rx_buf) {
 			k_tmp->rx_buf = buf;
 			if (!access_ok(VERIFY_WRITE, u_tmp->rx_buf, u_tmp->len))
@@ -179,12 +185,6 @@ static int spidev_message(struct spidev_
 					u_tmp->len))
 				goto done;
 		}
-
-		total += k_tmp->len;
-		if (total > bufsiz) {
-			status = -EMSGSIZE;
-			goto done;
-		}
 		buf += k_tmp->len;
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
_

Patches currently in -mm which might be from domen.puncer@telargo.com are
