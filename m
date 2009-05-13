From: akpm@linux-foundation.org
Subject: [merged] pxa2xx_spi-prevent-panic-case-setup-fails.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:41 -0700
Message-ID: <200905131831.n4DIVfAo018484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759677AbZEMSf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drwyrm@gmail.com, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: prevent panic case setup() fails
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-prevent-panic-case-setup-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: prevent panic case setup() fails
From: Daniel Ribeiro <drwyrm@gmail.com>

setup() may fail before ctldata is set, causing a kernel panic on
cleanup().

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-prevent-panic-case-setup-fails drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-prevent-panic-case-setup-fails
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1373,6 +1373,9 @@ static void cleanup(struct spi_device *s
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if (!chip)
+		return;
+
 	if (gpio_is_valid(chip->gpio_cs))
 		gpio_free(chip->gpio_cs);
 
_

Patches currently in -mm which might be from drwyrm@gmail.com are

origin.patch
linux-next.patch
pxa2xx_spi-fix-for-spi_cs_high.patch

