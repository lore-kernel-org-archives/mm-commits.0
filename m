Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAAAC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5203C207D2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgLWAnY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgLWAnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:43:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D12207D2;
        Wed, 23 Dec 2020 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608684163;
        bh=i3GfevJNfEP/Y21WwZxaZ2zzp4mOnIVwXeiWslqblYk=;
        h=Date:From:To:Subject:From;
        b=aRTX9j2OmoFhJwd44gZzqvKcU6eh7C3cmvL3B2U9lEYKvG1GxluaGmEY3v/Mw99We
         xJF/Rn7G1YXFevMQ9m21haQtkBkHZCJHgykhmV+L6a9TqY5pgBOBq0EWqpvxZaIsCQ
         SkTV2EszlnA0PuRqzHP31gCd0ykKqlXH4VLxpZww=
Date:   Tue, 22 Dec 2020 16:42:43 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hughd@google.com, hannes@cmpxchg.org,
        alex.shi@linux.alibaba.com
Subject:  +
 mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch added
 to -mm tree
Message-ID: <20201223004243.pWF7c%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove rcu locking for lock_page_lruvec function series
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: remove rcu locking for lock_page_lruvec function series

lock_page_lruvec() and its variants used rcu_read_lock() with the
intention of safeguarding against the mem_cgroup being destroyed
concurrently; but so long as they are called under the specified
conditions (as they are), there is no way for the page's mem_cgroup to be
destroyed.  Delete the unnecessary rcu_read_lock() and _unlock().

Hugh Dickins polished the commit log.  Thanks a lot!

Link: https://lkml.kernel.org/r/1608614453-10739-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series
+++ a/mm/memcontrol.c
@@ -1357,10 +1357,8 @@ struct lruvec *lock_page_lruvec(struct p
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1372,10 +1370,8 @@ struct lruvec *lock_page_lruvec_irq(stru
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irq(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1387,10 +1383,8 @@ struct lruvec *lock_page_lruvec_irqsave(
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

