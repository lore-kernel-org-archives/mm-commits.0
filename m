From: akpm@linux-foundation.org
Subject: [patch 10/18] mm/cma.c: take __GFP_NOWARN into account in
 cma_alloc()
Date: Fri, 13 Oct 2017 15:58:01 -0700
Message-ID: <59e144f9.lvnY81GsTtEVsrVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbdJMW6D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, boris.brezillon@free-electrons.com, airlied@linux.ie, daniel@ffwll.ch, eric@anholt.net, iamjoonsoo.kim@lge.com, jaewon31.kim@samsung.com, labbott@redhat.com

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
