From: akpm@linux-foundation.org
Subject: - edac-e752x-byte-access-fix.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:45:38 -0800
Message-ID: <200702122245.l1CMjcZG013728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030300AbXBLWpw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bapper@mvista.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, djiang@mvista.com, ebiederm@xmission.com, norsk5@xmission.com, mm-commits@vger.kernel.org


The patch titled
     EDAC: e752x byte access fix
has been removed from the -mm tree.  Its filename was
     edac-e752x-byte-access-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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

origin.patch
