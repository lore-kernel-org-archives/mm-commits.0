Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75E4C2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 01:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F402311E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 01:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLPBkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 20:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLPBkZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 20:40:25 -0500
Date:   Tue, 15 Dec 2020 17:39:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608082783;
        bh=Qf82tyiBbd20ri/8JorI2TsZl5XdV8CxGRLQ2jpLG9A=;
        h=From:To:Subject:From;
        b=ZZ/158PXK7QOVTjHlQEY3sB9jaTycHWavYgcLgetMKD8dsVi8wCi3awGSmNuVzn3f
         Gm6sYgLvK6hVxlMuiNBMUlK7Uj+rAfQT3lR2EMUJxhKb8zgjgkC3HvWPujAq2oAcCe
         iFRWBWsACSxDLp5ZYvk/7pfmHrswwQNsCpHhxfkg=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.duyck@gmail.com, aryabinin@virtuozzo.com,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mika.penttila@nextfour.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rong.a.chen@intel.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [merged] mm-thp-narrow-lru-locking.patch removed from -mm
 tree
Message-ID: <20201216013942.exlSAyP_L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: narrow lru locking
has been removed from the -mm tree.  Its filename was
     mm-thp-narrow-lru-locking.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: narrow lru locking

lru_lock and page cache xa_lock have no obvious reason to be taken one way
round or the other: until now, lru_lock has been taken before page cache
xa_lock, when splitting a THP; but nothing else takes them together.=20
Reverse that ordering: let's narrow the lru locking - but leave
local_irq_disable to block interrupts throughout, like before.

Hugh Dickins point: split_huge_page_to_list() was already silly, to be
using the _irqsave variant: it's just been taking sleeping locks, so would
already be broken if entered with interrupts enabled.  So we can save
passing flags argument down to __split_huge_page().

Why change the lock ordering here?  That was hard to decide.  One reason:
when this series reaches per-memcg lru locking, it relies on the THP's
memcg to be stable when taking the lru_lock: that is now done after the
THP's refcount has been frozen, which ensures page memcg cannot change.

Another reason: previously, lock_page_memcg()'s move_lock was presumed to
nest inside lru_lock; but now lru_lock must nest inside (page cache lock
inside) move_lock, so it becomes possible to use lock_page_memcg() to
stabilize page memcg before taking its lru_lock.  That is not the
mechanism used in this series, but it is an option we want to keep open.

[hughd@google.com: rewrite commit log]
Link: https://lkml.kernel.org/r/1604566549-62481-5-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
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

 mm/huge_memory.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-thp-narrow-lru-locking
+++ a/mm/huge_memory.c
@@ -2446,7 +2446,7 @@ static void __split_huge_page_tail(struc
 }
=20
 static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned long flags)
+		pgoff_t end)
 {
 	struct page *head =3D compound_head(page);
 	pg_data_t *pgdat =3D page_pgdat(head);
@@ -2456,8 +2456,6 @@ static void __split_huge_page(struct pag
 	unsigned int nr =3D thp_nr_pages(head);
 	int i;
=20
-	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
=20
@@ -2469,6 +2467,11 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
=20
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock(&pgdat->lru_lock);
+
+	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
+
 	for (i =3D nr - 1; i >=3D 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2488,6 +2491,8 @@ static void __split_huge_page(struct pag
 	}
=20
 	ClearPageCompound(head);
+	spin_unlock(&pgdat->lru_lock);
+	/* Caller disabled irqs, so they are still disabled here */
=20
 	split_page_owner(head, nr);
=20
@@ -2505,8 +2510,7 @@ static void __split_huge_page(struct pag
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
-
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	local_irq_enable();
=20
 	remap_page(head, nr);
=20
@@ -2652,12 +2656,10 @@ bool can_split_huge_page(struct page *pa
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head =3D compound_head(page);
-	struct pglist_data *pgdata =3D NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue =3D get_deferred_split_queue(head);
 	struct anon_vma *anon_vma =3D NULL;
 	struct address_space *mapping =3D NULL;
 	int count, mapcount, extra_pins, ret;
-	unsigned long flags;
 	pgoff_t end;
=20
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2718,9 +2720,8 @@ int split_huge_page_to_list(struct page
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
=20
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
+	/* block interrupt reentry in xa_lock and spinlock */
+	local_irq_disable();
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
=20
@@ -2750,7 +2751,7 @@ int split_huge_page_to_list(struct page
 				__dec_lruvec_page_state(head, NR_FILE_THPS);
 		}
=20
-		__split_huge_page(page, list, end, flags);
+		__split_huge_page(page, list, end);
 		ret =3D 0;
 	} else {
 		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
@@ -2764,7 +2765,7 @@ int split_huge_page_to_list(struct page
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
+		local_irq_enable();
 		remap_page(head, thp_nr_pages(head));
 		ret =3D -EBUSY;
 	}
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

