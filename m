Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86081C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520BD22D0B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgLOWVO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgLOWVL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:21:11 -0500
Date:   Tue, 15 Dec 2020 14:20:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608070830;
        bh=yVxFEvuUVn3jmENrHzY0uWR+ELpuL33DI8lqyXbACNI=;
        h=From:To:Subject:In-Reply-To:From;
        b=XjOnFjm8+p2j6VOU1qJ6GrWhqu/LB36bxRxSbdene1EaecS11Xj1utHM14g/pCjd0
         /A+K81UMEvO/VQWvrqTjsR8Wq/fjadwq9+PDeuqVSJLeT2X/ZFDRW/UDuoSJLjN8Lz
         8ezoORUZrY8XbYxlAB33EZ5beBiJrx9IIZVdhMtM=
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
Subject:  [patch 05/19] mm/vmscan: remove unnecessary lruvec adding
Message-ID: <20201215222029.OaXVyHWeX%akpm@linux-foundation.org>
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
Subject: mm/vmscan: remove unnecessary lruvec adding

We don't have to add a freeable page into lru and then remove from it.=20
This change saves a couple of actions and makes the moving more clear.

The SetPageLRU needs to be kept before put_page_testzero for list
integrity, otherwise:

  #0 move_pages_to_lru             #1 release_pages
  if !put_page_testzero
     			           if (put_page_testzero())
     			              !PageLRU //skip lru_lock
     SetPageLRU()
     list_add(&page->lru,)
                                         list_add(&page->lru,)

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/1604566549-62481-6-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unnecessary-lruvec-adding
+++ a/mm/vmscan.c
@@ -1851,26 +1851,30 @@ static unsigned noinline_for_stack move_
 	while (!list_empty(list)) {
 		page =3D lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
+		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			list_del(&page->lru);
 			spin_unlock_irq(&pgdat->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&pgdat->lru_lock);
 			continue;
 		}
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
=20
+		/*
+		 * The SetPageLRU needs to be kept here for list integrity.
+		 * Otherwise:
+		 *   #0 move_pages_to_lru             #1 release_pages
+		 *   if !put_page_testzero
+		 *				      if (put_page_testzero())
+		 *				        !PageLRU //skip lru_lock
+		 *     SetPageLRU()
+		 *     list_add(&page->lru,)
+		 *                                        list_add(&page->lru,)
+		 */
 		SetPageLRU(page);
-		lru =3D page_lru(page);
=20
-		nr_pages =3D thp_nr_pages(page);
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_move(&page->lru, &lruvec->lists[lru]);
-
-		if (put_page_testzero(page)) {
+		if (unlikely(put_page_testzero(page))) {
 			__ClearPageLRU(page);
 			__ClearPageActive(page);
-			del_page_from_lru_list(page, lruvec, lru);
=20
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -1878,11 +1882,19 @@ static unsigned noinline_for_stack move_
 				spin_lock_irq(&pgdat->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
-		} else {
-			nr_moved +=3D nr_pages;
-			if (PageActive(page))
-				workingset_age_nonresident(lruvec, nr_pages);
+
+			continue;
 		}
+
+		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		lru =3D page_lru(page);
+		nr_pages =3D thp_nr_pages(page);
+
+		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
+		list_add(&page->lru, &lruvec->lists[lru]);
+		nr_moved +=3D nr_pages;
+		if (PageActive(page))
+			workingset_age_nonresident(lruvec, nr_pages);
 	}
=20
 	/*
_
