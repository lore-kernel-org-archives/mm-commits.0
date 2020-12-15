Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ADDC2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3D722AAE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgLOUg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgLOUe2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 15:34:28 -0500
Date:   Tue, 15 Dec 2020 12:33:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608064428;
        bh=PMreW2R4Vi4QzUU4z1kWWF1Hlk7nQ75NLwcVJaoR06g=;
        h=From:To:Subject:In-Reply-To:From;
        b=Fg6KExjlL7q5L3vlDeC5fca0+M6jzLbrO3itgGKR7adWdPVWO/cw/VOkKAdiWkFW9
         VMhbe5msNv3CtTeXPhD6Zd8Bje9+f6BNjKLBWBf2rt5qu+r9Kb5J0lM5h3qKG3lfiI
         970IJqDAX8TcRdWG4BQAC7DV1IzXo1RbwYumFqn8=
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
Subject:  [patch 07/19] mm: page_idle_get_page() does not need
 lru_lock
Message-ID: <20201215203347.kUAcWnZn0%akpm@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Hugh Dickins <hughd@google.com>
Subject: mm: page_idle_get_page() does not need lru_lock

It is necessary for page_idle_get_page() to recheck PageLRU() after
get_page_unless_zero(), but holding lru_lock around that serves no useful
purpose, and adds to lru_lock contention: delete it.

See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
discussion that led to lru_lock there; but __page_set_anon_rmap() now uses
WRITE_ONCE(), and I see no other risk in page_idle_clear_pte_refs() using
rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but not
entirely prevented by page_count() check in ksm.c's write_protect_page():
that risk being shared with page_referenced() and not helped by lru_lock).

Link: https://lkml.kernel.org/r/1604566549-62481-8-git-send-email-alex.shi@=
linux.alibaba.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
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
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page_idle.c~mm-page_idle_get_page-does-not-need-lru_lock
+++ a/mm/page_idle.c
@@ -32,19 +32,15 @@
 static struct page *page_idle_get_page(unsigned long pfn)
 {
 	struct page *page =3D pfn_to_online_page(pfn);
-	pg_data_t *pgdat;
=20
 	if (!page || !PageLRU(page) ||
 	    !get_page_unless_zero(page))
 		return NULL;
=20
-	pgdat =3D page_pgdat(page);
-	spin_lock_irq(&pgdat->lru_lock);
 	if (unlikely(!PageLRU(page))) {
 		put_page(page);
 		page =3D NULL;
 	}
-	spin_unlock_irq(&pgdat->lru_lock);
 	return page;
 }
=20
_
