Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2C9C2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B013322CB9
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgLOWVX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgLOWVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 17:21:21 -0500
Date:   Tue, 15 Dec 2020 14:20:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608070834;
        bh=nBG3JTxx41P3NkdiTpJL/2E1ZKUvgP0xDWYDNugdXGA=;
        h=From:To:Subject:In-Reply-To:From;
        b=qOuofTJGzSiUtuv6Pd6roZSHC7YPrxySe4vZlNto4I6Xaj7+oTryg2vwy67gZLO0i
         CaiWRM5mKbpfZa9Lm5cIGwYwMSLqd9ZU/fdgIIMAMwGXkqdPlEi3TlScNRiWsXwMX6
         G/BzzeCPJMW6zP0opgQiLMaFeevoB2wJoBI38EaA=
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
Subject:  [patch 06/19] mm/rmap: stop store reordering issue on
 page->mapping
Message-ID: <20201215222033.XIgRS2m2W%akpm@linux-foundation.org>
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
Subject: mm/rmap: stop store reordering issue on page->mapping

Hugh Dickins and Minchan Kim observed a long time issue which discussed
here, but actully the mentioned fix missed.=20
https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop/ The store
reordering may cause problem in the scenario:

	CPU 0						CPU1
   do_anonymous_page
	page_add_new_anon_rmap()
	  page->mapping =3D anon_vma + PAGE_MAPPING_ANON
	lru_cache_add_inactive_or_unevictable()
	  spin_lock(lruvec->lock)
	  SetPageLRU()
	  spin_unlock(lruvec->lock)
						/* idletacking judged it as LRU
						 * page so pass the page in
						 * page_idle_clear_pte_refs
						 */
						page_idle_clear_pte_refs
						  rmap_walk
						    if PageAnon(page)

Johannes give detailed examples how the store reordering could cause a
trouble: "The concern is the SetPageLRU may get reorder before
'page->mapping' setting, That would make CPU 1 will observe at
page->mapping after observing PageLRU set on the page.

1. anon_vma + PAGE_MAPPING_ANON

   That's the in-order scenario and is fine.

2. NULL

   That's possible if the page->mapping store gets reordered to occur
   after SetPageLRU. That's fine too because we check for it.

3. anon_vma without the PAGE_MAPPING_ANON bit

   That would be a problem and could lead to all kinds of undesirable
   behavior including crashes and data corruption.

   Is it possible? AFAICT the compiler is allowed to tear the store to
   page->mapping and I don't see anything that would prevent it.

That said, I also don't see how the reader testing PageLRU under the
lru_lock would prevent that in the first place.  AFAICT we need that
WRITE_ONCE() around the page->mapping assignment."

[alex.shi@linux.alibaba.com: updated for comments change from Johannes]
  Link: https://lkml.kernel.org/r/e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linu=
x.alibaba.com
Link: https://lkml.kernel.org/r/1604566549-62481-7-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
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
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-stop-store-reordering-issue-on-page-mapping
+++ a/mm/rmap.c
@@ -1054,8 +1054,14 @@ static void __page_set_anon_rmap(struct
 	if (!exclusive)
 		anon_vma =3D anon_vma->root;
=20
+	/*
+	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
+	 * Make sure the compiler doesn't split the stores of anon_vma and
+	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
+	 * could mistake the mapping for a struct address_space and crash.
+	 */
 	anon_vma =3D (void *) anon_vma + PAGE_MAPPING_ANON;
-	page->mapping =3D (struct address_space *) anon_vma;
+	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 	page->index =3D linear_page_index(vma, address);
 }
=20
_
