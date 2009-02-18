From: akpm@linux-foundation.org
Subject: [merged] libata-sff-fix-32-bit-pio-regression.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:14:03 -0800
Message-ID: <200902181014.n1IAE3uA006164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZBRKPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:15:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, Larry.Finger@lwfinger.net, alan@lxorguk.ukuu.org.uk, hugh@veritas.com, jeff@garzik.org, mikpe@it.uu.se, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     libata-sff: fix 32-bit PIO regression
has been removed from the -mm tree.  Its filename was
     libata-sff-fix-32-bit-pio-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata-sff: fix 32-bit PIO regression
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Commit 871af1210f13966ab911ed2166e4ab2ce775b99d ("libata: Add 32bit PIO
support") caused all kind of errors on the ATAPI devices, so it's been
empirically proven that one shouldn't read/write an extra data word when a
device isn't expecting it already.  "Don't do it then"; however still
taking a chance to use 32-bit I/O one last time when there are exactly 3
trailing bytes.  Oh, and stop pointless swapping bytes to and fro as well
by using io*_rep() which shouldn't byte-swap.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12609

akpm: needs signoff

akpm: awaiting a commented update, "along with the patch cleaning up
      the corresponding fragment of the 16-bit I/O method."

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hugh Dickins <hugh@veritas.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-fix-32-bit-pio-regression drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-fix-32-bit-pio-regression
+++ a/drivers/ata/libata-sff.c
@@ -773,18 +773,27 @@ unsigned int ata_sff_data_xfer32(struct 
 	else
 		iowrite32_rep(data_addr, buf, words);
 
+	/* Transfer trailing bytes, if any */
 	if (unlikely(slop)) {
-		__le32 pad;
+		unsigned char pad[4];
+
+		/* Point buf to the tail of buffer */
+		buf += buflen - slop;
 		if (rw == READ) {
-			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-			memcpy(buf + buflen - slop, &pad, slop);
+			if (slop < 3)
+				ioread16_rep(data_addr, pad, 1);
+			else
+				ioread32_rep(data_addr, pad, 1);
+			memcpy(buf, pad, slop);
 		} else {
-			memcpy(&pad, buf + buflen - slop, slop);
-			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
+			memcpy(pad, buf, slop);
+			if (slop < 3)
+				iowrite16_rep(data_addr, pad, 1);
+			else
+				iowrite32_rep(data_addr, pad, 1);
 		}
-		words++;
 	}
-	return words << 2;
+	return (buflen + 1) & ~1;
 }
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
linux-next.patch
3x59x-fix-pci-resource-management.patch

