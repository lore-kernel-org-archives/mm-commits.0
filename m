Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AC5C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA10E22510
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 20:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgLOU2k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:28:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgLOU2a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 15:28:30 -0500
Date:   Tue, 15 Dec 2020 12:27:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608064070;
        bh=INkjbsV9UPKNewnwGoogCOhYVldVbwckye1laAlvEh0=;
        h=From:To:Subject:From;
        b=Vvkhu4m2B8+FMgSAAnoDt2wUiwxgH9bz70ZViOH7j3JZ0r+GTxG7kx50AH9kBS3IU
         wedE4LKK9XWYw/y9IX3qPG0gDt4rrFaMHxmpLmS8PNvTVhutD/NQ0D2dmWmqEcAY67
         KtcBiIVLZi+x9f2YqwNcf6ICeS8HCvYN9Vm1/Z0I=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com,
        alexander.h.duyck@linux.intel.com, aryabinin@virtuozzo.com,
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
Subject:  [folded-merged]
 mm-lru-introduce-the-relock_page_lruvec-function-fix.patch removed from -mm
 tree
Message-ID: <20201215202748.XY_0Pwa9O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-lru-introduce-the-relock_page_lruvec-function-fix
has been removed from the -mm tree.  Its filename was
     mm-lru-introduce-the-relock_page_lruvec-function-fix.patch

This patch was dropped because it was folded into mm-lru-introduce-the-relo=
ck_page_lruvec-function.patch

------------------------------------------------------
=46rom: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm-lru-introduce-the-relock_page_lruvec-function-fix

use page_memcg()

Link: https://lkml.kernel.org/r/66d8e79d-7ec6-bfbc-1c82-bf32db3ae5b7@linux.=
alibaba.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-lru-introduce-the-relock_page_lruvec-fu=
nction-fix
+++ a/include/linux/memcontrol.h
@@ -496,7 +496,7 @@ static inline bool lruvec_holds_page_lru
 		return lruvec =3D=3D &pgdat->__lruvec;
=20
 	mz =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg =3D page->mem_cgroup ? : root_mem_cgroup;
+	memcg =3D page_memcg(page) ? : root_mem_cgroup;
=20
 	return lruvec->pgdat =3D=3D pgdat && mz->memcg =3D=3D memcg;
 }
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-memcg-remove-incorrect-comments.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_rever=
se.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
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
mm-lru-introduce-the-relock_page_lruvec-function.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

