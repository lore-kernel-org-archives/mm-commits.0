Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B69C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A69223BD
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrH+whaw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgKPV5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:57:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgKPV5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:57:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9E0222EC;
        Mon, 16 Nov 2020 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563827;
        bh=VdeW/binKopmBLgypQvHqtBwjMwTQdGTsYLA346gfIw=;
        h=Date:From:To:Subject:From;
        b=FrH+whawSsf6/5fXI01gjUUm/NtIewaiOWVcvG7zBEWXVdY6/to+af9N8lpxv0/8Y
         ImlQj01y+j7yavmnGTInQoOXqPPgJWlCiO5/NAGVNZTPowFa9qKM4oJI9GibBNJrG4
         rA2YztpiesJhWWU2ubcPoTwhWyLmP5JFCLNecEjw=
Date:   Mon, 16 Nov 2020 13:57:05 -0800
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
Subject:  + mm-page_idle_get_page-does-not-need-lru_lock.patch
 added to -mm tree
Message-ID: <20201116215705.U2_vjxhgF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_idle_get_page() does not need lru_lock
has been added to the -mm tree.  Its filename is
     mm-page_idle_get_page-does-not-need-lru_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_idle_get_page-does-no=
t-need-lru_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_idle_get_page-does-no=
t-need-lru_lock.patch

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

Patches currently in -mm which might be from hughd@google.com are

mm-page_idle_get_page-does-not-need-lru_lock.patch
mm-lru-revise-the-comments-of-lru_lock.patch

