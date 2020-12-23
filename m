Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F82CC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D56622AAA
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLWA3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgLWA3k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:29:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C42EF22A83;
        Wed, 23 Dec 2020 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608683339;
        bh=8tYaSWSQaD5VVggQ46knqNsGFVrQdmC7yX43o/xX+uQ=;
        h=Date:From:To:Subject:From;
        b=NnLSTJ08LWiCFY44o6DRhoK3bDJOiwPo430n0XGmhD+o5c4edFd7SMCFW7WvFJ1Mx
         ovrJD7MeJq3Cp83G5akyFj0IGlmIyvG7C0LL77t18yg/eIDh5Y8Cm/jyY2FgBkkF3b
         MnaoFeJbdP8ExXZnLuvFaV1NmRM49QXd7JpFeZfU=
Date:   Tue, 22 Dec 2020 16:28:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, alexander.h.duyck@linux.intel.com,
        akpm@linux-foundation.org, sh_def@163.com
Subject:  +
 mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch added
 to -mm tree
Message-ID: <20201223002859.hdWJp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()
has been added to the -mm tree.  Its filename is
     mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: sh <sh_def@163.com>
Subject: mm/page_reporting: use list_entry_is_head() in page_reporting_cycle()

Replace '&next->lru != list' with list_entry_is_head().  No functional
change.

Link: https://lkml.kernel.org/r/20201222182735.GA1257912@ubuntu-A520I-AC
Signed-off-by: sh <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle
+++ a/mm/page_reporting.c
@@ -211,7 +211,7 @@ page_reporting_cycle(struct page_reporti
 	}
 
 	/* Rotate any leftover pages to the head of the freelist */
-	if (&next->lru != list && !list_is_first(&next->lru, list))
+	if (!list_entry_is_head(next, list, lru) && !list_is_first(&next->lru, list))
 		list_rotate_to_front(&next->lru, list);
 
 	spin_unlock_irq(&zone->lock);
_

Patches currently in -mm which might be from sh_def@163.com are

mm-page_reporting-use-list_entry_is_head-in-page_reporting_cycle.patch

