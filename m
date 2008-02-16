From: akpm@linux-foundation.org
Subject: - drivers-net-igb-use-field_sizeof.patch removed from -mm tree
Date: Fri, 15 Feb 2008 19:52:08 -0800
Message-ID: <200802160352.m1G3q8ss007153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913AbYBPDwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 22:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/igb: Use FIELD_SIZEOF
has been removed from the -mm tree.  Its filename was
     drivers-net-igb-use-field_sizeof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/igb: Use FIELD_SIZEOF
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
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/igb/igb_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/igb/igb_ethtool.c~drivers-net-igb-use-field_sizeof drivers/net/igb/igb_ethtool.c
--- a/drivers/net/igb/igb_ethtool.c~drivers-net-igb-use-field_sizeof
+++ a/drivers/net/igb/igb_ethtool.c
@@ -43,7 +43,7 @@ struct igb_stats {
 	int stat_offset;
 };
 
-#define IGB_STAT(m) sizeof(((struct igb_adapter *)0)->m), \
+#define IGB_STAT(m) FIELD_SIZEOF(struct igb_adapter, m), \
 		      offsetof(struct igb_adapter, m)
 static const struct igb_stats igb_gstrings_stats[] = {
 	{ "rx_packets", IGB_STAT(stats.gprc) },
_

Patches currently in -mm which might be from julia@diku.dk are

git-hid.patch
git-net.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
drivers-block-viodasdc-use-field_sizeof.patch
