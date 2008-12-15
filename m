From: akpm@linux-foundation.org
Subject: - drivers-mtd-maps-nettelc-use-array_size.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:09 -0800
Message-ID: <200812152002.mBFK294v030766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630AbYLOUCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/maps/nettel.c: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     drivers-mtd-maps-nettelc-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/maps/nettel.c: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/nettel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/maps/nettel.c~drivers-mtd-maps-nettelc-use-array_size drivers/mtd/maps/nettel.c
--- a/drivers/mtd/maps/nettel.c~drivers-mtd-maps-nettelc-use-array_size
+++ a/drivers/mtd/maps/nettel.c
@@ -362,8 +362,7 @@ static int __init nettel_init(void)
 
 	intel_mtd->owner = THIS_MODULE;
 
-	num_intel_partitions = sizeof(nettel_intel_partitions) /
-		sizeof(nettel_intel_partitions[0]);
+	num_intel_partitions = ARRAY_SIZE(nettel_intel_partitions);
 
 	if (intelboot) {
 		/*
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch

