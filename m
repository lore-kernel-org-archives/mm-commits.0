From: akpm@linux-foundation.org
Subject: [merged] spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:21 -0700
Message-ID: <200906171832.n5HIWLl3030948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759109AbZFQSdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     spi: takes size of a pointer to determine the size of the pointed-to type
has been removed from the -mm tree.  Its filename was
     spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: takes size of a pointer to determine the size of the pointed-to type
From: Roel Kluin <roel.kluin@gmail.com>

Do not take the size of a pointer to determine the size of the pointed-to
type.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type
+++ a/drivers/spi/spi_mpc83xx.c
@@ -711,12 +711,12 @@ static int of_mpc83xx_spi_get_chipselect
 		return 0;
 	}
 
-	pinfo->gpios = kmalloc(ngpios * sizeof(pinfo->gpios), GFP_KERNEL);
+	pinfo->gpios = kmalloc(ngpios * sizeof(*pinfo->gpios), GFP_KERNEL);
 	if (!pinfo->gpios)
 		return -ENOMEM;
-	memset(pinfo->gpios, -1, ngpios * sizeof(pinfo->gpios));
+	memset(pinfo->gpios, -1, ngpios * sizeof(*pinfo->gpios));
 
-	pinfo->alow_flags = kzalloc(ngpios * sizeof(pinfo->alow_flags),
+	pinfo->alow_flags = kzalloc(ngpios * sizeof(*pinfo->alow_flags),
 				    GFP_KERNEL);
 	if (!pinfo->alow_flags) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
spi_bfin5xx-limit-reaches-1.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

