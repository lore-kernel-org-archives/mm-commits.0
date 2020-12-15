Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918DAC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC5422C7D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLOUfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgLOUeT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 15:34:19 -0500
Date:   Tue, 15 Dec 2020 12:33:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608064410;
        bh=3U6xznw5k4S17kSCr9BgUv6ipQkATNVw1nVtIV16FHM=;
        h=From:To:Subject:In-Reply-To:From;
        b=01jblC9GQ03Io/ENuOkkyubNDUPWmEoG4cywWWKDTFb2bzJO/IfJbLBdCcr6Fu7FL
         BbSW+DrGTE9npo1bCtOM8LSSEHOngocIoCTXDua6AV/CQVzucTCktLEnzC7+Xd8Zpw
         KvRkJSMErilqTxKS7vcUxQ6GrPG9UE9Zf8FdC9NA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        alex.shi@linux.alibaba.com, alexander.duyck@gmail.com,
        aryabinin@virtuozzo.com, daniel.m.jordan@oracle.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, khlebnikov@yandex-team.ru,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mika.penttila@nextfour.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        rong.a.chen@intel.com, shakeelb@google.com, tglx@linutronix.de,
        tj@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [patch 03/19] mm/thp: simplify lru_add_page_tail()
Message-ID: <20201215203329.o2h4X80q8%akpm@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: simplify lru_add_page_tail()

Simplify lru_add_page_tail(), there are actually only two cases possible:
split_huge_page_to_list(), with list supplied and head isolated from lru
by its caller; or split_huge_page(), with NULL list and head on lru -
because when head is racily isolated from lru, the isolator's reference
will stop the split from getting any further than its page_ref_freeze().

So decide between the two cases by "list", but add VM_WARN_ON()s to
verify that they match our lru expectations.

[Hugh Dickins: rewrite commit log]
Link: https://lkml.kernel.org/r/1604566549-62481-4-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-thp-simplify-lru_add_page_tail
+++ a/mm/huge_memory.c
@@ -2367,24 +2367,16 @@ static void lru_add_page_tail(struct pag
 	VM_BUG_ON_PAGE(PageLRU(tail), head);
 	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
=20
-	if (!list)
-		SetPageLRU(tail);
-
-	if (likely(PageLRU(head)))
-		list_add_tail(&tail->lru, &head->lru);
-	else if (list) {
+	if (list) {
 		/* page reclaim is reclaiming a huge page */
+		VM_WARN_ON(PageLRU(head));
 		get_page(tail);
 		list_add_tail(&tail->lru, list);
 	} else {
-		/*
-		 * Head page has not yet been counted, as an hpage,
-		 * so we must account for each subpage individually.
-		 *
-		 * Put tail on the list at the correct position
-		 * so they all end up in order.
-		 */
-		add_page_to_lru_list_tail(tail, lruvec, page_lru(tail));
+		/* head is still on lru (and we have it frozen) */
+		VM_WARN_ON(!PageLRU(head));
+		SetPageLRU(tail);
+		list_add_tail(&tail->lru, &head->lru);
 	}
 }
=20
_
