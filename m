From: akpm@linux-foundation.org
Subject: [folded-dropped] lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:38:42 -0800
Message-ID: <20130228003842.EFA425A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45053 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3B1Aio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:38:44 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so139002qea.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:38:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@intel.com, daniel.vetter@ffwll.ch, james.hogan@imgtec.com, maximlevitsky@gmail.com, swarren@wwwdotorg.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch

This patch was dropped because it was folded into lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

------------------------------------------------------
From: Imre Deak <imre.deak@intel.com>
Subject: lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix

- Fix the mapping size to be page-size limited. Thanks to Stephen Warren
  for tracking down the bug.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix
+++ a/lib/scatterlist.c
@@ -493,6 +493,8 @@ bool sg_miter_next(struct sg_mapping_ite
 		miter->__offset = pgoffset ? 0 : sg->offset;
 		miter->__remaining = sg->offset + sg->length -
 				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
 	}
 	miter->page = miter->piter.page;
 	miter->consumed = miter->length = miter->__remaining;
_

Patches currently in -mm which might be from imre.deak@intel.com are

origin.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch

