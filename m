Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43726C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF1B1223AB
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYqpqOyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgKPV5i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPV5i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:57:38 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E692225E;
        Mon, 16 Nov 2020 21:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563857;
        bh=DxqYpmEcWE5GNc+Ywlzjm6lGNby6+hV7tb3kgf9HXDU=;
        h=Date:From:To:Subject:From;
        b=DYqpqOyoMHO9LFKRw2Jtya7Cam+dBLEECSo2ZqdH15RKNHHOANiA/OpfndA7OU5Xo
         iBpHx3rerJm0iIRFa8AQhkc6PC7SB//fQbWh2DMxD5RgsNKvUNchuHHM0/m1gV+Ob7
         /dl2sSEzfI//JilTQdfsMcbE9+fYbZT6I9tCGurA=
Date:   Mon, 16 Nov 2020 13:57:35 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.duyck@gmail.com, aryabinin@virtuozzo.com,
        daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, jannh@google.com,
        khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com,
        kirill@shutemov.name, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mika.penttila@nextfour.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com, tglx@linutronix.de,
        tj@kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        ying.huang@intel.com
Subject:  + mm-lru-introduce-testclearpagelru.patch added to -mm
 tree
Message-ID: <20201116215735.E1CCzSU2i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/lru: introduce TestClearPageLRU()
has been added to the -mm tree.  Its filename is
     mm-lru-introduce-testclearpagelru.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-lru-introduce-testclearpag=
elru.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-lru-introduce-testclearpag=
elru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/lru: introduce TestClearPageLRU()

Currently lru_lock still guards both lru list and page's lru bit, that's
ok.  but if we want to use specific lruvec lock on the page, we need to
pin down the page's lruvec/memcg during locking.  Just taking lruvec lock
first may be undermined by the page's memcg charge/migration.  To fix this
problem, we will clear the lru bit out of locking and use it as pin down
action to block the page isolation in memcg changing.

So now a standard steps of page isolation is following:
	1, get_page(); 	       #pin the page avoid to be free
	2, TestClearPageLRU(); #block other isolation like memcg change
	3, spin_lock on lru_lock; #serialize lru list access
	4, delete page from lru list;

This patch start with the first part: TestClearPageLRU, which combines
PageLRU check and ClearPageLRU into a macro func TestClearPageLRU.  This
function will be used as page isolation precondition to prevent other
isolations some where else.  Then there are may !PageLRU page on lru list,
need to remove BUG() checking accordingly.

There 2 rules for lru bit now:
1, the lru bit still indicate if a page on lru list, just in some
   temporary moment(isolating), the page may have no lru bit when
   it's on lru list.  but the page still must be on lru list when the
   lru bit set.
2, have to remove lru bit before delete it from lru list.

As Andrew Morton mentioned this change would dirty cacheline for a page
which isn't on the LRU.  But the loss would be acceptable in Rong Chen
<rong.a.chen@intel.com> report:
https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/

Link: https://lkml.kernel.org/r/1604566549-62481-15-git-send-email-alex.shi=
@linux.alibaba.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1=20
 mm/mlock.c                 |    3 --
 mm/vmscan.c                |   39 +++++++++++++++++------------------
 3 files changed, 21 insertions(+), 22 deletions(-)

--- a/include/linux/page-flags.h~mm-lru-introduce-testclearpagelru
+++ a/include/linux/page-flags.h
@@ -335,6 +335,7 @@ PAGEFLAG(Referenced, referenced, PF_HEAD
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+	TESTCLEARFLAG(LRU, lru, PF_HEAD)
 PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
 	TESTCLEARFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
--- a/mm/mlock.c~mm-lru-introduce-testclearpagelru
+++ a/mm/mlock.c
@@ -276,10 +276,9 @@ static void __munlock_pagevec(struct pag
 			 * We already have pin from follow_page_mask()
 			 * so we can spare the get_page() here.
 			 */
-			if (PageLRU(page)) {
+			if (TestClearPageLRU(page)) {
 				struct lruvec *lruvec;
=20
-				ClearPageLRU(page);
 				lruvec =3D mem_cgroup_page_lruvec(page,
 							page_pgdat(page));
 				del_page_from_lru_list(page, lruvec,
--- a/mm/vmscan.c~mm-lru-introduce-testclearpagelru
+++ a/mm/vmscan.c
@@ -1542,7 +1542,7 @@ unsigned int reclaim_clean_pages_from_li
  */
 int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 {
-	int ret =3D -EINVAL;
+	int ret =3D -EBUSY;
=20
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
@@ -1552,8 +1552,6 @@ int __isolate_lru_page(struct page *page
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
=20
-	ret =3D -EBUSY;
-
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
 	 * wants to isolate pages it will be able to operate on without
@@ -1600,8 +1598,10 @@ int __isolate_lru_page(struct page *page
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		ClearPageLRU(page);
-		ret =3D 0;
+		if (TestClearPageLRU(page))
+			ret =3D 0;
+		else
+			put_page(page);
 	}
=20
 	return ret;
@@ -1667,8 +1667,6 @@ static unsigned long isolate_lru_pages(u
 		page =3D lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
=20
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
-
 		nr_pages =3D compound_nr(page);
 		total_scan +=3D nr_pages;
=20
@@ -1765,21 +1763,18 @@ int isolate_lru_page(struct page *page)
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
=20
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
=20
-		spin_lock_irq(&pgdat->lru_lock);
+		get_page(page);
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
-		if (PageLRU(page)) {
-			int lru =3D page_lru(page);
-			get_page(page);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, lru);
-			ret =3D 0;
-		}
+		spin_lock_irq(&pgdat->lru_lock);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		spin_unlock_irq(&pgdat->lru_lock);
+		ret =3D 0;
 	}
+
 	return ret;
 }
=20
@@ -4290,6 +4285,10 @@ void check_move_unevictable_pages(struct
 		nr_pages =3D thp_nr_pages(page);
 		pgscanned +=3D nr_pages;
=20
+		/* block memcg migration during page moving between lru */
+		if (!TestClearPageLRU(page))
+			continue;
+
 		if (pagepgdat !=3D pgdat) {
 			if (pgdat)
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -4298,10 +4297,7 @@ void check_move_unevictable_pages(struct
 		}
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
=20
-		if (!PageLRU(page) || !PageUnevictable(page))
-			continue;
-
-		if (page_evictable(page)) {
+		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru =3D page_lru_base_type(page);
=20
 			VM_BUG_ON_PAGE(PageActive(page), page);
@@ -4310,12 +4306,15 @@ void check_move_unevictable_pages(struct
 			add_page_to_lru_list(page, lruvec, lru);
 			pgrescued +=3D nr_pages;
 		}
+		SetPageLRU(page);
 	}
=20
 	if (pgdat) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 		spin_unlock_irq(&pgdat->lru_lock);
+	} else if (pgscanned) {
+		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
 }
 EXPORT_SYMBOL_GPL(check_move_unevictable_pages);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

