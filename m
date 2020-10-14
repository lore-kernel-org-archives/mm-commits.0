Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7D1C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C5D12224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709226;
	bh=0tC6zjhF/Ro3tgbuGfTCPV2oTDjlUe2wZLYlzsDCEK0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CRQRGB0OstCj1uchSy7IIXXawSRHQtnXDtEozeQMtjivG+oRuekTv38WcQ0CKSEIn
	 m36Ad/775u8DnSNaweCPhUiBS1BMiimNW9sBNGgXhOkel5Vn7jxd2Qex7pTsXERZNG
	 4TcwnJRrFqUDYNyTit9ctVDe/hAzsJ39F2ld5CFU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgJNVAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgJNVAZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E4202068E;
        Wed, 14 Oct 2020 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709224;
        bh=0tC6zjhF/Ro3tgbuGfTCPV2oTDjlUe2wZLYlzsDCEK0=;
        h=Date:From:To:Subject:From;
        b=LWnLmnyj1lp4tWZME2GWQAbWR2xkNblcFw6aFga0szkYzCjGaCEcVWIYnDWHcsT/R
         Q3V1H50tggqL39BVdOatEiKXr2hD7nbkemc8kOIzPTxeKz9g0lrpaqJ/qWVXT1jgLk
         5tYohSnlJ7D1S/WdENwLpO2begGuzmyrd9tFdOXw=
Date:   Wed, 14 Oct 2020 14:00:24 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Fcounter-correct-the-obsolete-func-name-in-the-comm?=
 =?US-ASCII?Q?ent-of-page=5Fcounter=5Ftry=5Fcharge.patch?= removed from -mm
 tree
Message-ID: <20201014210024.SWDm3RJez%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()
has been removed from the -mm tree.  Its filename was
     mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_counter: correct the obsolete func name in the comment of page_counter_try_charge()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), page_counter_limit() is renamed to page_counter_set_max().
So replace page_counter_limit with page_counter_set_max in comment.

Link: https://lkml.kernel.org/r/20200917113629.14382-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge
+++ a/mm/page_counter.c
@@ -109,7 +109,7 @@ bool page_counter_try_charge(struct page
 		 *
 		 * The atomic_long_add_return() implies a full memory
 		 * barrier between incrementing the count and reading
-		 * the limit.  When racing with page_counter_limit(),
+		 * the limit.  When racing with page_counter_set_max(),
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

