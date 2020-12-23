Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71628C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382CF206E5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgLWAnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgLWAnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:43:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBE4E206E5;
        Wed, 23 Dec 2020 00:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608684162;
        bh=fSAhB4DANAQ6KW/wAlI6wPycx89kVgKYpAz6+tt18sc=;
        h=Date:From:To:Subject:From;
        b=i+RTI6ajYdsp6iOW95AZsR2LQFw0kR4H/jFfOnGq4AAuUSW3VKsvAiMgMyhME9KQ3
         KsmQ9P1sR6en99KzZSepzZ8AlHzf18iCOS3izKqfuT704sr+v1fX1FV9niYEVz4ok8
         /DNsOXWLWdxj4hnR97+PvO51LxnpWfCXoJ878DFU=
Date:   Tue, 22 Dec 2020 16:42:41 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hughd@google.com, hannes@cmpxchg.org,
        alex.shi@linux.alibaba.com
Subject:  +
 mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
 added to -mm tree
Message-ID: <20201223004241.qkcsT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: revise the using condition of lock_page_lruvec function series
has been added to the -mm tree.  Its filename is
     mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch

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
Subject: mm/memcg: revise the using condition of lock_page_lruvec function series

lock_page_lruvec() and its variants are safe to use under the same
conditions as commit_charge(): add lock_page_memcg() to the comment.

Polished with Hugh Dickins' suggestions, thanks!

Link: https://lkml.kernel.org/r/1608614453-10739-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series
+++ a/mm/memcontrol.c
@@ -1346,10 +1346,11 @@ void lruvec_memcg_debug(struct lruvec *l
  * lock_page_lruvec - lock and return lruvec for a given page.
  * @page: the page
  *
- * This series functions should be used in either conditions:
- * PageLRU is cleared or unset
- * or page->_refcount is zero
- * or page is locked.
+ * These functions are safe to use under any of the following conditions:
+ * - page locked
+ * - PageLRU cleared
+ * - lock_page_memcg()
+ * - page->_refcount is zero
  */
 struct lruvec *lock_page_lruvec(struct page *page)
 {
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

