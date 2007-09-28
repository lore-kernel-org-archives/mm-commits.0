From: akpm@linux-foundation.org
Subject: + fix-amd-mips-alchemy-au1550-i2c-interface.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:04:23 -0700
Message-ID: <200709280604.l8S64N2R013801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbXI1GFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cd@chrisdavid.com, domen.puncer@ultra.si, jordan.crouse@amd.com, khali@linux-fr.org, ralf@linux-mips.org


The patch titled
     Fix AMD MIPS Alchemy au1550 I2C interface
has been added to the -mm tree.  Its filename is
     fix-amd-mips-alchemy-au1550-i2c-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix AMD MIPS Alchemy au1550 I2C interface
From: "Chris David" <cd@chrisdavid.com>

Fix a problem on the AMD MIPS Alchemy au1550 I2C interface.  The PSC
(programmable serial controller) seem to 'hang' when I sent only an
'address' byte on the I2C bus.  The patch essentially uses the PSC_SMBSTAT
register's TE (transmit FIFO empty) bit to check when the transmit FIFO is
empty, instead of using the PSC_SMBEVNT register's TU (transmit underflow)
bit.  Using the TE bit fixed the hang problem.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Domen Puncer <domen.puncer@ultra.si>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-au1550.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/i2c/busses/i2c-au1550.c~fix-amd-mips-alchemy-au1550-i2c-interface drivers/i2c/busses/i2c-au1550.c
--- a/drivers/i2c/busses/i2c-au1550.c~fix-amd-mips-alchemy-au1550-i2c-interface
+++ a/drivers/i2c/busses/i2c-au1550.c
@@ -48,17 +48,14 @@ wait_xfer_done(struct i2c_au1550_data *a
 
 	sp = (volatile psc_smb_t *)(adap->psc_base);
 
-	/* Wait for Tx FIFO Underflow.
+	/* Wait for Tx Buffer Empty
 	*/
 	for (i = 0; i < adap->xfer_timeout; i++) {
-		stat = sp->psc_smbevnt;
+		stat = sp->psc_smbstat;
 		au_sync();
-		if ((stat & PSC_SMBEVNT_TU) != 0) {
-			/* Clear it.  */
-			sp->psc_smbevnt = PSC_SMBEVNT_TU;
-			au_sync();
+		if ((stat & PSC_SMBSTAT_TE) != 0)
 			return 0;
-		}
+
 		udelay(1);
 	}
 
_

Patches currently in -mm which might be from cd@chrisdavid.com are

fix-amd-mips-alchemy-au1550-i2c-interface.patch
