Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB5DC433E1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C4D6192B
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhC1WbV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhC1WbQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B77D26192B;
        Sun, 28 Mar 2021 22:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970676;
        bh=9/Us2cfTLN0dOzaXxdqnH9sRe6M7MotCSBxHxz6/nKk=;
        h=Date:From:To:Subject:From;
        b=kkxncXW9g1h8CadexxuiWPQr2KCLGPIJ82ogI8o89eKVr/G89gQcRPq3IMmyk5DMP
         5WDbDFNgBKJS/YvLmrfnJ6azczAGMUtDYu3eBJ0tcWrOPAsLYYYRqPQaLincRCpTnB
         L63ojl1lRAo8b6NFbYXW//sEJrpfN5wjO/YUSccI=
Date:   Sun, 28 Mar 2021 15:31:15 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch added to -mm tree
Message-ID: <20210328223115.T5AvR5jzV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: SUNRPC: refresh rq_pages using a bulk page allocator
has been added to the -mm tree.  Its filename is
     sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -643,30 +643,29 @@ static int svc_alloc_arg(struct svc_rqst
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

sunrpc-set-rq_page_end-differently.patch
sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch

