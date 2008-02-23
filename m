From: akpm@linux-foundation.org
Subject: + fix-uli526x-partially-recognizing-interface.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:11 -0800
Message-ID: <200802230731.m1N7V0ZT017975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763781AbYBWIEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, manty@manty.net, pozsy@uhulinux.hu, protasnb@gmail.com


The patch titled
     fix uli526x partially recognizing interface
has been added to the -mm tree.  Its filename is
     fix-uli526x-partially-recognizing-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix uli526x partially recognizing interface
From: Grant Grundler <grundler@parisc-linux.org>

Patch fixes:
    http://bugzilla.kernel.org/show_bug.cgi?id=5839

Init sequence needs to poll phy until phy reset is complete. This is the
same problem that I fixed in 2002 in tulip driver.

Thanks to manty@manty.net for testing this patch.
Thanks to Pozsar Balazs <pozsy@uhulinux.hu> for posting/testing
a similar patch before:
    http://lkml.org/lkml/2006/8/21/45

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Cc: <manty@manty.net>
Cc: Pozsar Balazs <pozsy@uhulinux.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Natalie Protasevich <protasnb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/uli526x.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/net/tulip/uli526x.c~fix-uli526x-partially-recognizing-interface drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~fix-uli526x-partially-recognizing-interface
+++ a/drivers/net/tulip/uli526x.c
@@ -482,9 +482,11 @@ static void uli526x_init(struct net_devi
 	struct uli526x_board_info *db = netdev_priv(dev);
 	unsigned long ioaddr = db->ioaddr;
 	u8	phy_tmp;
+	u8	timeout;
 	u16	phy_value;
 	u16 phy_reg_reset;
 
+
 	ULI526X_DBUG(0, "uli526x_init()", 0);
 
 	/* Reset M526x MAC controller */
@@ -509,11 +511,19 @@ static void uli526x_init(struct net_devi
 	/* Parser SROM and media mode */
 	db->media_mode = uli526x_media_mode;
 
-	/* Phyxcer capability setting */
+	/* phyxcer capability setting */
 	phy_reg_reset = phy_read(db->ioaddr, db->phy_addr, 0, db->chip_id);
 	phy_reg_reset = (phy_reg_reset | 0x8000);
 	phy_write(db->ioaddr, db->phy_addr, 0, phy_reg_reset, db->chip_id);
+
+	/* See IEEE 802.3-2002.pdf (Section 2, Chapter "22.2.4 Management
+	 * functions") or phy data sheet for details on phy reset
+	 */
 	udelay(500);
+	timeout = 10;
+	while (timeout-- &&
+		phy_read(db->ioaddr, db->phy_addr, 0, db->chip_id) & 0x8000)
+			udelay(100);
 
 	/* Process Phyxcer Media Mode */
 	uli526x_set_phyxcer(db);
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

fix-uli526x-partially-recognizing-interface.patch
update-tulip-maintainers.patch
parisc-new-termios-definitions.patch
