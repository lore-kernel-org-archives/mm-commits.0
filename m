Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D975EB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjFXAAs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjFXAA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71DB271F
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3211F614A8
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E2C433C0;
        Sat, 24 Jun 2023 00:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564824;
        bh=jx/y4gVOspkMYSaiy2B2r6zCCQBH0D8u4l7oiw3l9LY=;
        h=Date:To:From:Subject:From;
        b=g5d4Owt5Yu+D5e92O1FJlOnpPBKcU/oGcDr0IHkCIjvQMWFR1bicFKPyRVqylNMQc
         e7iuAXdXQTuuES5FZKl7/1Mh5x4kJP7kyQqtIJI4lDzkCljL1ocFAZzIbF7bs0pLvr
         Z+2osvHRxcughiKMT+yYB6jObFqfcNiB1ue0IJ1Q=
Date:   Fri, 23 Jun 2023 17:00:23 -0700
To:     mm-commits@vger.kernel.org, chuck.lever@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] net-convert-sunrpc-from-pagevec-to-folio_batch.patch removed from -mm tree
Message-Id: <20230624000024.8A0E2C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: net: convert sunrpc from pagevec to folio_batch
has been removed from the -mm tree.  Its filename was
     net-convert-sunrpc-from-pagevec-to-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: net: convert sunrpc from pagevec to folio_batch
Date: Wed, 21 Jun 2023 17:45:53 +0100

Remove the last usage of pagevecs.  There is a slight change here; we now
free the folio_batch as soon as it fills up instead of freeing the
folio_batch when we try to add a page to a full batch.  This should have
no effect in practice.

Link: https://lkml.kernel.org/r/20230621164557.3510324-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    2 +-
 net/sunrpc/svc.c           |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/sunrpc/svc.h~net-convert-sunrpc-from-pagevec-to-folio_batch
+++ a/include/linux/sunrpc/svc.h
@@ -223,7 +223,7 @@ struct svc_rqst {
 	struct page *		*rq_next_page; /* next reply page to use */
 	struct page *		*rq_page_end;  /* one past the last page */
 
-	struct pagevec		rq_pvec;
+	struct folio_batch	rq_fbatch;
 	struct kvec		rq_vec[RPCSVC_MAXPAGES]; /* generally useful.. */
 	struct bio_vec		rq_bvec[RPCSVC_MAXPAGES];
 
--- a/net/sunrpc/svc.c~net-convert-sunrpc-from-pagevec-to-folio_batch
+++ a/net/sunrpc/svc.c
@@ -649,7 +649,7 @@ svc_rqst_alloc(struct svc_serv *serv, st
 	if (!rqstp)
 		return rqstp;
 
-	pagevec_init(&rqstp->rq_pvec);
+	folio_batch_init(&rqstp->rq_fbatch);
 
 	__set_bit(RQ_BUSY, &rqstp->rq_flags);
 	rqstp->rq_server = serv;
@@ -860,9 +860,9 @@ bool svc_rqst_replace_page(struct svc_rq
 	}
 
 	if (*rqstp->rq_next_page) {
-		if (!pagevec_space(&rqstp->rq_pvec))
-			__pagevec_release(&rqstp->rq_pvec);
-		pagevec_add(&rqstp->rq_pvec, *rqstp->rq_next_page);
+		if (!folio_batch_add(&rqstp->rq_fbatch,
+				page_folio(*rqstp->rq_next_page)))
+			__folio_batch_release(&rqstp->rq_fbatch);
 	}
 
 	get_page(page);
@@ -896,7 +896,7 @@ void svc_rqst_release_pages(struct svc_r
 void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
-	pagevec_release(&rqstp->rq_pvec);
+	folio_batch_release(&rqstp->rq_fbatch);
 	svc_release_buffer(rqstp);
 	if (rqstp->rq_scratch_page)
 		put_page(rqstp->rq_scratch_page);
_

Patches currently in -mm which might be from willy@infradead.org are


