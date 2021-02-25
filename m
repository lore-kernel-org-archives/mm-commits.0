Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FB5C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F209A64F29
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhBYTgQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234521AbhBYTee (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA04964FB3;
        Thu, 25 Feb 2021 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280718;
        bh=pzSGI699qjnt12QuSXpnZZtj6BSDVokgvFHDgSdmBgQ=;
        h=Date:From:To:Subject:From;
        b=iF1a4zLiNx1W0SlHhP5HYvyXYotGupRZFoewzKjDV0ukdZKfNZX2k1UOhWs27azUe
         STfBX7wZeuHucnPWUGxku29K6I7s2bt+Fmt2ibuFUzR4Vwt16IScNVi1UFkrt1Nccd
         GlJHB0jLzy0vCqnhg1Tfpu7h1PWinJy3e0P5maxE=
Date:   Thu, 25 Feb 2021 11:18:38 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hannes@cmpxchg.org, hughd@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-compaction-remove-rcu_read_lock-during-page-compaction.patch removed
 from -mm tree
Message-ID: <20210225191838.Y-0aTyYne%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove rcu_read_lock during page compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are


