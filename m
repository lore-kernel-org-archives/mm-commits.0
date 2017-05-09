From: akpm@linux-foundation.org
Subject: [merged] bcache-use-kvmalloc.patch removed from -mm tree
Date: Tue, 09 May 2017 11:02:51 -0700
Message-ID: <20170509180251.-gEt_h9G1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754061AbdEISCw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kent.overstreet@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: drivers/md/bcache/super.c: use kvmalloc
has been removed from the -mm tree.  Its filename was
     bcache-use-kvmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: drivers/md/bcache/super.c: use kvmalloc

bcache_device_init uses kmalloc for small requests and vmalloc for those
which are larger than 64 pages.  This alone is a strange criterion. 
Moreover kmalloc can fallback to vmalloc on the failure.  Let's simply use
kvmalloc instead as it knows how to handle the fallback properly

Link: http://lkml.kernel.org/r/20170306103327.2766-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/md/bcache/super.c~bcache-use-kvmalloc drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~bcache-use-kvmalloc
+++ a/drivers/md/bcache/super.c
@@ -767,16 +767,12 @@ static int bcache_device_init(struct bca
 	}
 
 	n = d->nr_stripes * sizeof(atomic_t);
-	d->stripe_sectors_dirty = n < PAGE_SIZE << 6
-		? kzalloc(n, GFP_KERNEL)
-		: vzalloc(n);
+	d->stripe_sectors_dirty = kvzalloc(n, GFP_KERNEL);
 	if (!d->stripe_sectors_dirty)
 		return -ENOMEM;
 
 	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
-	d->full_dirty_stripes = n < PAGE_SIZE << 6
-		? kzalloc(n, GFP_KERNEL)
-		: vzalloc(n);
+	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
 	if (!d->full_dirty_stripes)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from mhocko@suse.com are


