From: akpm@linux-foundation.org
Subject: - drivers-net-wan-use-div_round_up.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:58 -0700
Message-ID: <200810012150.m91Lown5005885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbYJAVvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wan: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-net-wan-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wan: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/sbni.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/sbni.c~drivers-net-wan-use-div_round_up drivers/net/wan/sbni.c
--- a/drivers/net/wan/sbni.c~drivers-net-wan-use-div_round_up
+++ a/drivers/net/wan/sbni.c
@@ -856,7 +856,7 @@ prepare_to_send( struct sk_buff  *skb,  
 		len = SBNI_MIN_LEN;
 
 	nl->tx_buf_p	= skb;
-	nl->tx_frameno	= (len + nl->maxframe - 1) / nl->maxframe;
+	nl->tx_frameno	= DIV_ROUND_UP(len, nl->maxframe);
 	nl->framelen	= len < nl->maxframe  ?  len  :  nl->maxframe;
 
 	outb( inb( dev->base_addr + CSR0 ) | TR_REQ,  dev->base_addr + CSR0 );
_

Patches currently in -mm which might be from julia@diku.dk are

git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

