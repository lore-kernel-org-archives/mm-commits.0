Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96639C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660A16141D
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEIATw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhEIATw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 454D0610F7;
        Sun,  9 May 2021 00:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620519529;
        bh=TUggoRlPHuGGfLJCHHmdG+I3snPLis3z8wqTvwCK28E=;
        h=Date:From:To:Subject:From;
        b=rJmATznBk8sDzoVPmxah1p/D4HxrFAuSmYEx7Lc0+zVxNTTuuhyNNR7Dfhxqfe7/F
         ZMGqvMt2hvz77kp7ERq3D+v3PGyN9i+CzneSU3nSmFyFSoSdNpBiIlEQt+DujYsiSf
         EsmQl6p1cdXpX4kMS2hAp09rG6v30cH2C73e+8wY=
Date:   Sat, 08 May 2021 17:18:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  +
 mm-page-writeback-kill-get_writeback_state-comments.patch added to -mm tree
Message-ID: <20210509001848.yEbOA3JPX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-writeback: kill get_writeback_state() comments
has been added to the -mm tree.  Its filename is
     mm-page-writeback-kill-get_writeback_state-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-kill-get_writeback_state-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-kill-get_writeback_state-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page-writeback: kill get_writeback_state() comments

The get_writeback_state() has gone since 2006, kill related comments.

Link: https://lkml.kernel.org/r/20210508125026.56600-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-kill-get_writeback_state-comments
+++ a/mm/page-writeback.c
@@ -1869,10 +1869,9 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks
  * which was newly dirtied.  The function will periodically check the system's
  * dirty state and will initiate writeback if needed.
  *
- * On really big machines, get_writeback_state is expensive, so try to avoid
- * calling it too often (ratelimiting).  But once we're over the dirty memory
- * limit we decrease the ratelimiting by a lot, to prevent individual processes
- * from overshooting the limit by (ratelimit_pages) each.
+ * Once we're over the dirty memory limit we decrease the ratelimiting
+ * by a lot, to prevent individual processes from overshooting the limit
+ * by (ratelimit_pages) each.
  */
 void balance_dirty_pages_ratelimited(struct address_space *mapping)
 {
@@ -2045,8 +2044,6 @@ void laptop_sync_completion(void)
 /*
  * If ratelimit_pages is too high then we can get into dirty-data overload
  * if a large number of processes all perform writes at the same time.
- * If it is too low then SMP machines will call the (expensive)
- * get_writeback_state too often.
  *
  * Here we set ratelimit_pages to a level which ensures that when all CPUs are
  * dirtying in parallel, we cannot go more than 3% (1/32) over the dirty memory
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch

