From: akpm@linux-foundation.org
Subject: - drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof.patch removed from -mm tree
Date: Fri, 15 Feb 2008 19:52:11 -0800
Message-ID: <200802160352.m1G3qBVN007156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755225AbYBPDwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 22:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/net/ixgb/ixgb_ethtool.c: Use FIELD_SIZEOF
has been removed from the -mm tree.  Its filename was
     drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/ixgb/ixgb_ethtool.c: Use FIELD_SIZEOF
From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ixgb/ixgb_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ixgb/ixgb_ethtool.c~drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof drivers/net/ixgb/ixgb_ethtool.c
--- a/drivers/net/ixgb/ixgb_ethtool.c~drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof
+++ a/drivers/net/ixgb/ixgb_ethtool.c
@@ -49,7 +49,7 @@ struct ixgb_stats {
 	int stat_offset;
 };
 
-#define IXGB_STAT(m) sizeof(((struct ixgb_adapter *)0)->m), \
+#define IXGB_STAT(m) FIELD_SIZEOF(struct ixgb_adapter, m), \
 		      offsetof(struct ixgb_adapter, m)
 static struct ixgb_stats ixgb_gstrings_stats[] = {
 	{"rx_packets", IXGB_STAT(net_stats.rx_packets)},
_

Patches currently in -mm which might be from julia@diku.dk are

git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
drivers-block-viodasdc-use-field_sizeof.patch
