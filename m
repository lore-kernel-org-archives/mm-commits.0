Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0AEC56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60DE020B1F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vzde6B+G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgKYXmz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgKYXmy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 18:42:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1B42083E;
        Wed, 25 Nov 2020 23:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606347774;
        bh=6aloR2NjG+nou8aMWjrtZipFFIniJPUD9ILTAcs0Gpg=;
        h=Date:From:To:Subject:From;
        b=Vzde6B+GU0k4jYzUHPqIZnWKO0Ua8mUMdwAoe9pzMaEPmdFE3i8GpIQqfU/emX16G
         sfYy5WWy+wsnAkn+l924IBL0tuHEV19kL1siS32o45b0QBYncS5LEno3BQvADADGOe
         I8ilCp3uv9SiKlD4UYmXopMzJbsgRnpQLjz56NI8=
Date:   Wed, 25 Nov 2020 15:42:53 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        zou_wei@huawei.com
Subject:  +
 mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch added to -mm
 tree
Message-ID: <20201125234253.2PIE6he6F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: mark sort_page_lruvec with static keyword
has been added to the -mm tree.  Its filename is
     mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch

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
Subject: mm/swap.c: mark sort_page_lruvec with static keyword

Fix the following sparse warning:

mm/swap.c:1018:5: warning: symbol 'sort_page_lruvec' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1606218425-3874-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swapc-reduce-lock-contention-in-lru_cache_add-fix
+++ a/mm/swap.c
@@ -1015,7 +1015,7 @@ struct lruvecs {
 };
 
 /* Sort pvec pages on their lruvec */
-int sort_page_lruvec(struct lruvecs *lruvecs, struct pagevec *pvec)
+static int sort_page_lruvec(struct lruvecs *lruvecs, struct pagevec *pvec)
 {
 	int i, j, nr_lruvec;
 	struct page *page;
_

Patches currently in -mm which might be from zou_wei@huawei.com are

mm-page_alloc-mark-some-symbols-with-static-keyword.patch
mm-swapc-reduce-lock-contention-in-lru_cache_add-fix.patch

