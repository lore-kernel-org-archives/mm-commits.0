Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E34C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E702161456
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3GCv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhD3GCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E9F61424;
        Fri, 30 Apr 2021 06:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762522;
        bh=9S7BEF/aasNkIIfeKVjPbspQqsiZKOJerDz10d4oL0w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OQ7eKLTlLShL8rZZllbhNNVxevUH8VBmFUkJVLH7KnGO5mbvQbEMw97E0dN9YlJAB
         1zFDSl0xy0nKB99YQm5YfuHMHZPTMmKa7FpkpTlqTl0OR6ogRvFcWSOIliyQmOIt7+
         j2TXOQsw75Zw0P1mIdzDVZdyLRvyNtb25M3S9Cwc=
Date:   Thu, 29 Apr 2021 23:02:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 172/178] SUNRPC: refresh rq_pages using a bulk
 page allocator
Message-ID: <20210430060201.Yqh6yZgTy%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
