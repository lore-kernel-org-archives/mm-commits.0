From: akpm@linux-foundation.org
Subject: - char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:45 -0800
Message-ID: <200702112255.l1BMtjFg016356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbXBKWzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     CHAR-Amiserial: turn local_save_flags() + local_irq_disable() into local_irq_save()
has been removed from the -mm tree.  Its filename was
     char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CHAR-Amiserial: turn local_save_flags() + local_irq_disable() into local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

drivers/char/amiserial.c::rs_write() contains local_irq_disable() after
local_save_flags().  Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/amiserial.c~char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save
+++ a/drivers/char/amiserial.c
@@ -902,8 +902,7 @@ static int rs_write(struct tty_struct * 
 	if (!info->xmit.buf)
 		return 0;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	while (1) {
 		c = CIRC_SPACE_TO_END(info->xmit.head,
 				      info->xmit.tail,
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-alsa.patch
git-hid.patch
git-ipwireless_cs.patch
ds1302-local_irq_disable-is-redundant-after-local_irq_save.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
