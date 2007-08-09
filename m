From: akpm@linux-foundation.org
Subject: - 8139too-force-media-setting-fix.patch removed from -mm tree
Date: Thu, 09 Aug 2007 11:35:39 -0700
Message-ID: <200708091835.l79IZdlH013159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbXHISgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 14:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leewkb@yahoo.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     8139too: force media setting cleanup
has been removed from the -mm tree.  Its filename was
     8139too-force-media-setting-fix.patch

This patch was dropped because it was getting in the way of other things

------------------------------------------------------
Subject: 8139too: force media setting cleanup
From: Bernard Lee <leewkb@yahoo.com>

Setting bit 4 & 5 alone in 8139too module media option does not really
force 100Mbps full-duplex mode.  When media option bit 0-3 is cleared,
8139too module does not force media setting.  Therefore, bit 0-3 requires
to be set for bit 4 & 5 to take effect.  The hidden bit 0-3 setting is not
stated in module description.

It can be fixed by changing rtl8139_private structure default_port bitfield
from 4-bit to 6-bit.

Besides, module media bit 9 is a duplicate of bit 4 (full-duplex).  It is
suggested that bit 9 is freed.  A remark is added to module description
that bit 0 can be used to force setting.  It helps to clarify 10Mbps
half-duplex mode.

Signed-off-by: Bernard Lee <leewkb@yahoo.com>
Cc: Jeff Garzik <jeff@garzik.org>

Jeff sez:

The status of this patch is HOLD, and has been for months.

AFAICS this is a behavior change that differs from other Becker-derived 
drivers.  I would suggest looking at other drivers.

Furthermore, people should be using ethtool to set media.  Rather than 
changing the behavior of this module parameter to be non-standard, I 
feel it is better to (a) leave it as is or (b) remove it completely.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/8139too.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/8139too.c~8139too-force-media-setting-fix drivers/net/8139too.c
--- a/drivers/net/8139too.c~8139too-force-media-setting-fix
+++ a/drivers/net/8139too.c
@@ -598,7 +598,7 @@ struct rtl8139_private {
 	char			twistie, twist_row, twist_col;
 
 	unsigned int		watchdog_fired : 1;
-	unsigned int		default_port : 4; /* Last dev->if_port value. */
+	unsigned int default_port : 6;	/* Last dev->if_port value. */
 	unsigned int		have_thread : 1;
 
 	spinlock_t		lock;
@@ -627,7 +627,7 @@ module_param(debug, int, 0444);
 module_param(use_pio, int, 0444);
 
 MODULE_PARM_DESC (multicast_filter_limit, "8139too maximum number of filtered multicast addresses");
-MODULE_PARM_DESC (media, "8139too: Bits 4+9: force full duplex, bit 5: 100Mbps");
+MODULE_PARM_DESC (media, "8139too: bit 0: force setting, bit 4: full duplex, bit 5: 100Mbps");
 MODULE_PARM_DESC (full_duplex, "8139too: Force full duplex for board(s) (1)");
 MODULE_PARM_DESC (debug, "8139too bitmapped message enable number");
 MODULE_PARM_DESC (use_pio, "Non-zero to enable PIO (rather than MMIO) register mapping");
@@ -1051,8 +1051,8 @@ static int __devinit rtl8139_init_one (s
 	/* The lower four bits are the media type. */
 	option = (board_idx >= MAX_UNITS) ? 0 : media[board_idx];
 	if (option > 0) {
-		tp->mii.full_duplex = (option & 0x210) ? 1 : 0;
-		tp->default_port = option & 0xFF;
+		tp->mii.full_duplex = (option & 0x10) ? 1 : 0;
+		tp->default_port = option & 0x3F;
 		if (tp->default_port)
 			tp->mii.force_media = 1;
 	}
_

Patches currently in -mm which might be from leewkb@yahoo.com are

8139too-force-media-setting-fix.patch
