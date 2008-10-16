From: akpm@linux-foundation.org
Subject: + orinoco-fix-unsafe-locking-in-orinoco_cs_resume.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:41:45 -0700
Message-ID: <200810161941.m9GJfj8r008924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbYJPTmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, hermes@gibson.dropbear.id.au, kilroyd@googlemail.com, linville@tuxdriver.com, proski@gnu.org


The patch titled
     orinoco: fix unsafe locking in orinoco_cs_resume()
has been added to the -mm tree.  Its filename is
     orinoco-fix-unsafe-locking-in-orinoco_cs_resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: orinoco: fix unsafe locking in orinoco_cs_resume()
From: Andrey Borzenkov <arvidjaar@mail.ru>

Fix a lockdep warning.  Unfortunately it is rather hard to trigger on
purpose.

[ 6972.562035] =================================
[ 6972.562040] [ INFO: inconsistent lock state ]
[ 6972.562048] 2.6.27-1avb #17
[ 6972.562053] ---------------------------------
[ 6972.562060] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[ 6972.562068] pm-suspend/17062 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 6972.562076]  (&priv->lock){++..}, at: [<dfd4f05b>] orinoco_cs_resume+0x5b/0xd0 [orinoco_cs]
[ 6972.562122] {in-hardirq-W} state was registered at:
[ 6972.562128]   [<c013ea6b>] __lock_acquire+0x6cb/0x1640
[ 6972.562171]   [<c013fa3c>] lock_acquire+0x5c/0x80
[ 6972.562181]   [<c02f6e39>] _spin_lock_irqsave+0x49/0x80
[ 6972.562210]   [<dfd6425d>] orinoco_interrupt+0x4d/0x16d0 [orinoco]
[ 6972.562257]   [<c015a2b1>] handle_IRQ_event+0x31/0x60
[ 6972.562278]   [<c015b73e>] handle_level_irq+0x6e/0xe0
[ 6972.562291]   [<c0104b20>] do_IRQ+0xb0/0x130
[ 6972.562313]   [<ffffffff>] 0xffffffff

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Acked-by: Dave <kilroyd@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Roskin <proski@gnu.org>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/orinoco_cs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/orinoco_cs.c~orinoco-fix-unsafe-locking-in-orinoco_cs_resume drivers/net/wireless/orinoco_cs.c
--- a/drivers/net/wireless/orinoco_cs.c~orinoco-fix-unsafe-locking-in-orinoco_cs_resume
+++ a/drivers/net/wireless/orinoco_cs.c
@@ -378,6 +378,7 @@ static int orinoco_cs_resume(struct pcmc
 	struct orinoco_private *priv = netdev_priv(dev);
 	struct orinoco_pccard *card = priv->card;
 	int err = 0;
+	unsigned long flags;
 
 	if (! test_bit(0, &card->hard_reset_in_progress)) {
 		err = orinoco_reinit_firmware(dev);
@@ -387,7 +388,7 @@ static int orinoco_cs_resume(struct pcmc
 			return -EIO;
 		}
 
-		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
 
 		netif_device_attach(dev);
 		priv->hw_unavailable--;
@@ -399,7 +400,7 @@ static int orinoco_cs_resume(struct pcmc
 				       dev->name, err);
 		}
 
-		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	return err;
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

origin.patch
orinoco-fix-unsafe-locking-in-orinoco_cs_resume.patch

