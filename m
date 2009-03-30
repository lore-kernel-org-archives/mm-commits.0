From: akpm@linux-foundation.org
Subject: [merged] nand-fix-broken-debug-messages.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:57 -0700
Message-ID: <200903301905.n2UJ5vZH018913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759216AbZC3TKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     NAND: fix broken debug messages
has been removed from the -mm tree.  Its filename was
     nand-fix-broken-debug-messages.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: NAND: fix broken debug messages
=46rom: David Brownell <dbrownell@users.sourceforge.net>

=46ix incorrect debug messages (*write* not read); someone committed so=
me
cut'n'paste bugs.  =A0There might be more, I only noticed these since I=
 was
looking for nand_read usage and landed in some very wrong functions.

IMO all MTD debugging message framework is goofed, anyway.  It uses
"DEBUG" in a way that's incompatible with usage most everywhere else in
the kernel, and which prevents normal pr_dbg() and dev_dbg() calls from
working right.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~nand-fix-broken-debug-messages d=
rivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~nand-fix-broken-debug-messages
+++ a/drivers/mtd/nand/nand_base.c
@@ -1946,7 +1946,7 @@ static int nand_do_write_oob(struct mtd_
 	}
=20
 	if (unlikely(ops->ooboffs >=3D len)) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_do_write_oob: "
 			"Attempt to start write outside oob\n");
 		return -EINVAL;
 	}
@@ -1956,7 +1956,7 @@ static int nand_do_write_oob(struct mtd_
 		     ops->ooboffs + ops->ooblen >
 			((mtd->size >> chip->page_shift) -
 			 (to >> chip->page_shift)) * len)) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_do_write_oob: "
 			"Attempt write beyond end of device\n");
 		return -EINVAL;
 	}
@@ -2012,8 +2012,8 @@ static int nand_write_oob(struct mtd_inf
=20
 	/* Do not allow writes past end of device */
 	if (ops->datbuf && (to + ops->len) > mtd->size) {
-		DEBUG(MTD_DEBUG_LEVEL0, "nand_read_oob: "
-		      "Attempt read beyond end of device\n");
+		DEBUG(MTD_DEBUG_LEVEL0, "nand_write_oob: "
+		      "Attempt write beyond end of device\n");
 		return -EINVAL;
 	}
=20
_

Patches currently in -mm which might be from dbrownell@users.sourceforg=
e.net are

origin.patch
linux-next.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-b=
ytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deass=
ert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_chan=
ge.patch
spi-limit-reaches-1-tested-0.patch
rtc-ds1307-true-smbus-compatibility.patch
gpio-gpio_requestfree-now-required-feature-removal.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
