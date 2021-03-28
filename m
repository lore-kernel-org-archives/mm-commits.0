Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC3CC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB8061935
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhC1Wbv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhC1WbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C148F6192F;
        Sun, 28 Mar 2021 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970685;
        bh=S2lsyrqbNeTmqafqlMY9rT8WxAEFGCZ7coqjRNFxHQE=;
        h=Date:From:To:Subject:From;
        b=2gshJ9Ff2quZm2VXsl/Iq+shYiZilqAvOsjiooUEyPlMdJH8XHGQ7q336eGL+v8QJ
         Uez+f8CMjErlpQn6i39EoBkWL8TuUY6vMm0ERtvGNB9QZTOL6/6J+A8G2g3/W0MMC8
         qHt+UcKS5YrVdWT8U/3aR7cZ6KbaJNyKCi971xHk=
Date:   Sun, 28 Mar 2021 15:31:24 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  + sunrpc-set-rq_page_end-differently.patch added to -mm
 tree
Message-ID: <20210328223124.RiwH9QaDz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: SUNRPC: set rq_page_end differently
has been added to the -mm tree.  Its filename is
     sunrpc-set-rq_page_end-differently.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sunrpc-set-rq_page_end-differently.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sunrpc-set-rq_page_end-differently.patch

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
@@ -642,7 +642,7 @@ static void svc_check_conn_limits(struct
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
-	struct xdr_buf *arg;
+	struct xdr_buf *arg = &rqstp->rq_arg;
 	int pages;
 	int i;
 
@@ -667,11 +667,10 @@ static int svc_alloc_arg(struct svc_rqst
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

Patches currently in -mm which might be from chuck.lever@oracle.com are

sunrpc-set-rq_page_end-differently.patch
sunrpc-refresh-rq_pages-using-a-bulk-page-allocator.patch

