From: akpm@linux-foundation.org
Subject: + lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table.patch added to -mm tree
Date: Fri, 13 Jul 2012 15:21:04 -0700
Message-ID: <20120713222104.D7C311E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55378 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2GMWVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 18:21:07 -0400
Received: by ggeh3 with SMTP id h3so390950gge.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 15:21:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, airlied@redhat.com, amwang@redhat.com, axboe@kernel.dk, daniel.vetter@ffwll.ch, inki.dae@samsung.com, olofj@chromium.org, paul.gortmaker@windriver.com, rob.clark@linaro.org, sonnyrao@chromium.org, sumit.semwal@linaro.org


The patch titled
     Subject: lib/scatterlist: do not re-write gfp_flags in __sg_alloc_table()
has been added to the -mm tree.  Its filename is
     lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: lib/scatterlist: do not re-write gfp_flags in __sg_alloc_table()

Patches currently in -mm which might be from msb@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
lib-scatterlist-do-not-re-write-gfp_flags-in-__sg_alloc_table.patch

