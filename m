From: akpm@linux-foundation.org
Subject: [patch 052/131] mm/cma.c: change pr_info to pr_err for
 cma_alloc fail log
Date: Wed, 15 Nov 2017 17:34:26 -0800
Message-ID: <20171116013426.mL15qDcsc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdKPBe2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, jaewon31.kim@samsung.com, labbott@redhat.com, mm-commits@vger.kernel.org, opendmb@gmail.com, pintu.ping@gmail.com, torvalds@linux-foundation.org

From: Pintu Agarwal <pintu.ping@gmail.com>
Subject: mm/cma.c: change pr_info to pr_err for cma_alloc fail log

It was observed that under cma_alloc fail log, pr_info was used instead of
pr_err.  This will lead to problems if printk debug level is set to below
7.  In this case the cma_alloc failure log will not be captured in the log
and it will be difficult to debug.

Simply replace the pr_info with pr_err to capture failure log.

Link: http://lkml.kernel.org/r/1507650633-4430-1-git-send-email-pintu.ping@gmail.com
Signed-off-by: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/cma.c~cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log mm/cma.c
--- a/mm/cma.c~cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log
+++ a/mm/cma.c
@@ -461,7 +461,7 @@ struct page *cma_alloc(struct cma *cma,
 	trace_cma_alloc(pfn, page, count, align);
 
 	if (ret && !(gfp_mask & __GFP_NOWARN)) {
-		pr_info("%s: alloc failed, req-size: %zu pages, ret: %d\n",
+		pr_err("%s: alloc failed, req-size: %zu pages, ret: %d\n",
 			__func__, count, ret);
 		cma_debug_show_areas(cma);
 	}
_
