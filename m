Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E642C43217
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC5C61104
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhIHDCi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347442AbhIHDCE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C331361152;
        Wed,  8 Sep 2021 03:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070057;
        bh=ooeEuDuwaL6UMKs+jETcwC8p0NNEc8QLgYfQv09ho1E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JUcCqMkiCuBHcHTta6k4Zyb4sxsVtPumZIO7aAqQ1rGmU1b15qHUPFcQmw7ktUNZS
         H2DwgNADnG1BOHWmpEHRwhfy3gqxnF9Ygt0g5m/175wSF1b4Qglw5XDanGNk5ptcx9
         3usoTmy7fIhorBJXCqUr/fPkU4FRaCHP874eT8Ys=
Date:   Tue, 07 Sep 2021 20:00:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 146/147] mm/workingset: correct kernel-doc
 notations
Message-ID: <20210908030056.VBbPVyund%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/workingset: correct kernel-doc notations

Use the documented kernel-doc format to prevent kernel-doc warnings.

mm/workingset.c:256: warning: No description found for return value of 'workingset_eviction'
mm/workingset.c:285: warning: Function parameter or member 'folio' not described in 'workingset_refault'
mm/workingset.c:285: warning: Excess function parameter 'page' description in 'workingset_refault'

Link: https://lkml.kernel.org/r/20210808203153.10678-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-workingset-correct-kernel-doc-notations
+++ a/mm/workingset.c
@@ -249,7 +249,7 @@ void workingset_age_nonresident(struct l
  * @target_memcg: the cgroup that is causing the reclaim
  * @page: the page being evicted
  *
- * Returns a shadow entry to be stored in @page->mapping->i_pages in place
+ * Return: a shadow entry to be stored in @page->mapping->i_pages in place
  * of the evicted @page so that a later refault can be detected.
  */
 void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg)
_
