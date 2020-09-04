Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A13C2BB84
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 346D6208CA
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243201;
	bh=62ABG+yuAsCnS5E/2WmCxr32skkNnCfkkpaP0eyVivs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2eOTnAb7qTJ1YC1I03dd4fA2+VXxL8pWgcHoMyo7L/Zym/rW/dRlQXkRkyvcLFkc6
	 d5nfn2JJdY/cZ5v+x8CFTlUh7FTAv+tikE4QEuE4Fv2GuKq0ojbwmhR8s1gikuvVJp
	 BOPMToBte1ObsvKe3mVyHix2Q2Sl7BEKCkTr9a4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIDSNU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgIDSNS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:13:18 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B06208CA;
        Fri,  4 Sep 2020 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599243198;
        bh=62ABG+yuAsCnS5E/2WmCxr32skkNnCfkkpaP0eyVivs=;
        h=Date:From:To:Subject:From;
        b=0cfLbu90BUCDbtdEOZtCecOvdWCdFUEm4taegBJOV/8qbl3tIkFrzXIMkWzmGg2bL
         ZfRyiWVSwA7xWoAO6jJ+0EelBrCu4asPFBZfEbTaIHGpwE7g5Afxxt4AJ+qcm5CFvQ
         dAdhnK8NpIe43f33tQ6dqqbsKtfyzkRpvsa/tsVA=
Date:   Fri, 04 Sep 2020 11:13:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        mateusznosek0@gmail.com
Subject:  +
 mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch added
 to -mm tree
Message-ID: <20200904181317.JplfR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean code by removing unnecessary initialization
has been added to the -mm tree.  Its filename is
     mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: clean code by removing unnecessary initialization

Previously variable 'tmp' was initialized, but was not read later before
reassigning.  So the initialization can be removed.

Link: https://lkml.kernel.org/r/20200904132422.17387-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-removing-unnecessary-initialization
+++ a/mm/page_alloc.c
@@ -5637,7 +5637,7 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
-	const struct cpumask *tmp = cpumask_of_node(0);
+	const struct cpumask *tmp;
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch

