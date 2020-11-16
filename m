Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F4AC388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A88223AB
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 21:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSiGpt67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgKPV6D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 16:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPV6D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 16:58:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475292225E;
        Mon, 16 Nov 2020 21:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563882;
        bh=jCbqHCdoDJBir0qM/7GKooYKB4lE1Sd+adXXkTGLchU=;
        h=Date:From:To:Subject:From;
        b=YSiGpt67mMf68MnBzwkH5QTKUD6b0AkS1j0wKimoC8ZrwJR86FOjf/kuxaQ3xAUOi
         AdOpcz7WDCg8Lr7rT2DFbqa0stp0A6kXN+VZvdR6NKxQkhak/fLVcGHfdg2vQO40n3
         e9tpkahRw9GpaHwTtBlPKiE1vHQmb4ZAV2ktzUS0=
Date:   Mon, 16 Nov 2020 13:57:59 -0800
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
 mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch added to -mm
 tree
Message-ID: <20201116215759.fzQzkrmQS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2
has been added to the -mm tree.  Its filename is
     mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-lru-replace-pgdat-lru_lock=
-with-lruvec-lock-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-lru-replace-pgdat-lru_lock=
-with-lruvec-lock-fix-2.patch

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
Subject: mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2

use page_memcg()

Link: https://lkml.kernel.org/r/5a4c2b72-7ee8-2478-fc0e-85eb83aafec4@linux.=
alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Rong Chen <rong.a.chen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2
+++ a/mm/memcontrol.c
@@ -1318,13 +1318,17 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 #ifdef CONFIG_DEBUG_VM
 void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
 {
+	struct mem_cgroup *memcg;
+
 	if (mem_cgroup_disabled())
 		return;
=20
-	if (!page->mem_cgroup)
+	memcg =3D page_memcg(page);
+
+	if (!memcg)
 		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D root_mem_cgroup, page);
 	else
-		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D page->mem_cgroup, page);
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D memcg, page);
 }
 #endif
=20
@@ -3333,7 +3337,7 @@ void obj_cgroup_uncharge(struct obj_cgro
=20
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * Because page->mem_cgroup is not set on compound tails, set it now.
+ * Because page_memcg(head) is not set on compound tails, set it now.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
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

