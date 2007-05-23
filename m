From: akpm@linux-foundation.org
Subject: + spi-spidev-check-message-size-before-copying.patch added to -mm tree
Date: Wed, 23 May 2007 11:07:16 -0700
Message-ID: <200705231807.l4NI7FcZ028782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758512AbXEWSHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: domen.puncer@telargo.com, dbrownell@users.sourceforge.net


The patch titled
     spi/spidev: check message size before copying
has been added to the -mm tree.  Its filename is
     spi-spidev-check-message-size-before-copying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 6 insertions(+), 6 deletions(-)

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

mpc52xx_psc_spi-fix-it-for-config_ppc_merge.patch
spi-spidev-check-message-size-before-copying.patch
