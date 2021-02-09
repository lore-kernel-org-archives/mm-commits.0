Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0808BC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 19:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF3764DE8
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 19:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhBITbD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 14:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233528AbhBITTn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 14:19:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E35BE64ECB;
        Tue,  9 Feb 2021 19:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612898298;
        bh=cv09Xs6tXP9gW4lIVgDFGbzPVoqA77LH4zLYPAmt/vI=;
        h=Date:From:To:Subject:From;
        b=VJ490gj0fE9fv5b/YMEnV+QT67PFz/q3Ks3SorE8XUhKfZCDNOSgJNRsJgniPYkZ/
         u+5q/NNLTIWMrR+J6j75AuPcxxPQCqSQDdUDyigCNsDaBmIKhx0bxSc43oySUbvC0T
         R5/YWPJW3AqdYhn3csfnDawEGvZJD+DtxZHYxacE=
Date:   Tue, 09 Feb 2021 11:18:17 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, pdaly@codeaurora.org,
        rdunlap@infradead.org
Subject:  + mm-cma-print-region-name-on-failure-v2.patch added to
 -mm tree
Message-ID: <20210209191817.PTxm9wr7U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-print-region-name-on-failure-v2
has been added to the -mm tree.  Its filename is
     mm-cma-print-region-name-on-failure-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-print-region-name-on-failure-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-print-region-name-on-failure-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Patrick Daly <pdaly@codeaurora.org>
Subject: mm-cma-print-region-name-on-failure-v2

print the "count" variable, as it was originally in the code, per Randy

Link: https://lkml.kernel.org/r/20210209142414.12768-1-georgi.djakov@linaro.org
Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-print-region-name-on-failure-v2
+++ a/mm/cma.c
@@ -501,7 +501,7 @@ struct page *cma_alloc(struct cma *cma,
 
 	if (ret && !no_warn) {
 		pr_err("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
-		       __func__, cma->name, cma->count, ret);
+		       __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
 
_

Patches currently in -mm which might be from pdaly@codeaurora.org are

mm-cma-print-region-name-on-failure.patch
mm-cma-print-region-name-on-failure-v2.patch

