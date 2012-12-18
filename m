From: akpm@linux-foundation.org
Subject: [merged] aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:35 -0800
Message-ID: <20121218201136.2E2FB200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:46542 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:38 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so63653wey.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: fix use after free in aoedev_by_aoeaddr()
has been removed from the -mm tree.  Its filename was
     aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: aoe: fix use after free in aoedev_by_aoeaddr()

We should return NULL on failure instead of returning a freed pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/aoe/aoedev.c~aoe-fix-use-after-free-in-aoedev_by_aoeaddr drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-fix-use-after-free-in-aoedev_by_aoeaddr
+++ a/drivers/block/aoe/aoedev.c
@@ -461,6 +461,7 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
 	if (!d->targets) {
 		kfree(d);
+		d = NULL;
 		goto out;
 	}
 	d->ntargets = NTARGETS;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

