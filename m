Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF289C433E0
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 19:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D64523131
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 19:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbhAFTro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 14:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbhAFTro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 14:47:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E350023131;
        Wed,  6 Jan 2021 19:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609962423;
        bh=bu6rP45nZTtfIbGUmjpHRximeEuPjyzlMZzOcBZ4A2g=;
        h=Date:From:To:Subject:From;
        b=jlRGl2Y3o+dygYNALz4mIb0OXtGKWfrjPgAAr2/ndnanL/33bjnKYdHvMD46fSI9Z
         skYgBgUQR7hiDcTv/caPSdxoWVQrlwuHJ1GfvScG6im5R/wIlUTmSAjvOTVytIdDCm
         gA62Xgxs13L4KVsIg9rE66oFx776bWqgj1FH/tPA=
Date:   Wed, 06 Jan 2021 11:47:02 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hughd@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [nacked] mm-mmap-replace-if-cond-bug-with-bug_on.patch
 removed from -mm tree
Message-ID: <20210106194702.qUPJylHbH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: replace if (cond) BUG() with BUG_ON()
has been removed from the -mm tree.  Its filename was
     mm-mmap-replace-if-cond-bug-with-bug_on.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/mmap.c: replace if (cond) BUG() with BUG_ON()

coccinelle reports some warnings:
WARNING: Use BUG_ON instead of if condition followed by BUG.

It could be fixed by BUG_ON().

Link: https://lkml.kernel.org/r/e50574aa-87b8-8ddf-2235-ef98e22bcb7d@linux.alibaba.com
Reported-by: abaci@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~mm-mmap-replace-if-cond-bug-with-bug_on
+++ a/mm/mmap.c
@@ -710,9 +710,8 @@ static void __insert_vm_struct(struct mm
 	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
 
-	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
-			   &prev, &rb_link, &rb_parent))
-		BUG();
+	BUG_ON(find_vma_links(mm, vma->vm_start, vma->vm_end,
+			   &prev, &rb_link, &rb_parent));
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	mm->map_count++;
 }
@@ -3569,9 +3568,8 @@ static void vm_lock_anon_vma(struct mm_s
 		 * can't change from under us thanks to the
 		 * anon_vma->root->rwsem.
 		 */
-		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->root->rb_root.rb_root.rb_node))
-			BUG();
+		BUG_ON(__test_and_set_bit(0, (unsigned long *)
+			&anon_vma->root->rb_root.rb_root.rb_node));
 	}
 }
 
@@ -3587,8 +3585,7 @@ static void vm_lock_mapping(struct mm_st
 		 * mm_all_locks_mutex, there may be other cpus
 		 * changing other bitflags in parallel to us.
 		 */
-		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
-			BUG();
+		BUG_ON(test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags));
 		down_write_nest_lock(&mapping->i_mmap_rwsem, &mm->mmap_lock);
 	}
 }
@@ -3685,9 +3682,8 @@ static void vm_unlock_anon_vma(struct an
 		 * can't change from under us until we release the
 		 * anon_vma->root->rwsem.
 		 */
-		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->root->rb_root.rb_root.rb_node))
-			BUG();
+		BUG_ON(!__test_and_clear_bit(0, (unsigned long *)
+				&anon_vma->root->rb_root.rb_root.rb_node));
 		anon_vma_unlock_write(anon_vma);
 	}
 }
@@ -3700,9 +3696,7 @@ static void vm_unlock_mapping(struct add
 		 * because we hold the mm_all_locks_mutex.
 		 */
 		i_mmap_unlock_write(mapping);
-		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
-					&mapping->flags))
-			BUG();
+		BUG_ON(!test_and_clear_bit(AS_MM_ALL_LOCKS, &mapping->flags));
 	}
 }
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch
mm-memcg-remove-rcu-locking-for-lock_page_lruvec-function-series.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

