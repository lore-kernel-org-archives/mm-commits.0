Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7462EC4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32275221F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9RR9omM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgKPUhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgKPUhK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:37:10 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E68A208C3;
        Mon, 16 Nov 2020 20:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605559029;
        bh=UVcY0gYSp4SsFcFwCo9GkuJfiF7AvLzCHtHqqpJ/pv4=;
        h=Date:From:To:Subject:From;
        b=X9RR9omM8BQlpeCXhdRJpu9OhcmlyBgZn8g4bKWPylzse81hYYnbSEk0KW7OXg4YQ
         t82HvPiOz3YOM+hIEuI1R6IG82AOSYI7zwstVTnUECxW2zuGCS9mjGlp7Eke8LciRL
         5HhqucampYz7Oflqs2G476FyK4cIPqOsHT4EDpCI=
Date:   Mon, 16 Nov 2020 12:37:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zou_wei@huawei.com
Subject:  +
 mm-page_alloc-mark-some-symbols-with-static-keyword.patch added to -mm tree
Message-ID: <20201116203709.BbpfWdD1k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: mark some symbols with static keyword
has been added to the -mm tree.  Its filename is
     mm-page_alloc-mark-some-symbols-with-static-keyword.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-mark-some-symbols-with-static-keyword.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-mark-some-symbols-with-static-keyword.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zou Wei <zou_wei@huawei.com>
Subject: mm/page_alloc: mark some symbols with static keyword

Fix the following sparse warnings:

mm/page_alloc.c:3040:6: warning: symbol '__drain_all_pages' was not declared. Should it be static?
mm/page_alloc.c:6349:6: warning: symbol '__zone_set_pageset_high_and_batch' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1605517365-65858-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-mark-some-symbols-with-static-keyword
+++ a/mm/page_alloc.c
@@ -3034,7 +3034,7 @@ static void drain_local_pages_wq(struct
  * that need the guarantee that every CPU has drained can disable the
  * optimizing racy check.
  */
-void __drain_all_pages(struct zone *zone, bool force_all_cpus)
+static void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
 
@@ -6343,7 +6343,7 @@ static void pageset_init(struct per_cpu_
 	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
-void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
+static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
 		unsigned long batch)
 {
 	struct per_cpu_pageset *p;
_

Patches currently in -mm which might be from zou_wei@huawei.com are

mm-page_alloc-mark-some-symbols-with-static-keyword.patch

