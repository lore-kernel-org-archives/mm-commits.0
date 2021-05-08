Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CD5C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D5861415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWqo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWqn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D91E6100C;
        Sat,  8 May 2021 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513942;
        bh=JAJSCHt9SIlxqZd6nJXlrcdwYPLZwbXn5A9RbySbStA=;
        h=Date:From:To:Subject:From;
        b=n/z3Qx2//yxAcfpRs6cuVRW0bXeq5ul32GegI81V9ihxX/5fsN4ZAeBbbcxCom0eY
         1HYJ4EUkur6Nj3StGmu9c5CAKlh5ql5P0AaX1vLRQasFDCNTGUNa9+yjWVhoR8Fg8w
         zGaRHMNAU8nXx2UqakOOXUxG4P0bGzNJrMTZI0Y8=
Date:   Sat, 08 May 2021 15:45:41 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch removed from -mm
 tree
Message-ID: <20210508224541.kf5VkEN59%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: SUNRPC: refresh rq_pages using a bulk page allocator
has been removed from the -mm tree.  Its filename was
     sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chuck Lever <chuck.lever@oracle.com>
Subject: SUNRPC: refresh rq_pages using a bulk page allocator

Reduce the rate at which nfsd threads hammer on the page allocator.  This
improves throughput scalability by enabling the threads to run more
independently of each other.

[mgorman: Update interpretation of alloc_pages_bulk return value]
Link: https://lkml.kernel.org/r/20210325114228.27719-8-mgorman@techsingularity.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svc_xprt.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/net/sunrpc/svc_xprt.c~sunrpc-refresh-rq_pages-using-a-bulk-page-allocator
+++ a/net/sunrpc/svc_xprt.c
@@ -662,30 +662,29 @@ static int svc_alloc_arg(struct svc_rqst
 {
 	struct svc_serv *serv = rqstp->rq_server;
 	struct xdr_buf *arg = &rqstp->rq_arg;
-	int pages;
-	int i;
+	unsigned long pages, filled;
 
-	/* now allocate needed pages.  If we get a failure, sleep briefly */
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
-		pr_warn_once("svc: warning: pages=%u > RPCSVC_MAXPAGES=%lu\n",
+		pr_warn_once("svc: warning: pages=%lu > RPCSVC_MAXPAGES=%lu\n",
 			     pages, RPCSVC_MAXPAGES);
 		/* use as many pages as possible */
 		pages = RPCSVC_MAXPAGES;
 	}
-	for (i = 0; i < pages ; i++)
-		while (rqstp->rq_pages[i] == NULL) {
-			struct page *p = alloc_page(GFP_KERNEL);
-			if (!p) {
-				set_current_state(TASK_INTERRUPTIBLE);
-				if (signalled() || kthread_should_stop()) {
-					set_current_state(TASK_RUNNING);
-					return -EINTR;
-				}
-				schedule_timeout(msecs_to_jiffies(500));
-			}
-			rqstp->rq_pages[i] = p;
+
+	for (;;) {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, pages,
+						rqstp->rq_pages);
+		if (filled == pages)
+			break;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (signalled() || kthread_should_stop()) {
+			set_current_state(TASK_RUNNING);
+			return -EINTR;
 		}
+		schedule_timeout(msecs_to_jiffies(500));
+	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
_

Patches currently in -mm which might be from chuck.lever@oracle.com are


