Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3482AC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C47261450
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhD3GCr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3GCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA8C1613AD;
        Fri, 30 Apr 2021 06:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762519;
        bh=jfCA3DrrnjFCDrmOt6HauUBGUxKQ4tO/brGzf5Z+he4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FpZ01qOmQL8xS1tP3EPaiWHuAMqwySW5gIjxNElfjcqnajQnK1RafC4VdcxkSBrSl
         r4hbrjVUbOZ/N4vea9nFxrzsf05wQmJP8r/8NuTmOdYY1GybND+BPaUA0WIluZwLMN
         1OYbRPLRYqSncnxiiWNfslNQtgCK0rIbQr70DgcQ=
Date:   Thu, 29 Apr 2021 23:01:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 171/178] SUNRPC: set rq_page_end differently
Message-ID: <20210430060158.L6Qo6kR9i%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>
Subject: SUNRPC: set rq_page_end differently

Patch series "SUNRPC consumer for the bulk page allocator"

This patch set and the measurements below are based on yesterday's
bulk allocator series:

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9

The patches change SUNRPC to invoke the array-based bulk allocator
instead of alloc_page().

The micro-benchmark results are promising. I ran a mixture of 256KB
reads and writes over NFSv3. The server's kernel is built with KASAN
enabled, so the comparison is exaggerated but I believe it is still
valid.

I instrumented svc_recv() to measure the latency of each call to
svc_alloc_arg() and report it via a trace point. The following
results are averages across the trace events.

Single page: 25.007 us per call over 532,571 calls
Bulk list:    6.258 us per call over 517,034 calls
Bulk array:   4.590 us per call over 517,442 calls

This patch (of 2)

Refactor:

I'm about to use the loop variable @i for something else.

As far as the "i++" is concerned, that is a post-increment. The
value of @i is not used subsequently, so the increment operator
is unnecessary and can be removed.

Also note that nfsd_read_actor() was renamed nfsd_splice_actor()
by commit cf8208d0eabd ("sendfile: convert nfsd to
splice_direct_to_actor()").

Link: https://lkml.kernel.org/r/20210325114228.27719-7-mgorman@techsingularity.net
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

 net/sunrpc/svc_xprt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/sunrpc/svc_xprt.c~sunrpc-set-rq_page_end-differently
+++ a/net/sunrpc/svc_xprt.c
@@ -661,7 +661,7 @@ static void svc_check_conn_limits(struct
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
-	struct xdr_buf *arg;
+	struct xdr_buf *arg = &rqstp->rq_arg;
 	int pages;
 	int i;
 
@@ -686,11 +686,10 @@ static int svc_alloc_arg(struct svc_rqst
 			}
 			rqstp->rq_pages[i] = p;
 		}
-	rqstp->rq_page_end = &rqstp->rq_pages[i];
-	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	rqstp->rq_page_end = &rqstp->rq_pages[pages];
+	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
 	/* Make arg->head point to first page and arg->pages point to rest */
-	arg = &rqstp->rq_arg;
 	arg->head[0].iov_base = page_address(rqstp->rq_pages[0]);
 	arg->head[0].iov_len = PAGE_SIZE;
 	arg->pages = rqstp->rq_pages + 1;
_
