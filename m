Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA37C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34B864E20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhBXULM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:11:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235399AbhBXUKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66EF164E7A;
        Wed, 24 Feb 2021 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197366;
        bh=uC0aIgTXfqlnX4HP+lCV4J82gG1VEkXDb/DDvmEK9/U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=O8466gW7shCYnPZaCt9fNeH6374dckNJRUCYddXUHLIRxkvYHP5A/70IaDS3/pUko
         CzmX9D4zo5FZ6cQp4rxZ9xPjDc6RIHsDCVe7gadiTMoJOrkjGxO4R2DcqSK+hysRZK
         sc59B3PRmTiM22n5pAhy9gzSnEgcpaRMVKnsgXTc=
Date:   Wed, 24 Feb 2021 12:09:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 155/173] mm/compaction: remove rcu_read_lock
 during page compaction
Message-ID: <20210224200925.i6zoXNQy3%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/compaction: remove rcu_read_lock during page compaction

isolate_migratepages_block() used rcu_read_lock() with the intention of
safeguarding against the mem_cgroup being destroyed concurrently; but its
TestClearPageLRU already protects against that.  Delete the unnecessary
rcu_read_lock() and _unlock().

Hugh Dickins helped on commit log polishing, Thanks!

Link: https://lkml.kernel.org/r/1608614453-10739-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-rcu_read_lock-during-page-compaction
+++ a/mm/compaction.c
@@ -995,7 +995,6 @@ isolate_migratepages_block(struct compac
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
-		rcu_read_lock();
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		/* If we already hold the lock, we can skip some rechecking */
@@ -1005,7 +1004,6 @@ isolate_migratepages_block(struct compac
 
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked = lruvec;
-			rcu_read_unlock();
 
 			lruvec_memcg_debug(lruvec, page);
 
@@ -1026,8 +1024,7 @@ isolate_migratepages_block(struct compac
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
-		} else
-			rcu_read_unlock();
+		}
 
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
_
