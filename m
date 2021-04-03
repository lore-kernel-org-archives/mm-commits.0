Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C044DC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 01:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 953DF611AE
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 01:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhDCBGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 21:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235721AbhDCBGM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 21:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13F76117A;
        Sat,  3 Apr 2021 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617411969;
        bh=VhiEJF0oVrw2/msBfU99OLPUbNbSEmDZ2BMNcwzCtuA=;
        h=Date:From:To:Subject:From;
        b=RCUucS+GtX/pZZUS0rPNndGvTkAhzWywb7uUmlmA6MEthJhvM84FftFAO9JguvpZK
         GmmIY2rjRwMB0pjyr/EzOfQ8o5QCK6gZIY7Cjr6pFcy+tzGrL1qcG9UzisbRIb0qni
         pDJ9zvwW8d3sF371aRsWzm9IJhY16IAW3LRE3WME=
Date:   Fri, 02 Apr 2021 18:06:09 -0700
From:   akpm@linux-foundation.org
To:     huxiang@uniontech.com, mm-commits@vger.kernel.org
Subject:  +
 mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch added
 to -mm tree
Message-ID: <20210403010609.Ih_O0wEuc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: redundant definition variables of pfn in for loop
has been added to the -mm tree.  Its filename is
     mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: huxiang <huxiang@uniontech.com>
Subject: mm/page_alloc: redundant definition variables of pfn in for loop

This variable pfn is defined repeatedly, so it can be deleted.

Link: https://lkml.kernel.org/r/20210401022802.10358-1-huxiang@uniontech.com
Signed-off-by: huxiang <huxiang@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop
+++ a/mm/page_alloc.c
@@ -3322,7 +3322,7 @@ void free_unref_page_list(struct list_he
 
 	local_irq_save(flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page_private(page);
+		pfn = page_private(page);
 
 		set_page_private(page, 0);
 		trace_mm_page_free_batched(page);
_

Patches currently in -mm which might be from huxiang@uniontech.com are

mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop.patch

