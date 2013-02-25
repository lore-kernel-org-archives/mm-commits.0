From: akpm@linux-foundation.org
Subject: + lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch added to -mm tree
Date: Mon, 25 Feb 2013 15:47:43 -0800
Message-ID: <20130225234743.AC38F5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:35826 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3BYXro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 18:47:44 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so370997ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 15:47:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@intel.com, daniel.vetter@ffwll.ch, james.hogan@imgtec.com, maximlevitsky@gmail.com, swarren@wwwdotorg.org, tj@kernel.org


The patch titled
     Subject: lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix
has been added to the -mm tree.  Its filename is
     lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
lib-scatterlist-add-simple-page-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch

