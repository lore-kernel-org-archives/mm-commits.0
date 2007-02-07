From: akpm@linux-foundation.org
Subject: - net-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:12 -0800
Message-ID: <200702071953.l17JrC3s025303@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422889AbXBGTxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     NET: turn local_save_flags() + local_irq_disable() into local_irq_save()
has been removed from the -mm tree.  Its filename was
     net-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NET: turn local_save_flags() + local_irq_disable() into local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

drivers/net/amd8111e.c::amd8111e_poll() contains local_irq_disable() after
local_save_flags().  Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/amd8111e.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/amd8111e.c~net-turn-local_save_flags-local_irq_disable-into-local_irq_save drivers/net/amd8111e.c
--- a/drivers/net/amd8111e.c~net-turn-local_save_flags-local_irq_disable-into-local_irq_save
+++ a/drivers/net/amd8111e.c
@@ -1334,8 +1334,7 @@ err_no_interrupt:
 static void amd8111e_poll(struct net_device *dev)
 {
 	unsigned long flags;
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	amd8111e_interrupt(0, dev);
 	local_irq_restore(flags);
 }
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-powerpc.patch
git-netdev-all.patch
scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save.patch
git-ipwireless_cs.patch
cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
tick-management-dyntick--highres-functionality-fix.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
