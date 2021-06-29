Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1395C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA4C61D04
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhF2Ckg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhF2Ckg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8954C61D07;
        Tue, 29 Jun 2021 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934289;
        bh=cjvMz4cfipb/NwArnTKaMyK55fp0Ps2EbnQSTYEhVe8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rYm++n60UsJB+Oj0/VAmjzVCy0sJPToiJxM89gUejzqVqCIgUbJUue2wLbOSD+Ah6
         1lNF2t87p790Or4vo1IY/f3Q73jRQ6u2hsUTRw/l+obyqlO1fwAyVvQp3NRD20kbmi
         iLxvZGG6tYnyO3RaiZbfydY1S0FzBlwFJnT5N5II=
Date:   Mon, 28 Jun 2021 19:38:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 092/192] mm: vmscan: remove noinline_for_stack
Message-ID: <20210629023809.NT1GX9moN%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: vmscan: remove noinline_for_stack

The noinline_for_stack is introduced by commit 666356297ec4 ("vmscan: set
up pagevec as late as possible in shrink_inactive_list()"), its purpose is
to delay the allocation of pagevec as late as possible to save stack
memory.  But the commit 2bcf88796381 ("mm: take pagevecs off reclaim
stack") replace pagevecs by lists of pages_to_free.  So we do not need
noinline_for_stack, just remove it (let the compiler decide whether to
inline).

Link: https://lkml.kernel.org/r/20210417043538.9793-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-noinline_for_stack
+++ a/mm/vmscan.c
@@ -2015,8 +2015,8 @@ static int too_many_isolated(struct pgli
  *
  * Returns the number of pages moved to the given lruvec.
  */
-static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
-						     struct list_head *list)
+static unsigned int move_pages_to_lru(struct lruvec *lruvec,
+				      struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
@@ -2096,7 +2096,7 @@ static int current_may_throttle(void)
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
  */
-static noinline_for_stack unsigned long
+static unsigned long
 shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		     struct scan_control *sc, enum lru_list lru)
 {
_
