From: akpm@linux-foundation.org
Subject: [merged] aoe-allow-comma-separator-in-aoe_iflist-value.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:25 -0800
Message-ID: <20121218201126.31C8520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:51972 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRUL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:28 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69790lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: allow comma separator in aoe_iflist value
has been removed from the -mm tree.  Its filename was
     aoe-allow-comma-separator-in-aoe_iflist-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: allow comma separator in aoe_iflist value

By default, the aoe driver uses any ethernet interface for AoE, but the
aoe_iflist module parameter provides a convenient way to limit AoE traffic
to a specific list of local network interfaces.

This change allows a list to be specified using the comma character as a
separator.  For example,

  modprobe aoe aoe_iflist=eth2,eth3

Before, it was inconvenient to get the quoting right in shell scripts when
setting aoe_iflist to have more than one network interface.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoenet.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-allow-comma-separator-in-aoe_iflist-value drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-allow-comma-separator-in-aoe_iflist-value
+++ a/drivers/block/aoe/aoe.h
@@ -11,7 +11,7 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define WHITESPACE " \t\v\f\n"
+#define WHITESPACE " \t\v\f\n,"
 
 enum {
 	AOECMD_ATA,
diff -puN drivers/block/aoe/aoenet.c~aoe-allow-comma-separator-in-aoe_iflist-value drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-allow-comma-separator-in-aoe_iflist-value
+++ a/drivers/block/aoe/aoenet.c
@@ -31,7 +31,7 @@ enum {
 
 static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
-MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
+MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=dev1[,dev2...]");
 
 static wait_queue_head_t txwq;
 static struct ktstate kts;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

