From: akpm@linux-foundation.org
Subject: [merged] aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:42 -0800
Message-ID: <20121218200942.9F749100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40363 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2LRUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:43 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so126042vbi.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update cap on outstanding commands based on config query response
has been removed from the -mm tree.  Its filename was
     aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update cap on outstanding commands based on config query response

The ATA over Ethernet config query response contains a "buffer count"
field reflecting the AoE target's capacity to buffer incoming AoE
commands.

By taking the current value of this field into accound, we increase
performance throughput or avoid network congestion, when the value
has increased or decreased, respectively.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    6 +++---
 drivers/block/aoe/aoecmd.c |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-cap-on-outstanding-commands-based-on-config-query-response drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-cap-on-outstanding-commands-based-on-config-query-response
+++ a/drivers/block/aoe/aoe.h
@@ -122,14 +122,14 @@ struct aoeif {
 
 struct aoetgt {
 	unsigned char addr[6];
-	ushort nframes;
+	ushort nframes;		/* cap on frames to use */
 	struct aoedev *d;			/* parent device I belong to */
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
-	ushort maxout;
-	ulong falloc;
+	ushort maxout;		/* current value for max outstanding */
+	ulong falloc;		/* number of allocated frames */
 	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
 	int wpkts, rpkts;
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-cap-on-outstanding-commands-based-on-config-query-response drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-cap-on-outstanding-commands-based-on-config-query-response
+++ a/drivers/block/aoe/aoecmd.c
@@ -1373,7 +1373,11 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
-	if (!t) {
+	if (t) {
+		t->nframes = n;
+		if (n < t->maxout)
+			t->maxout = n;
+	} else {
 		t = addtgt(d, h->src, n);
 		if (!t)
 			goto bail;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

