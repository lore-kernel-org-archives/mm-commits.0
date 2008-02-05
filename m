From: akpm@linux-foundation.org
Subject: - pcmcia-axnet_cs-make-functions-static.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:13 -0800
Message-ID: <200802052226.m15MQs0g011658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320AbYBEWne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/axnet_cs: make functions static
has been removed from the -mm tree.  Its filename was
     pcmcia-axnet_cs-make-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/axnet_cs: make functions static
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/axnet_cs.c
drivers/net/pcmcia/axnet_cs.c:994:5: warning: symbol 'ax_close' was not declared. Should it be static?
drivers/net/pcmcia/axnet_cs.c:1017:6: warning: symbol 'ei_tx_timeout' was not declared. Should it be static?

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/axnet_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-functions-static drivers/net/pcmcia/axnet_cs.c
--- a/drivers/net/pcmcia/axnet_cs.c~pcmcia-axnet_cs-make-functions-static
+++ a/drivers/net/pcmcia/axnet_cs.c
@@ -991,7 +991,7 @@ static int ax_open(struct net_device *de
  *
  * Opposite of ax_open(). Only used when "ifconfig <devname> down" is done.
  */
-int ax_close(struct net_device *dev)
+static int ax_close(struct net_device *dev)
 {
 	unsigned long flags;
 
@@ -1014,7 +1014,7 @@ int ax_close(struct net_device *dev)
  * completed (or failed) - i.e. never posted a Tx related interrupt.
  */
 
-void ei_tx_timeout(struct net_device *dev)
+static void ei_tx_timeout(struct net_device *dev)
 {
 	long e8390_base = dev->base_addr;
 	struct ei_device *ei_local = (struct ei_device *) netdev_priv(dev);
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
