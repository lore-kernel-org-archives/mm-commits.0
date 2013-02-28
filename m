From: akpm@linux-foundation.org
Subject: [merged] net-9p-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:52 -0800
Message-ID: <20130228201552.B43845A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52389 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3B1UPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:53 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245218ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: net/9p: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     net-9p-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: net/9p: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/util.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN net/9p/util.c~net-9p-convert-to-idr_alloc net/9p/util.c
--- a/net/9p/util.c~net-9p-convert-to-idr_alloc
+++ a/net/9p/util.c
@@ -87,23 +87,18 @@ EXPORT_SYMBOL(p9_idpool_destroy);
 
 int p9_idpool_get(struct p9_idpool *p)
 {
-	int i = 0;
-	int error;
+	int i;
 	unsigned long flags;
 
-retry:
-	if (idr_pre_get(&p->pool, GFP_NOFS) == 0)
-		return -1;
-
+	idr_preload(GFP_NOFS);
 	spin_lock_irqsave(&p->lock, flags);
 
 	/* no need to store exactly p, we just need something non-null */
-	error = idr_get_new(&p->pool, p, &i);
-	spin_unlock_irqrestore(&p->lock, flags);
+	i = idr_alloc(&p->pool, p, 0, 0, GFP_NOWAIT);
 
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
+	spin_unlock_irqrestore(&p->lock, flags);
+	idr_preload_end();
+	if (i < 0)
 		return -1;
 
 	p9_debug(P9_DEBUG_MUX, " id %d pool %p\n", i, p);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

