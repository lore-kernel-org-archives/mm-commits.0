From: akpm@linux-foundation.org
Subject: - use-is_power_of_2-in-myri10ge-myri10gec.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:00 -0700
Message-ID: <200707101949.l6AJn0BH026044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758861AbXGJTtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, brice@myri.com, mm-commits@vger.kernel.org


The patch titled
     Use is_power_of_2() in myri10ge/myri10ge.c
has been removed from the -mm tree.  Its filename was
     use-is_power_of_2-in-myri10ge-myri10gec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use is_power_of_2() in myri10ge/myri10ge.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Cc: Brice Goglin <brice@myri.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/myri10ge/myri10ge.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/myri10ge/myri10ge.c~use-is_power_of_2-in-myri10ge-myri10gec drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~use-is_power_of_2-in-myri10ge-myri10gec
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -60,6 +60,7 @@
 #include <linux/crc32.h>
 #include <linux/moduleparam.h>
 #include <linux/io.h>
+#include <linux/log2.h>
 #include <net/checksum.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -1804,7 +1805,7 @@ static int myri10ge_open(struct net_devi
 	 */
 	big_pow2 = dev->mtu + ETH_HLEN + VLAN_HLEN + MXGEFW_PAD;
 	if (big_pow2 < MYRI10GE_ALLOC_SIZE / 2) {
-		while ((big_pow2 & (big_pow2 - 1)) != 0)
+		while (!is_power_of_2(big_pow2))
 			big_pow2++;
 		mgp->big_bytes = dev->mtu + ETH_HLEN + VLAN_HLEN + MXGEFW_PAD;
 	} else {
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-ubi.patch
git-netdev-all.patch
git-xfs.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-jbd.patch
is_power_of_2-kernel-kfifoc.patch
is_power_of_2-ufs-superc.patch
is_power_of_2-ext4-superc.patch
