From: akpm@linux-foundation.org
Subject: - allow-pktgen-to-work-with-loopback-devices.patch removed from -mm tree
Date: Thu, 22 Mar 2007 22:52:55 -0800
Message-ID: <200703230652.l2N6qtXQ008409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820AbXCWGw5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 02:52:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@freedesktop.org, mm-commits@vger.kernel.org


The patch titled
     Allow pktgen to work with loopback devices.
has been removed from the -mm tree.  Its filename was
     allow-pktgen-to-work-with-loopback-devices.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Allow pktgen to work with loopback devices.
From: Josh Triplett <josh@freedesktop.org>

pktgen currently only works on network devices with type ARPHRD_ETHER.  Add
support for the loopback device, type ARPHRD_LOOPBACK.

I've tested this on my system, using a modified pktgen.conf-1-1 with
s/eth1/lo/g, and it works fine; the network device statistics confirm
packet transmission and receipt.

Thanks to Sarah Bailey for discovering and tracking down the problem.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/pktgen.c~allow-pktgen-to-work-with-loopback-devices net/core/pktgen.c
--- a/net/core/pktgen.c~allow-pktgen-to-work-with-loopback-devices
+++ a/net/core/pktgen.c
@@ -1929,7 +1929,7 @@ static int pktgen_setup_dev(struct pktge
 		return -ENODEV;
 	}
 
-	if (odev->type != ARPHRD_ETHER) {
+	if (odev->type != ARPHRD_LOOPBACK && odev->type != ARPHRD_ETHER) {
 		printk("pktgen: not an ethernet device: \"%s\"\n", ifname);
 		err = -EINVAL;
 	} else if (!netif_running(odev)) {
_

Patches currently in -mm which might be from josh@freedesktop.org are

allow-pktgen-to-work-with-loopback-devices.patch
rcutorture-mark-rcu_torture_init-as-__init.patch
