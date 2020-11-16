Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0203C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD7522370
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3ZzvUJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgKPV5s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPV5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:57:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2C92225B;
        Mon, 16 Nov 2020 21:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563866;
        bh=hQ7NXW5ZqVFvyneTf2HoKPuea/VAaYlB67z62YSGBTI=;
        h=Date:From:To:Subject:From;
        b=n3ZzvUJOWeeTVxor8ZlUvEceIt5hsOjWWQgclpxtQayHUyDUhtnkrASAOny1bCbYo
         vFXjEWORsEgKf7+8hHEj+vIIakNGkHqKv7d5iwE371yphlu+oibhHejAi5yRZxTtWR
         IDwMHEeS0fBHC215cYqwKesbkMIJjbUOz8XGKk/o=
Date:   Mon, 16 Nov 2020 13:57:44 -0800
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
Subject:  +
 mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch added to -mm
 tree
Message-ID: <20201116215744.CoWutf9Pe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: serialize memcg changes in pagevec_lru_move_fn
has been added to the -mm tree.  Its filename is
     mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-serialize-memcg-chan=
ges-in-pagevec_lru_move_fn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-serialize-memcg-chan=
ges-in-pagevec_lru_move_fn.patch

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
Subject: mm/swap.c: serialize memcg changes in pagevec_lru_move_fn

Hugh Dickins' found a memcg change bug on original version: If we want to
change the pgdat->lru_lock to memcg's lruvec lock, we have to serialize
mem_cgroup_move_account during pagevec_lru_move_fn.  The possible bad
scenario would like:

	cpu 0					cpu 1
lruvec =3D mem_cgroup_page_lruvec()
					if (!isolate_lru_page())
						mem_cgroup_move_account

spin_lock_irqsave(&lruvec->lru_lock <=3D=3D wrong lock.

So we need TestClearPageLRU to block isolate_lru_page(), that serializes
the memcg change.  and then removing the PageLRU check in move_fn callee
as the consequence.

__pagevec_lru_add_fn() is different from the others, because the pages it
deals with are, by definition, not yet on the lru.  TestClearPageLRU is
not needed and would not work, so __pagevec_lru_add() goes its own way.

Link: https://lkml.kernel.org/r/1604566549-62481-17-git-send-email-alex.shi=
@linux.alibaba.com
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/mm/swap.c~mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn
+++ a/mm/swap.c
@@ -222,8 +222,14 @@ static void pagevec_lru_move_fn(struct p
 			spin_lock_irqsave(&pgdat->lru_lock, flags);
 		}
=20
+		/* block memcg migration during page moving between lru */
+		if (!TestClearPageLRU(page))
+			continue;
+
 		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
 		(*move_fn)(page, lruvec);
+
+		SetPageLRU(page);
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
@@ -233,7 +239,7 @@ static void pagevec_lru_move_fn(struct p
=20
 static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageLRU(page) && !PageUnevictable(page)) {
+	if (!PageUnevictable(page)) {
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
@@ -306,7 +312,7 @@ void lru_note_cost_page(struct page *pag
=20
 static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
-	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
+	if (!PageActive(page) && !PageUnevictable(page)) {
 		int lru =3D page_lru_base_type(page);
 		int nr_pages =3D thp_nr_pages(page);
=20
@@ -362,7 +368,8 @@ static void activate_page(struct page *p
=20
 	page =3D compound_head(page);
 	spin_lock_irq(&pgdat->lru_lock);
-	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
+	if (PageLRU(page))
+		__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
 	spin_unlock_irq(&pgdat->lru_lock);
 }
 #endif
@@ -519,9 +526,6 @@ static void lru_deactivate_file_fn(struc
 	bool active;
 	int nr_pages =3D thp_nr_pages(page);
=20
-	if (!PageLRU(page))
-		return;
-
 	if (PageUnevictable(page))
 		return;
=20
@@ -562,7 +566,7 @@ static void lru_deactivate_file_fn(struc
=20
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
+	if (PageActive(page) && !PageUnevictable(page)) {
 		int lru =3D page_lru_base_type(page);
 		int nr_pages =3D thp_nr_pages(page);
=20
@@ -579,7 +583,7 @@ static void lru_deactivate_fn(struct pag
=20
 static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
+	if (PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active =3D PageActive(page);
 		int nr_pages =3D thp_nr_pages(page);
@@ -1021,7 +1025,29 @@ static void __pagevec_lru_add_fn(struct
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
+	int i;
+	struct pglist_data *pgdat =3D NULL;
+	struct lruvec *lruvec;
+	unsigned long flags =3D 0;
+
+	for (i =3D 0; i < pagevec_count(pvec); i++) {
+		struct page *page =3D pvec->pages[i];
+		struct pglist_data *pagepgdat =3D page_pgdat(page);
+
+		if (pagepgdat !=3D pgdat) {
+			if (pgdat)
+				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat =3D pagepgdat;
+			spin_lock_irqsave(&pgdat->lru_lock, flags);
+		}
+
+		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		__pagevec_lru_add_fn(page, lruvec);
+	}
+	if (pgdat)
+		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	release_pages(pvec->pages, pvec->nr);
+	pagevec_reinit(pvec);
 }
=20
 /**
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

