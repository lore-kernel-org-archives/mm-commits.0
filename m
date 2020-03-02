From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-add-missing-annotation-for-unlock_page_lru.patch removed from
 -mm tree
Date: Mon, 02 Mar 2020 14:18:19 -0800
Message-ID: <20200302221819.ODnGI4_yv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBWSV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:18:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: add missing annotation for unlock_page_lru()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-missing-annotation-for-unlock_page_lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/memcontrol: add missing annotation for unlock_page_lru()

Sparse reports warning at unlock_page_lry()

warning: context imbalance in unlock_page_lru() - unexpected unlock

The root cause is the missing annotation at unlock_page_lru() Add the
missing __releases(&pgdat->lru_lock)

Link: http://lkml.kernel.org/r/20200214204741.94112-4-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcontrol-add-missing-annotation-for-unlock_page_lru
+++ a/mm/memcontrol.c
@@ -2588,6 +2588,7 @@ static void lock_page_lru(struct page *p
 }
 
 static void unlock_page_lru(struct page *page, int isolated)
+	__releases(&pgdat->lru_lock)
 {
 	pg_data_t *pgdat = page_pgdat(page);
 
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch
mm-memcontrol-add-missing-annotation-for-lock_page_lru.patch
mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch
mm-hugetlb-add-missing-annotation-for-gather_surplus_pages.patch
mm-mempolicy-add-missing-annotation-for-queue_pages_pmd.patch
mm-slub-add-missing-annotation-for-get_map.patch
mm-slub-add-missing-annotation-for-put_map.patch
mm-zsmalloc-add-missing-annotation-for-migrate_read_lock.patch
mm-zsmalloc-add-missing-annotation-for-migrate_read_unlock.patch
mm-zsmalloc-add-missing-annotation-for-pin_tag.patch
mm-zsmalloc-add-missing-annotation-for-unpin_tag.patch
proc-annotate-close_pdeo-for-sparse.patch
