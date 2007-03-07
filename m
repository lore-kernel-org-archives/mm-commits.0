From: akpm@linux-foundation.org
Subject: + allow-pktgen-to-work-with-loopback-devices.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:03:19 -0800
Message-ID: <200703072103.l27L3J7V008724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965483AbXCGVDV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:03:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@freedesktop.org


The patch titled
     Allow pktgen to work with loopback devices.
has been added to the -mm tree.  Its filename is
     allow-pktgen-to-work-with-loopback-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/pktgen.c~allow-pktgen-to-work-with-loopback-devices net/core/pktgen.c
--- a/net/core/pktgen.c~allow-pktgen-to-work-with-loopback-devices
+++ a/net/core/pktgen.c
@@ -1930,7 +1930,7 @@ static struct net_device *pktgen_setup_d
 		printk("pktgen: no such netdevice: \"%s\"\n", pkt_dev->ifname);
 		goto out;
 	}
-	if (odev->type != ARPHRD_ETHER) {
+	if (odev->type != ARPHRD_LOOPBACK && odev->type != ARPHRD_ETHER) {
 		printk("pktgen: not an ethernet device: \"%s\"\n",
 		       pkt_dev->ifname);
 		goto out_put;
_

Patches currently in -mm which might be from josh@freedesktop.org are

allow-pktgen-to-work-with-loopback-devices.patch
rcutorture-mark-rcu_torture_init-as-__init.patch
