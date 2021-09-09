Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69859C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579CE611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347849AbhIIVHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348000AbhIIVGr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E346120D;
        Thu,  9 Sep 2021 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221537;
        bh=2iGJj2GXGymjzoP114PMyDxupPN3atrXWTPotS5QUwI=;
        h=Date:From:To:Subject:From;
        b=WKAxazA/yDWzS649S1K3+oo4bT0cqWUATY6GgYGEr/vlHdBHA1Sp3SyS3/qbVzHyj
         3MMSY74hpY31kW7mHuNrxRUA+6H6dcbWDkacTaLocAQsCCvH4wSG3u57W4AG6SG/hO
         iAVa/1cCJwWt4xWcFdISGveXN4O1sMidqQTPp3cE=
Date:   Thu, 09 Sep 2021 14:05:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        willy@infradead.org
Subject:  [merged] mm-workingset-correct-kernel-doc-notations.patch
 removed from -mm tree
Message-ID: <20210909210537.oA4Q7GjHY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset: correct kernel-doc notations
has been removed from the -mm tree.  Its filename was
     mm-workingset-correct-kernel-doc-notations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


