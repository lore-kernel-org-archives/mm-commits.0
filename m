Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6382DEB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjFUUOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjFUUOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E457919B7
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A615616A2
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4DAC433C8;
        Wed, 21 Jun 2023 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378465;
        bh=yVVg96h3pmdiFgs1AUEJ6IaO4TiYUntu1xRJ3LsIEq4=;
        h=Date:To:From:Subject:From;
        b=ttm5dsJdTfdnlA2VpPHuJsSAhQdViOe9Dtyq4SwFn02ewXDnKrwo07KrgRZEHg1pA
         T0Rt5xNy+ggHnyaJb+4i2LAkFb/xQSOQHJ6x65qt2Sj/M2Jo7C2VGjXw9dtoDpAqw7
         w70RtvwqOXw3GLnACmlME302PtF+KobZB6CJ/4+E=
Date:   Wed, 21 Jun 2023 13:14:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-convert-sunrpc-from-pagevec-to-folio_batch.patch added to mm-unstable branch
Message-Id: <20230621201425.CE4DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: convert sunrpc from pagevec to folio_batch
has been added to the -mm mm-unstable branch.  Its filename is
     net-convert-sunrpc-from-pagevec-to-folio_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-convert-sunrpc-from-pagevec-to-folio_batch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

