From: akpm@linux-foundation.org
Subject: [merged] lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:55:08 -0700
Message-ID: <20120731185509.03E30100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2GaSzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:55:10 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:55:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, airlied@redhat.com, amwang@redhat.com, axboe@kernel.dk, daniel.vetter@ffwll.ch, inki.dae@samsung.com, olofj@chromium.org, paul.gortmaker@windriver.com, rob.clark@linaro.org, sonnyrao@chromium.org, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: do not re-write gfp_flags in __sg_alloc_table()
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: lib/scatterlist: do not re-write gfp_flags in __sg_alloc_table()

We are seeing a lot of sg_alloc_table allocation failures using the new
drm prime infrastructure.  We isolated the cause to code in
__sg_alloc_table that was re-writing the gfp_flags.

There is a comment in the code that suggest that there is an assumption
about the allocation coming from a memory pool.  This was likely true when
sg lists were primarily used for disk I/O.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <rob.clark@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table
+++ a/lib/scatterlist.c
@@ -279,14 +279,6 @@ int __sg_alloc_table(struct sg_table *ta
 		if (!left)
 			sg_mark_end(&sg[sg_size - 1]);
 
-		/*
-		 * only really needed for mempool backed sg allocations (like
-		 * SCSI), a possible improvement here would be to pass the
-		 * table pointer into the allocator and let that clear these
-		 * flags
-		 */
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
 		prv = sg;
 	} while (left);
 
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch

