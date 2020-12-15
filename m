Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3994C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F84122D49
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgLOWV7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729972AbgLOWVr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:21:47 -0500
Date:   Tue, 15 Dec 2020 14:20:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608070860;
        bh=x2mmbCdpPJf2IlvVW3PZy7aYbI/LxsQFYS4ckvi7cqo=;
        h=From:To:Subject:In-Reply-To:From;
        b=J1B9L6C3m6DGa7YnQasrrRwOKpiRvLcTT5HZyAbu5GOruR8SI5RzlKIGDntUVVf7D
         XEv/PwhjIFwt5FPx5Z5t2SQBgdlfCxi2r9+8JgMqUrlZGJNpEhuELBecoR05bplb6/
         RNvTYbvupX6mq7jTpgWbcCWaOzTxSZdMtEKt6MWo=
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
Subject:  [patch 12/19] mm/mlock: remove lru_lock on
 TestClearPageMlocked
Message-ID: <20201215222059.IgN70CFhj%akpm@linux-foundation.org>
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
Subject: mm/mlock: remove lru_lock on TestClearPageMlocked

In the func munlock_vma_page, comments mentained lru_lock needed for
serialization with split_huge_pages.  But the page must be PageLocked as
well as pages in split_huge_page series funcs.  Thus the PageLocked is
enough to serialize both funcs.

Further more, Hugh Dickins pointed: before splitting in
split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
which protect the page from munlock.  Thus, no needs to guard
__split_huge_page_tail for mlock clean, just keep the lru_lock there for
isolation purpose.

LKP found a preempt issue on __mod_zone_page_state which need change to
mod_zone_page_state.  Thanks!

Link: https://lkml.kernel.org/r/1604566549-62481-13-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

--- a/mm/mlock.c~mm-mlock-remove-lru_lock-on-testclearpagemlocked
+++ a/mm/mlock.c
@@ -187,40 +187,24 @@ static void __munlock_isolation_failed(s
 unsigned int munlock_vma_page(struct page *page)
 {
 	int nr_pages;
-	pg_data_t *pgdat =3D page_pgdat(page);
=20
 	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
-
 	VM_BUG_ON_PAGE(PageTail(page), page);
=20
-	/*
-	 * Serialize with any parallel __split_huge_page_refcount() which
-	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes thp_nr_pages().
-	 */
-	spin_lock_irq(&pgdat->lru_lock);
-
 	if (!TestClearPageMlocked(page)) {
 		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
-		nr_pages =3D 1;
-		goto unlock_out;
+		return 0;
 	}
=20
 	nr_pages =3D thp_nr_pages(page);
-	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+	mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
=20
-	if (__munlock_isolate_lru_page(page, true)) {
-		spin_unlock_irq(&pgdat->lru_lock);
+	if (!isolate_lru_page(page))
 		__munlock_isolated_page(page);
-		goto out;
-	}
-	__munlock_isolation_failed(page);
-
-unlock_out:
-	spin_unlock_irq(&pgdat->lru_lock);
+	else
+		__munlock_isolation_failed(page);
=20
-out:
 	return nr_pages - 1;
 }
=20
_
