From: akpm@linux-foundation.org
Subject: - pcmcia-3c574_cs-fix-shadow-variable-warning.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:10 -0800
Message-ID: <200802052226.m15MQpLH011655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbYBEWnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/3c574_cs: fix 'shadow variable' warning
has been removed from the -mm tree.  Its filename was
     pcmcia-3c574_cs-fix-shadow-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/3c574_cs: fix 'shadow variable' warning
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/3c574_cs.c
drivers/net/pcmcia/3c574_cs.c:695:7: warning: symbol 'i' shadows an earlier one
drivers/net/pcmcia/3c574_cs.c:636:6: originally declared here

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/3c574_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-shadow-variable-warning drivers/net/pcmcia/3c574_cs.c
--- a/drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-shadow-variable-warning
+++ a/drivers/net/pcmcia/3c574_cs.c
@@ -696,7 +696,7 @@ static void tc574_reset(struct net_devic
 	mdio_write(ioaddr, lp->phys, 4, lp->advertising);
 	if (!auto_polarity) {
 		/* works for TDK 78Q2120 series MII's */
-		int i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
+		i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
 		mdio_write(ioaddr, lp->phys, 16, i);
 	}
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
