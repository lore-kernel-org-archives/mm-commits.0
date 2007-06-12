From: akpm@linux-foundation.org
Subject: + use-is_power_of_2-in-myri10ge-myri10gec.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:01:22 -0700
Message-ID: <200706122001.l5CK1Mo0020143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXFLUBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com, brice@myri.com


The patch titled
     Use is_power_of_2() in myri10ge/myri10ge.c
has been added to the -mm tree.  Its filename is
     use-is_power_of_2-in-myri10ge-myri10gec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1797,7 +1798,7 @@ static int myri10ge_open(struct net_devi
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

use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
