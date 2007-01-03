From: akpm@osdl.org
Subject: + edac-e752x-byte-access-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 16:38:31 -0800
Message-ID: <200701030038.l030cV6u002898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbXACAis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bapper@mvista.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, djiang@mvista.com, ebiederm@xmission.com, norsk5@xmission.com


The patch titled
     EDAC: e752x byte access fix
has been added to the -mm tree.  Its filename is
     edac-e752x-byte-access-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: e752x byte access fix
From: Brian Pomerantz <bapper@mvista.com>

The reading of the DRA registers should be a byte at a time (one register at a
time) instead of 4 bytes at a time (four registers).  Reading a dword at a
time retrieves erroneous information from all but the first register.  A
change was made to read in each register in a loop prior to using the data in
those registers.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <norsk5@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/e752x_edac.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/edac/e752x_edac.c~edac-e752x-byte-access-fix drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-e752x-byte-access-fix
+++ a/drivers/edac/e752x_edac.c
@@ -782,7 +782,12 @@ static void e752x_init_csrows(struct mem
 	u8 value;
 	u32 dra, drc, cumul_size;
 
-	pci_read_config_dword(pdev, E752X_DRA, &dra);
+	dra = 0;
+	for (index=0; index < 4; index++) {
+		u8 dra_reg;
+		pci_read_config_byte(pdev, E752X_DRA+index, &dra_reg);
+		dra |= dra_reg << (index * 8);
+	}
 	pci_read_config_dword(pdev, E752X_DRC, &drc);
 	drc_chan = dual_channel_active(ddrcsr);
 	drc_drbg = drc_chan + 1;  /* 128 in dual mode, 64 in single */
_

Patches currently in -mm which might be from bapper@mvista.com are

edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
