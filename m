From: akpm@linux-foundation.org
Subject: - fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:17 -0700
Message-ID: <200805092147.m49LlHMH027199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbYEIVsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scottwood@freescale.com, danielm77@spray.se, mm-commits@vger.kernel.org


The patch titled
     fs_enet: fix a memory leak in fs_enet_mdio_probe
has been removed from the -mm tree.  Its filename was
     fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs_enet: fix a memory leak in fs_enet_mdio_probe
From: Scott Wood <scottwood@freescale.com>

There are more memory leaks in the !PPC_CPM_NEW_BINDING case, but that code
will disappear soon along with arch/ppc.

Reported by Daniel Marjamki <danielm77@spray.se> at
http://bugzilla.kernel.org/show_bug.cgi?id=10591

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: Daniel Marjamki <danielm77@spray.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/mii-fec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/fs_enet/mii-fec.c~fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe drivers/net/fs_enet/mii-fec.c
--- a/drivers/net/fs_enet/mii-fec.c~fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe
+++ a/drivers/net/fs_enet/mii-fec.c
@@ -194,7 +194,7 @@ static int __devinit fs_enet_mdio_probe(
 
 	ret = of_address_to_resource(ofdev->node, 0, &res);
 	if (ret)
-		return ret;
+		goto out_res;
 
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
 
@@ -236,6 +236,7 @@ out_free_irqs:
 	kfree(new_bus->irq);
 out_unmap_regs:
 	iounmap(fec->fecp);
+out_res:
 out_fec:
 	kfree(fec);
 out_mii:
_

Patches currently in -mm which might be from scottwood@freescale.com are

origin.patch

