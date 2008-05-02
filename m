From: akpm@linux-foundation.org
Subject: + fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe.patch added to -mm tree
Date: Fri, 02 May 2008 16:11:40 -0700
Message-ID: <200805022311.m42NBeXE019925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937198AbYEBXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scottwood@freescale.com, danielm77@spray.se


The patch titled
     fs_enet: fix a memory leak in fs_enet_mdio_probe
has been added to the -mm tree.  Its filename is
     fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe.patch

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
fs_enet-fix-a-memory-leak-in-fs_enet_mdio_probe.patch

