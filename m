From: akpm@linux-foundation.org
Subject: + aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:45 -0800
Message-ID: <20121204234846.A0C65200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40931 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:48 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so327373eei.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: use dynamic number of remote ports for AoE storage target
has been added to the -mm tree.  Its filename is
     aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: use dynamic number of remote ports for AoE storage target

Many AoE targets have four or fewer network ports, but some existing
storage devices have many, and the AoE protocol sets no limit.

This patch allows the use of more than eight remote MAC addresses per AoE
target, while reducing the amount of memory used by the aoe driver in
cases where there are many AoE targets with fewer than eight MAC addresses
each.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    6 ++--
 drivers/block/aoe/aoeblk.c |    2 -
 drivers/block/aoe/aoecmd.c |   50 ++++++++++++++++++++++++-----------
 drivers/block/aoe/aoedev.c |   12 +++++++-
 4 files changed, 49 insertions(+), 21 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target
+++ a/drivers/block/aoe/aoe.h
@@ -84,7 +84,7 @@ enum {
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
 	MIN_BUFS = 16,
-	NTARGETS = 8,
+	NTARGETS = 4,
 	NAOEIFS = 8,
 	NSKBPOOLMAX = 256,
 	NFACTIVE = 61,
@@ -185,9 +185,9 @@ struct aoedev {
 	ulong maxbcnt;
 	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct list_head rexmitq; /* deferred retransmissions */
-	struct aoetgt *targets[NTARGETS];
+	struct aoetgt **targets;
+	ulong ntargets;		/* number of allocated aoetgt pointers */
 	struct aoetgt **tgt;	/* target in use when working */
-	ulong ntargets;
 	ulong kicked;
 	char ident[512];
 };
diff -puN drivers/block/aoe/aoeblk.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target
+++ a/drivers/block/aoe/aoeblk.c
@@ -67,7 +67,7 @@ static ssize_t aoedisk_show_netif(struct
 	nd = nds;
 	ne = nd + ARRAY_SIZE(nds);
 	t = d->targets;
-	te = t + NTARGETS;
+	te = t + d->ntargets;
 	for (; t < te && *t; t++) {
 		ifp = (*t)->ifs;
 		e = ifp + NAOEIFS;
diff -puN drivers/block/aoe/aoecmd.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target
+++ a/drivers/block/aoe/aoecmd.c
@@ -242,14 +242,14 @@ newframe(struct aoedev *d)
 	int use_tainted;
 	int has_untainted;
 
-	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
+	if (!d->targets || !d->targets[0]) {
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
 	tt = d->tgt;	/* last used target */
 	for (use_tainted = 0, has_untainted = 0;;) {
 		tt++;
-		if (tt >= &d->targets[NTARGETS] || !*tt)
+		if (tt >= &d->targets[d->ntargets] || !*tt)
 			tt = d->targets;
 		t = *tt;
 		if (!t->taint) {
@@ -1104,7 +1104,7 @@ gettgt(struct aoedev *d, char *addr)
 	struct aoetgt **t, **e;
 
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		if (memcmp((*t)->addr, addr, sizeof((*t)->addr)) == 0)
 			return *t;
@@ -1479,28 +1479,44 @@ aoecmd_ata_id(struct aoedev *d)
 	return skb;
 }
 
+static struct aoetgt **
+grow_targets(struct aoedev *d)
+{
+	ulong oldn, newn;
+	struct aoetgt **tt;
+
+	oldn = d->ntargets;
+	newn = oldn * 2;
+	tt = kcalloc(newn, sizeof(*d->targets), GFP_ATOMIC);
+	if (!tt)
+		return NULL;
+	memmove(tt, d->targets, sizeof(*d->targets) * oldn);
+	d->tgt = tt + (d->tgt - d->targets);
+	kfree(d->targets);
+	d->targets = tt;
+	d->ntargets = newn;
+
+	return &d->targets[oldn];
+}
+
 static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
 	struct aoetgt *t, **tt, **te;
 
 	tt = d->targets;
-	te = tt + NTARGETS;
+	te = tt + d->ntargets;
 	for (; tt < te && *tt; tt++)
 		;
 
 	if (tt == te) {
-		printk(KERN_INFO
-			"aoe: device addtgt failure; too many targets\n");
-		return NULL;
+		tt = grow_targets(d);
+		if (!tt)
+			goto nomem;
 	}
 	t = kzalloc(sizeof(*t), GFP_ATOMIC);
-	if (!t) {
-		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
-		return NULL;
-	}
-
-	d->ntargets++;
+	if (!t)
+		goto nomem;
 	t->nframes = nframes;
 	t->d = d;
 	memcpy(t->addr, addr, sizeof t->addr);
@@ -1509,6 +1525,10 @@ addtgt(struct aoedev *d, char *addr, ulo
 	t->maxout = t->nframes / 2;
 	INIT_LIST_HEAD(&t->ffree);
 	return *tt = t;
+
+ nomem:
+	pr_info("aoe: cannot allocate memory to add target\n");
+	return NULL;
 }
 
 static void
@@ -1518,7 +1538,7 @@ setdbcnt(struct aoedev *d)
 	int bcnt = 0;
 
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		if (bcnt == 0 || bcnt > (*t)->minbcnt)
 			bcnt = (*t)->minbcnt;
@@ -1662,7 +1682,7 @@ aoecmd_cleanslate(struct aoedev *d)
 	d->maxbcnt = 0;
 
 	t = d->targets;
-	te = t + NTARGETS;
+	te = t + d->ntargets;
 	for (; t < te && *t; t++)
 		aoecmd_wreset(*t);
 }
diff -puN drivers/block/aoe/aoedev.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target
+++ a/drivers/block/aoe/aoedev.c
@@ -214,7 +214,7 @@ aoedev_downdev(struct aoedev *d)
 
 	/* reset window dressings */
 	tt = d->targets;
-	te = tt + NTARGETS;
+	te = tt + d->ntargets;
 	for (; tt < te && (t = *tt); tt++) {
 		aoecmd_wreset(t);
 		t->nout = 0;
@@ -284,7 +284,7 @@ freedev(struct aoedev *d)
 		blk_cleanup_queue(d->blkq);
 	}
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		freetgt(d, *t);
 	if (d->bufpool)
@@ -376,6 +376,8 @@ restart:
 			dd = &d->next;
 		}
 		spin_unlock(&d->lock);
+		if (doomed)
+			kfree(doomed->targets);
 		kfree(doomed);
 	}
 	spin_unlock_irqrestore(&devlist_lock, flags);
@@ -456,6 +458,12 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
 		goto out;
+	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
+	if (!d->targets) {
+		kfree(d);
+		goto out;
+	}
+	d->ntargets = NTARGETS;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);
 	skb_queue_head_init(&d->skbpool);
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-next.patch
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch
aoe-copy-fallback-timing-information-on-destination-failover.patch
aoe-remove-vestigial-request-queue-allocation.patch
aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch
aoe-cleanup-correct-comment-for-aoetgt-nout.patch
aoe-remove-call-to-request-handler-from-i-o-completion.patch
aoe-make-error-messages-more-specific-in-static-minor-allocation.patch
aoe-initialize-sysminor-to-avoid-compiler-warning.patch
aoe-return-real-minor-number-for-static-minors.patch
aoe-improve-handling-of-misbehaving-network-paths.patch
aoe-avoid-races-between-device-destruction-and-discovery.patch
aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch
aoe-allow-user-to-disable-target-failure-timeout.patch
aoe-allow-comma-separator-in-aoe_iflist-value.patch
aoe-identify-source-of-runt-aoe-packets.patch
aoe-update-internal-version-number-to-81.patch

