Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53091C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21736223E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgLWWgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgLWWgM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 17:36:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8951522286;
        Wed, 23 Dec 2020 22:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608762931;
        bh=CPOqkKHb3iJJM6LbHVeDREr4YcniJ+JNg7r6GesCrDY=;
        h=Date:From:To:Subject:From;
        b=MnACb2LwT4B07IYsWatEivo5m/Nqabp9Ya+bPHGnDBmB0Gv+4PFWq+lX2qfmjIK35
         MKPAPjWBgYkUOWbgGD5fnGYdpRKns39TT1rvtsNXYQXYwrmMAyzay37x6bIUZCAFTY
         cqUPndEm3rWqef1H2O3oy4pqnN8B0b7LzOnQ9RwQ=
Date:   Wed, 23 Dec 2020 14:35:31 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        alex.shi@linux.alibaba.com
Subject:  + mm-mmap-replace-if-cond-bug-with-bug_on.patch added to
 -mm tree
Message-ID: <20201223223531.NWDGT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: replace if (cond) BUG() with BUG_ON()
has been added to the -mm tree.  Its filename is
     mm-mmap-replace-if-cond-bug-with-bug_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-replace-if-cond-bug-with-bug_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-replace-if-cond-bug-with-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mmap-replace-if-cond-bug-with-bug_on.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-compaction-remove-rcu_read_lock-during-page-compaction.patch

