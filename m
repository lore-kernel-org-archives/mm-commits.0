From: akpm@linux-foundation.org
Subject: - forcedeth-fix-nic-poll.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:09 -0700
Message-ID: <200703290743.l2T7h9LB030361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbXC2HnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fix nic poll
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-nic-poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: fix nic poll
From: Ayaz Abdulla <aabdulla@nvidia.com>

The nic poll routine was missing the call to the optimized irq routine. 
This patch adds the missing call for the optimized path.

See http://bugzilla.kernel.org/show_bug.cgi?id=7950 for more information.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-nic-poll drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-nic-poll
+++ a/drivers/net/forcedeth.c
@@ -3536,7 +3536,10 @@ static void nv_do_nic_poll(unsigned long
 	pci_push(base);
 
 	if (!using_multi_irqs(dev)) {
-		nv_nic_irq(0, dev);
+		if (np->desc_ver == DESC_VER_3)
+			nv_nic_irq_optimized(0, dev);
+		else
+			nv_nic_irq(0, dev);
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-work-around-null-skb-dereference-crash.patch
