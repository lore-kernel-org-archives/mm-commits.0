Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC90C4332D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E4364F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhBXUGA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhBXUFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413C064F2E;
        Wed, 24 Feb 2021 20:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197032;
        bh=MdbD5dS61DyOcD0SHAgsXk29hGrzLzSJMLlZwZMUUbI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u8DxfA1fn/Q9EmdbwDmwTB7PY6D4XozEJPFqpiSPhHYRwOTvA8402z5zO3oJb3G9j
         KwYNg5cZ16SyMJALepmISOXxTQJOdoWLaH3ufMGbbD1iJOykMRTr//WZCOhDvScldu
         GAzjJF4iZQt+cyUn0AmvhrY3/v+y/dt4axlkymJg=
Date:   Wed, 24 Feb 2021 12:03:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 065/173] mm/memcg: remove rcu locking for
 lock_page_lruvec function series
Message-ID: <20210224200351.MIWbYvcmP%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
