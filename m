From: akpm@linux-foundation.org
Subject: [merged] aoe-update-and-specify-aoe-address-guards-and-error-messages.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:58 -0700
Message-ID: <20121005202159.1AF7B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63590 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:01 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141223lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update and specify AoE address guards and error messages
has been removed from the -mm tree.  Its filename was
     aoe-update-and-specify-aoe-address-guards-and-error-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update and specify AoE address guards and error messages

In general, specific is better when it comes to messages about AoE usage
problems.  Also, explicit checks for the AoE broadcast addresses are
added.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 --
 drivers/block/aoe/aoecmd.c |   17 +++++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-and-specify-aoe-address-guards-and-error-messages drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-and-specify-aoe-address-guards-and-error-messages
+++ a/drivers/block/aoe/aoe.h
@@ -49,8 +49,6 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
-#define AOE_MAXSHELF (0xffff-1)	/* one less than the broadcast shelf address */
-
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-and-specify-aoe-address-guards-and-error-messages drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-and-specify-aoe-address-guards-and-error-messages
+++ a/drivers/block/aoe/aoecmd.c
@@ -1349,15 +1349,14 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
-	if (aoemajor > AOE_MAXSHELF) {
-		pr_info("aoe: e%ld.%d: shelf number too large\n",
+	if (aoemajor == 0xffff) {
+		pr_info("aoe: e%ld.%d: broadcast shelf number invalid\n",
 			aoemajor, (int) h->minor);
 		return;
 	}
-
-	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
-	if (d == NULL) {
-		pr_info("aoe: device allocation failure\n");
+	if (h->minor == 0xff) {
+		pr_info("aoe: e%ld.%d: broadcast slot number invalid\n",
+			aoemajor, (int) h->minor);
 		return;
 	}
 
@@ -1365,6 +1364,12 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
+	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
+	if (d == NULL) {
+		pr_info("aoe: device allocation failure\n");
+		return;
+	}
+
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

