From: akpm@linux-foundation.org
Subject: + drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch added to -mm tree
Date: Tue, 07 May 2013 14:20:13 -0700
Message-ID: <20130507212013.75FBF5A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:65067 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566Ab3EGVUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 17:20:14 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so101148ghb.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 14:20:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaohongjiang@huawei.com, roland@kernel.org, sean.hefty@intel.com, tj@kernel.org


The patch titled
     Subject: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()

commit 3e6628c4b347 ("idr: introduce idr_alloc_cyclic()") adds a new
idr_alloc_cyclic routine and converts several of these users to it.  This
is just a missed one - add it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/cm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/core/cm.c
@@ -383,14 +383,11 @@ static int cm_alloc_id(struct cm_id_priv
 {
 	unsigned long flags;
 	int id;
-	static int next_id;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&cm.lock, flags);
 
-	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
-	if (id >= 0)
-		next_id = max(id + 1, 0);
+	id = idr_alloc_cyclic(&cm.local_id_table, cm_id_priv, 0, 0, GFP_NOWAIT);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

origin.patch
parisc-remove-the-second-argument-of-kmap_atomic.patch
drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic.patch

