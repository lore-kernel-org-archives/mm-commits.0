From: akpm@linux-foundation.org
Subject: [merged]
 cma-take-__gfp_nowarn-into-account-in-cma_alloc.patch removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:39 -0700
Message-ID: <20171016195539.0WokyMc2r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755750AbdJPTzl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, boris.brezillon@free-electrons.com, daniel@ffwll.ch, eric@anholt.net, iamjoonsoo.kim@lge.com, jaewon31.kim@samsung.com, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: take __GFP_NOWARN into account in cma_alloc()
has been removed from the -mm tree.  Its filename was
     cma-take-__gfp_nowarn-into-account-in-cma_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: mm/cma.c: take __GFP_NOWARN into account in cma_alloc()

cma_alloc() unconditionally prints an INFO message when the CMA allocation
fails.  Make this message conditional on the non-presence of __GFP_NOWARN
in gfp_mask.

This patch aims at removing INFO messages that are displayed when the VC4
driver tries to allocate buffer objects.  From the driver perspective an
allocation failure is acceptable, and the driver can possibly do something
to make following allocation succeed (like flushing the VC4 internal
cache).

Link: http://lkml.kernel.org/r/20171004125447.15195-1-boris.brezillon@free-electrons.com
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Laura Abbott <labbott@redhat.com>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Eric Anholt <eric@anholt.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma.c~cma-take-__gfp_nowarn-into-account-in-cma_alloc mm/cma.c
--- a/mm/cma.c~cma-take-__gfp_nowarn-into-account-in-cma_alloc
+++ a/mm/cma.c
@@ -460,7 +460,7 @@ struct page *cma_alloc(struct cma *cma,
 
 	trace_cma_alloc(pfn, page, count, align);
 
-	if (ret) {
+	if (ret && !(gfp_mask & __GFP_NOWARN)) {
 		pr_info("%s: alloc failed, req-size: %zu pages, ret: %d\n",
 			__func__, count, ret);
 		cma_debug_show_areas(cma);
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are


