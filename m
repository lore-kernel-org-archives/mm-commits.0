From: akpm@linux-foundation.org
Subject: [merged] aoe-increase-net_device-reference-count-while-using-it.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:33 -0700
Message-ID: <20121005202134.10E5E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56814 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:36 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138562fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: increase net_device reference count while using it
has been removed from the -mm tree.  Its filename was
     aoe-increase-net_device-reference-count-while-using-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: increase net_device reference count while using it

This change eliminates the danger that the user could rmmod the driver for
a network interface that is being used for AoE by the aoe driver.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    4 ++++
 drivers/block/aoe/aoedev.c |    7 +++++++
 2 files changed, 11 insertions(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-increase-net_device-reference-count-while-using-it drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-increase-net_device-reference-count-while-using-it
+++ a/drivers/block/aoe/aoecmd.c
@@ -494,12 +494,15 @@ static void
 ejectif(struct aoetgt *t, struct aoeif *ifp)
 {
 	struct aoeif *e;
+	struct net_device *nd;
 	ulong n;
 
+	nd = ifp->nd;
 	e = t->ifs + NAOEIFS - 1;
 	n = (e - ifp) * sizeof *ifp;
 	memmove(ifp, ifp+1, n);
 	e->nd = NULL;
+	dev_put(nd);
 }
 
 static int
@@ -1317,6 +1320,7 @@ setifbcnt(struct aoetgt *t, struct net_d
 			pr_err("aoe: device setifbcnt failure; too many interfaces.\n");
 			return;
 		}
+		dev_hold(nd);
 		p->nd = nd;
 		p->bcnt = bcnt;
 	}
diff -puN drivers/block/aoe/aoedev.c~aoe-increase-net_device-reference-count-while-using-it drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-increase-net_device-reference-count-while-using-it
+++ a/drivers/block/aoe/aoedev.c
@@ -295,6 +295,13 @@ freetgt(struct aoedev *d, struct aoetgt 
 {
 	struct frame *f;
 	struct list_head *pos, *nx, *head;
+	struct aoeif *ifp;
+
+	for (ifp = t->ifs; ifp < &t->ifs[NAOEIFS]; ++ifp) {
+		if (!ifp->nd)
+			break;
+		dev_put(ifp->nd);
+	}
 
 	head = &t->ffree;
 	list_for_each_safe(pos, nx, head) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

