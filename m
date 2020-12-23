Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCC9C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24BA207A8
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgLWAn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgLWAn5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:43:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B188D207A8;
        Wed, 23 Dec 2020 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608684196;
        bh=9n0bgHbuoBNPq68hHxEHMgdXMd3pMWaIbVZN389g61o=;
        h=Date:From:To:Subject:From;
        b=2GY7Ku6WeqI0QxGtGo/R79n7Mp70hz90CJnidWFUZwPEst1UEbhnkGTxPs31sSIrk
         1nWoauTh/sVSfZaG3nHPb0/LnuJrfKnJ75BOye9EMiTDjCoTx/d7T1nWTBgbCY3Zu/
         qZwk10xkGNJMqV3yte+USJhho8I/bstZDPz/DOFA=
Date:   Tue, 22 Dec 2020 16:43:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org,
        alex.shi@linux.alibaba.com
Subject:  +
 mm-compaction-remove-rcu_read_lock-during-page-compaction.patch added to -mm
 tree
Message-ID: <20201223004316.UK44U%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove rcu_read_lock during page compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-rcu_read_lock-during-page-compaction.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

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

mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

