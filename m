From: akpm@linux-foundation.org
Subject: - ath5k-panic-fix.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:10 -0700
Message-ID: <200709202117.l8KLHA7p003060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbXITV31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, jirislaby@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Ath5k panic fix
has been removed from the -mm tree.  Its filename was
     ath5k-panic-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Ath5k panic fix
From: Krzysztof Halasa <khc@pm.waw.pl>

Ath5k panics on ath_open() because sc->pdev is never set, fixed.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k_base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/ath5k_base.c~ath5k-panic-fix drivers/net/wireless/ath5k_base.c
--- a/drivers/net/wireless/ath5k_base.c~ath5k-panic-fix
+++ a/drivers/net/wireless/ath5k_base.c
@@ -2297,6 +2297,7 @@ static int __devinit ath_pci_probe(struc
 	hw->max_rssi = 127; /* FIXME: get a real value for this. */
 	sc = hw->priv;
 	sc->hw = hw;
+	sc->pdev = pdev;
 
 	/*
 	 * Mark the device as detached to avoid processing
_

Patches currently in -mm which might be from khc@pm.waw.pl are

git-wireless.patch
intel-fb-support-for-interlaced-video-modes.patch
