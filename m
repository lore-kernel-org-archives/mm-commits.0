From: akpm@linux-foundation.org
Subject: + cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log.patch added to -mm tree
Date: Tue, 10 Oct 2017 13:30:58 -0700
Message-ID: <59dd2e02.UHMrZkg7y57e+80B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932791AbdJJUa7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.ping@gmail.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, jaewon31.kim@samsung.com, labbott@redhat.com, opendmb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: change pr_info to pr_err for cma_alloc fail log
has been added to the -mm tree.  Its filename is
     cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from pintu.ping@gmail.com are

cma-change-pr_info-to-pr_err-for-cma_alloc-fail-log.patch

