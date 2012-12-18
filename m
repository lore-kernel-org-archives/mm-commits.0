From: akpm@linux-foundation.org
Subject: [merged] aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:49 -0800
Message-ID: <20121218201050.154EF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:51654 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:52 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so63341fav.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: increase default cap on outstanding AoE commands in the network
has been removed from the -mm tree.  Its filename was
     aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: increase default cap on outstanding AoE commands in the network

The aoe driver will never be waiting for more than aoe_maxout AoE commands
from a given remote network port on an AoE target.  Increasing the cap
increases performance.  Users can tighten the setting to reduce the amount
of memory used for handling AoE traffic or the network bandwidth used for
AoE.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network
+++ a/drivers/block/aoe/aoecmd.c
@@ -29,7 +29,7 @@ static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
 
-static int aoe_maxout = 16;
+static int aoe_maxout = 64;
 module_param(aoe_maxout, int, 0644);
 MODULE_PARM_DESC(aoe_maxout,
 	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

