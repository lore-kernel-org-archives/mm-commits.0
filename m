From: akpm@linux-foundation.org
Subject: - sky2-avoid-divide-in-receive-path.patch removed from -mm tree
Date: Fri, 28 Sep 2007 22:58:28 -0700
Message-ID: <200709290558.l8T5wSAM002840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbXI2F6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Sep 2007 01:58:30 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8T5wSaf028755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 28 Sep 2007 22:58:29 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     sky2: avoid divide in receive path
has been removed from the -mm tree.  Its filename was
     sky2-avoid-divide-in-receive-path.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sky2: avoid divide in receive path
From: Stephen Hemminger <shemminger@linux-foundation.org>

Avoid divide (modulus) in receive buffer handling path.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-avoid-divide-in-receive-path drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-avoid-divide-in-receive-path
+++ a/drivers/net/sky2.c
@@ -2155,7 +2155,8 @@ static struct sk_buff *sky2_receive(stru
 		printk(KERN_DEBUG PFX "%s: rx slot %u status 0x%x len %d\n",
 		       dev->name, sky2->rx_next, status, length);
 
-	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
+	if (++sky2->rx_next >= sky2->rx_pending)
+		sky2->rx_next = 0;
 	prefetch(sky2->rx_ring + sky2->rx_next);
 
 	if (status & GMR_FS_ANY_ERR)
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
