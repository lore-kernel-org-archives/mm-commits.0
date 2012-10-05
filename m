From: akpm@linux-foundation.org
Subject: [merged] aoe-disallow-unsupported-aoe-minor-addresses.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:26 -0700
Message-ID: <20121005202127.23E4520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33702 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:29 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141211lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: disallow unsupported AoE minor addresses
has been removed from the -mm tree.  Its filename was
     aoe-disallow-unsupported-aoe-minor-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: disallow unsupported AoE minor addresses

A guard is inserted to prevent AoE minor addresses (slot addresses) higher
than 15 to be used, as they are not yet supported by the driver.

There is a change coming that will allow the aoe driver to overcome this
limit by using system device minor numbers dynamically, but until then,
this guard prevents unexpected targets from being used by the driver when
AoE targets with high minor numbers are on the AoE network.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-disallow-unsupported-aoe-minor-addresses drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-disallow-unsupported-aoe-minor-addresses
+++ a/drivers/block/aoe/aoecmd.c
@@ -1359,6 +1359,13 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
+	if (h->minor >= NPERSHELF) {
+		pr_err("aoe: e%ld.%d %s, %d\n",
+			aoemajor, h->minor,
+			"slot number larger than the maximum",
+			NPERSHELF-1);
+		return;
+	}
 
 	sysminor = SYSMINOR(aoemajor, h->minor);
 	if (sysminor * AOE_PARTITIONS + AOE_PARTITIONS > MINORMASK) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

