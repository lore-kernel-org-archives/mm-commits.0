Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDB3C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C30C61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhF2CjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231936AbhF2CjH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE93C61D04;
        Tue, 29 Jun 2021 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934201;
        bh=xGBMGCmmIHP26iKWG62viHtmpwDlwJTxolKsI8NjCMM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZOE3Ms+iCcGPBGj4EoVfsjB1YeLPHu0L3j0cNh/lyk4l36uhetyqlXTdnXCbji4t/
         Y1a250vZm7O86ZtoegI3pGn57GihntbRN6epb58VpC+ci/Iu/lvF/+taeXPEy59fKJ
         NSojTfGmwPg5ZThIL/3sLYIUbhxwBESBbmZPVJFI=
Date:   Mon, 28 Jun 2021 19:36:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        jack@suse.cz, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill@shutemov.name, ktkhai@virtuozzo.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 065/192] mm: gup: pack has_pinned in
 MMF_HAS_PINNED
Message-ID: <20210629023640.yfp2qi8HV%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: pack has_pinned in MMF_HAS_PINNED

has_pinned 32bit can be packed in the MMF_HAS_PINNED bit as a noop
cleanup.

Any atomic_inc/dec to the mm cacheline shared by all threads in pin-fast
would reintroduce a loss of SMP scalability to pin-fast, so there's no
future potential usefulness to keep an atomic in the mm for this.

set_bit(MMF_HAS_PINNED) will be theoretically a bit slower than WRITE_ONCE
(atomic_set is equivalent to WRITE_ONCE), but the set_bit (just like
atomic_set after this commit) has to be still issued only once per "mm",
so the difference between the two will be lost in the noise.

will-it-scale "mmap2" shows no change in performance with enterprise
config as expected.

will-it-scale "pin_fast" retains the > 4000% SMP scalability performance
improvement against upstream as expected.

This is a noop as far as overall performance and SMP scalability are
concerned.

[peterx@redhat.com: pack has_pinned in MMF_HAS_PINNED]
  Link: https://lkml.kernel.org/r/YJqWESqyxa8OZA+2@t490s
[akpm@linux-foundation.org: coding style fixes]
[peterx@redhat.com: fix build for task_mmu.c, introduce mm_set_has_pinned_flag, fix comments]
Link: https://lkml.kernel.org/r/20210507150553.208763-4-peterx@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c             |    2 +-
 include/linux/mm.h             |    2 +-
 include/linux/mm_types.h       |   10 ----------
 include/linux/sched/coredump.h |    8 ++++++++
 kernel/fork.c                  |    1 -
 mm/gup.c                       |   19 +++++++++++++++----
 6 files changed, 25 insertions(+), 17 deletions(-)

--- a/fs/proc/task_mmu.c~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/fs/proc/task_mmu.c
@@ -1047,7 +1047,7 @@ static inline bool pte_is_pinned(struct
 		return false;
 	if (!is_cow_mapping(vma->vm_flags))
 		return false;
-	if (likely(!atomic_read(&vma->vm_mm->has_pinned)))
+	if (likely(!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags)))
 		return false;
 	page = vm_normal_page(vma, addr, pte);
 	if (!page)
--- a/include/linux/mm.h~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/include/linux/mm.h
@@ -1341,7 +1341,7 @@ static inline bool page_needs_cow_for_dm
 	if (!is_cow_mapping(vma->vm_flags))
 		return false;
 
-	if (!atomic_read(&vma->vm_mm->has_pinned))
+	if (!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags))
 		return false;
 
 	return page_maybe_dma_pinned(page);
--- a/include/linux/mm_types.h~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/include/linux/mm_types.h
@@ -435,16 +435,6 @@ struct mm_struct {
 		 */
 		atomic_t mm_count;
 
-		/**
-		 * @has_pinned: Whether this mm has pinned any pages.  This can
-		 * be either replaced in the future by @pinned_vm when it
-		 * becomes stable, or grow into a counter on its own. We're
-		 * aggresive on this bit now - even if the pinned pages were
-		 * unpinned later on, we'll still keep this bit set for the
-		 * lifecycle of this mm just for simplicity.
-		 */
-		atomic_t has_pinned;
-
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* PTE page table pages */
 #endif
--- a/include/linux/sched/coredump.h~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/include/linux/sched/coredump.h
@@ -73,6 +73,14 @@ static inline int get_dumpable(struct mm
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
 #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	27	/* mm is shared between processes */
+/*
+ * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
+ * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
+ * a counter on its own. We're aggresive on this bit for now: even if the
+ * pinned pages were unpinned later on, we'll still keep this bit set for the
+ * lifecycle of this mm, just for simplicity.
+ */
+#define MMF_HAS_PINNED		28	/* FOLL_PIN has run, never cleared */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
--- a/kernel/fork.c~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/kernel/fork.c
@@ -1029,7 +1029,6 @@ static struct mm_struct *mm_init(struct
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
-	atomic_set(&mm->has_pinned, 0);
 	atomic64_set(&mm->pinned_vm, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
--- a/mm/gup.c~mm-gup-pack-has_pinned-in-mmf_has_pinned
+++ a/mm/gup.c
@@ -420,6 +420,17 @@ void unpin_user_pages(struct page **page
 }
 EXPORT_SYMBOL(unpin_user_pages);
 
+/*
+ * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
+ * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
+ * cache bouncing on large SMP machines for concurrent pinned gups.
+ */
+static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
+{
+	if (!test_bit(MMF_HAS_PINNED, mm_flags))
+		set_bit(MMF_HAS_PINNED, mm_flags);
+}
+
 #ifdef CONFIG_MMU
 static struct page *no_page_table(struct vm_area_struct *vma,
 		unsigned int flags)
@@ -1320,8 +1331,8 @@ static __always_inline long __get_user_p
 		BUG_ON(*locked != 1);
 	}
 
-	if ((flags & FOLL_PIN) && !atomic_read(&mm->has_pinned))
-		atomic_set(&mm->has_pinned, 1);
+	if (flags & FOLL_PIN)
+		mm_set_has_pinned_flag(&mm->flags);
 
 	/*
 	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
@@ -2641,8 +2652,8 @@ static int internal_get_user_pages_fast(
 				       FOLL_FAST_ONLY)))
 		return -EINVAL;
 
-	if ((gup_flags & FOLL_PIN) && !atomic_read(&current->mm->has_pinned))
-		atomic_set(&current->mm->has_pinned, 1);
+	if (gup_flags & FOLL_PIN)
+		mm_set_has_pinned_flag(&current->mm->flags);
 
 	if (!(gup_flags & FOLL_FAST_ONLY))
 		might_lock_read(&current->mm->mmap_lock);
_
