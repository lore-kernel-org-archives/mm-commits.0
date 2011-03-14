From: akpm@linux-foundation.org
Subject: [merged] drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch removed from -mm tree
Date: Mon, 14 Mar 2011 12:45:04 -0700
Message-ID: <201103141947.p2EJl2lh006919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab1CNTrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 15:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/maps/ts5500_flash.c: avoid calling map_destroy on NULL
has been removed from the -mm tree.  Its filename was
     drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/maps/ts5500_flash.c: avoid calling map_destroy on NULL
From: Julia Lawall <julia@diku.dk>

map_destroy dereferences its argument.  The call is furthermore only
reachable when this argument is NULL.  Thus the call is dropped.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
@@

*if (x == NULL)
{ ...
* map_destroy(x);
  ...
  return ...;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/ts5500_flash.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mtd/maps/ts5500_flash.c~drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null drivers/mtd/maps/ts5500_flash.c
--- a/drivers/mtd/maps/ts5500_flash.c~drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null
+++ a/drivers/mtd/maps/ts5500_flash.c
@@ -94,7 +94,6 @@ static int __init init_ts5500_map(void)
 	return 0;
 
 err1:
-	map_destroy(mymtd);
 	iounmap(ts5500_map.virt);
 err2:
 	return rc;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch
drivers-char-specialixc-convert-func_enter-to-func_exit.patch

