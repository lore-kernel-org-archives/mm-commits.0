From: akpm@linux-foundation.org
Subject: + sky2-avoid-divide-in-receive-path.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:30:18 -0700
Message-ID: <200708311930.l7VJUITn023099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbXHaTaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:30:20 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7VJUIaA018171
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2007 12:30:19 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     sky2: avoid divide in receive path
has been added to the -mm tree.  Its filename is
     sky2-avoid-divide-in-receive-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sky2: avoid divide in receive path
From: Stephen Hemminger <shemminger@linux-foundation.org>

Avoid divide (modulus) in receive buffer handling path.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-avoid-divide-in-receive-path drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-avoid-divide-in-receive-path
+++ a/drivers/net/sky2.c
@@ -2140,7 +2140,8 @@ static struct sk_buff *sky2_receive(stru
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
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-fe-chip-support.patch
sky2-use-debugfs-rename.patch
sky2-document-gphy_ctrl-bits.patch
sky2-dont-restrict-config-space-access.patch
sky2-advanced-error-reporting.patch
sky2-use-pci_config-access-functions.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-hardware-receive-timestamp-counter.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
