Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8E5C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E455D22D06
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgLOWVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbgLOWVd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:21:33 -0500
Date:   Tue, 15 Dec 2020 14:20:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608070852;
        bh=gxvTtWnSad0FaLs7/+b3NpyvCIteFLuV4/DnD865n8E=;
        h=From:To:Subject:In-Reply-To:From;
        b=pt/JJLnsEDpsw+81ZXGeyAinLLWtYDvO4ZwjS4rE6lR+tOsqDp3NDDWnnhx1oDc2L
         Zq5lB9Ioj0Hzk6IsWsTc4jrQVMI9KAOanaOBDhKPhbR3wowgWa50in2OUUKjLm3pR+
         +RxD3LxYuLv+PQkDht2ugWNST1SSj9eKsuBX32KM=
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
Subject:  [patch 10/19] mm/lru: move lock into lru_note_cost
Message-ID: <20201215222050.WZsb-8EB6%akpm@linux-foundation.org>
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
Subject: mm/lru: move lock into lru_note_cost

We have to move lru_lock into lru_note_cost, since it cycle up on memcg
tree, for future per lruvec lru_lock replace.  It's a bit ugly and may
cost a bit more locking, but benefit from multiple memcg locking could
cover the lost.

Link: https://lkml.kernel.org/r/1604566549-62481-11-git-send-email-alex.shi=
@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c       |    3 +++
 mm/vmscan.c     |    4 +---
 mm/workingset.c |    2 --
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-lru-move-lock-into-lru_note_cost
+++ a/mm/swap.c
@@ -268,7 +268,9 @@ void lru_note_cost(struct lruvec *lruvec
 {
 	do {
 		unsigned long lrusize;
+		struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
=20
+		spin_lock_irq(&pgdat->lru_lock);
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost +=3D nr_pages;
@@ -292,6 +294,7 @@ void lru_note_cost(struct lruvec *lruvec
 			lruvec->file_cost /=3D 2;
 			lruvec->anon_cost /=3D 2;
 		}
+		spin_unlock_irq(&pgdat->lru_lock);
 	} while ((lruvec =3D parent_lruvec(lruvec)));
 }
=20
--- a/mm/vmscan.c~mm-lru-move-lock-into-lru_note_cost
+++ a/mm/vmscan.c
@@ -1971,19 +1971,17 @@ shrink_inactive_list(unsigned long nr_to
 	nr_reclaimed =3D shrink_page_list(&page_list, pgdat, sc, &stat, false);
=20
 	spin_lock_irq(&pgdat->lru_lock);
-
 	move_pages_to_lru(lruvec, &page_list);
=20
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	lru_note_cost(lruvec, file, stat.nr_pageout);
 	item =3D current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-
 	spin_unlock_irq(&pgdat->lru_lock);
=20
+	lru_note_cost(lruvec, file, stat.nr_pageout);
 	mem_cgroup_uncharge_list(&page_list);
 	free_unref_page_list(&page_list);
=20
--- a/mm/workingset.c~mm-lru-move-lock-into-lru_note_cost
+++ a/mm/workingset.c
@@ -381,9 +381,7 @@ void workingset_refault(struct page *pag
 	if (workingset) {
 		SetPageWorkingset(page);
 		/* XXX: Move to lru_cache_add() when it supports new vs putback */
-		spin_lock_irq(&page_pgdat(page)->lru_lock);
 		lru_note_cost_page(page);
-		spin_unlock_irq(&page_pgdat(page)->lru_lock);
 		inc_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file);
 	}
 out:
_
