From: akpm@linux-foundation.org
Subject: + drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch added to -mm tree
Date: Tue, 08 Feb 2011 15:29:01 -0800
Message-ID: <201102082329.p18NT1Tl031989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab1BHX3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 18:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dwmw2@infradead.org


The patch titled
     drivers/mtd/maps/ts5500_flash.c: avoid calling map_destroy on NULL
has been added to the -mm tree.  Its filename is
     drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-w1-masters-omap_hdqc-add-missing-clk_put.patch
drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch

