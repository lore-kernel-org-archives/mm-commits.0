From: akpm@linux-foundation.org
Subject: - infiniband-hw-nes-avoid-unnecessary-memset.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:11 -0700
Message-ID: <200805202114.m4KLEB1J011442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbYETVWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, faisal@neteffect.com, mm-commits@vger.kernel.org


The patch titled
     infiniband/hw/nes/: avoid unnecessary memset
has been removed from the -mm tree.  Its filename was
     infiniband-hw-nes-avoid-unnecessary-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: infiniband/hw/nes/: avoid unnecessary memset
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Remove an explicit memset(.., 0, ...) to a variable allocated with kzalloc
(i.e.  'listener').

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Acked-by: Faisal Latif <faisal@neteffect.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/nes/nes_cm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/infiniband/hw/nes/nes_cm.c~infiniband-hw-nes-avoid-unnecessary-memset drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~infiniband-hw-nes-avoid-unnecessary-memset
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -1603,7 +1603,6 @@ static struct nes_cm_listener *mini_cm_l
 			return NULL;
 		}
 
-		memset(listener, 0, sizeof(struct nes_cm_listener));
 		listener->loc_addr = htonl(cm_info->loc_addr);
 		listener->loc_port = htons(cm_info->loc_port);
 		listener->reused_node = 0;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

origin.patch
linux-next.patch
drivers-net-ehea-remove-unnecessary-memset-after-kzalloc.patch
accessrunner-avoid-unnecessary-memset.patch

