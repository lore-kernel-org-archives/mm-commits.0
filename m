Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2429EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F2E2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266185;
	bh=juJBPwWqsReU/rtgo3zlEkCmtKHPRKTMOT2OD9CKwsU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lxxdtEctUlER5AKpEVW4Z83Ap2l5hc32JwoYf3xjZ3mEI7YGqq6lYVyNg9a6RBdqa
	 FvEZyIzOQhCrdlNv7TkwzjUJRrTmNgtacGVgzrAMgakTI/jMSnmhSdWJH3IGAmi43v
	 RDJTEuQoOBB/jigeo6P+Y+7jDKjj1HJSxkBktk44=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHLVDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E8120774;
        Wed, 12 Aug 2020 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266183;
        bh=juJBPwWqsReU/rtgo3zlEkCmtKHPRKTMOT2OD9CKwsU=;
        h=Date:From:To:Subject:From;
        b=MvKmQ892myESoErNlDbpMfMd0O2cWta3DGYBjbgWJ+lEv09+WrQo3q+YGSlAd+f75
         C7TQva+VyTaAfd+87P6+fyTUHdZA1hWWLOrk+bM1cZS6u+ToDaCS/sG8Wf6+wHanuq
         Iz5tAN+/A+iGvPguClHYIMM/99jt+zuX4+p8SQrQ=
Date:   Wed, 12 Aug 2020 14:03:03 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-page_allocc-delete-or-fix-duplicated-words.patch removed from -mm tree
Message-ID: <20200812210303.4GEpfr1F3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: delete or fix duplicated words
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-delete-or-fix-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_alloc.c: delete or fix duplicated words

Drop the repeated word "them" and "that".
Change "the the" to "to the".

Link: http://lkml.kernel.org/r/20200801173822.14973-10-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-delete-or-fix-duplicated-words
+++ a/mm/page_alloc.c
@@ -4282,7 +4282,7 @@ retry:
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
 	 * pages are pinned on the per-cpu lists or in high alloc reserves.
-	 * Shrink them them and try again
+	 * Shrink them and try again
 	 */
 	if (!page && !drained) {
 		unreserve_highatomic_pageblock(ac, false);
@@ -6192,7 +6192,7 @@ static int zone_batchsize(struct zone *z
  * locking.
  *
  * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording the the above rule).
+ * those fields changing asynchronously (acording to the above rule).
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
@@ -8203,7 +8203,7 @@ void *__init alloc_large_system_hash(con
  * race condition. So you can't expect this function should be exact.
  *
  * Returns a page without holding a reference. If the caller wants to
- * dereference that page (e.g., dumping), it has to make sure that that it
+ * dereference that page (e.g., dumping), it has to make sure that it
  * cannot get removed (e.g., via memory unplug) concurrently.
  *
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are


