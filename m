Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B07ECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiHaBv0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiHaBvZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29609AF0C4
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9013B81E3B
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B8C433D6;
        Wed, 31 Aug 2022 01:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661910680;
        bh=Mg4IQxJaRDSD5BnUYvXtMKEwjVvXvp9Td1Cp1AR8C40=;
        h=Date:To:From:Subject:From;
        b=w9C5i8LntTpxeIyk6rEzmu1WS1ozNmkjVth6U9vAcRbJCaX6s0QfHnN09f5xDvse5
         QfuGgG1RRMtWWnBbFd359jzlycAh29g63RI+oWRCYwfwJ9DNEtDUS7tRbHw4s7iKO+
         Cr1PJUn7iQI+fMM35j9BibT7B5GMiKNnB29RnYwQ=
Date:   Tue, 30 Aug 2022 18:51:19 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        zuoze1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch added to mm-unstable branch
Message-Id: <20220831015120.739B8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: delete a redundant parameter of rmqueue_pcplist
has been added to the -mm mm-unstable branch.  Its filename is
     mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch

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
From: zezuo <zuoze1@huawei.com>
Subject: mm/page_alloc.c: delete a redundant parameter of rmqueue_pcplist
Date: Wed, 31 Aug 2022 01:34:04 +0000

The gfp_flags parameter is not used in rmqueue_pcplist, so directly delete
this parameter.

Link: https://lkml.kernel.org/r/20220831013404.3360714-1-zuoze1@huawei.com
Signed-off-by: zezuo <zuoze1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-delete-a-redundant-parameter-of-rmqueue_pcplist
+++ a/mm/page_alloc.c
@@ -3779,8 +3779,7 @@ struct page *__rmqueue_pcplist(struct zo
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			gfp_t gfp_flags, int migratetype,
-			unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3841,7 +3840,7 @@ struct page *rmqueue(struct zone *prefer
 		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
 				migratetype != MIGRATE_MOVABLE) {
 			page = rmqueue_pcplist(preferred_zone, zone, order,
-					gfp_flags, migratetype, alloc_flags);
+					migratetype, alloc_flags);
 			if (likely(page))
 				goto out;
 		}
_

Patches currently in -mm which might be from zuoze1@huawei.com are

mm-delete-a-redundant-parameter-of-rmqueue_pcplist.patch

