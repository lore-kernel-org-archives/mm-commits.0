Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9E5C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B4FE61421
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEIAiW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEIAiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:38:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E281E611F1;
        Sun,  9 May 2021 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620520638;
        bh=R+pRItm87ExVulx8QJCah1huUMR8rN0eOk+IYtb4KWg=;
        h=Date:From:To:Subject:From;
        b=dFlsd/CVzivptvKjrkXWGfpEQViSCxDK3JE/AF4nfvfvRstQDenGO2TXoJa6vQlWz
         YpECw7sChkulqDiZ7d/PzuHygRUkwnMf+A7933Tb49um8YeEzBxKToIAUg5HozYWPE
         HKzqplBnqakTBCa3BcGmTgsSQKYDKmkR8QwCfjGA=
Date:   Sat, 08 May 2021 17:37:17 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, jack@suse.cz,
        jannh@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        kirill@shutemov.name, ktkhai@virtuozzo.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, peterx@redhat.com,
        willy@infradead.org
Subject:  + mm-gup-pack-has_pinned-in-mmf_has_pinned.patch added to
 -mm tree
Message-ID: <20210509003717.qfa7XzNhZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: pack has_pinned in MMF_HAS_PINNED
has been added to the -mm tree.  Its filename is
     mm-gup-pack-has_pinned-in-mmf_has_pinned.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -436,16 +436,6 @@ struct mm_struct {
 		atomic_t mm_count;
 
 		/**
-		 * @has_pinned: Whether this mm has pinned any pages.  This can
-		 * be either replaced in the future by @pinned_vm when it
-		 * becomes stable, or grow into a counter on its own. We're
-		 * aggresive on this bit now - even if the pinned pages were
-		 * unpinned later on, we'll still keep this bit set for the
-		 * lifecycle of this mm just for simplicity.
-		 */
-		atomic_t has_pinned;
-
-		/**
 		 * @write_protect_seq: Locked when any thread is write
 		 * protecting pages mapped by this mm to enforce a later COW,
 		 * for instance during page table copying for fork().
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
@@ -1271,6 +1271,17 @@ retry:
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
 /*
+ * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
+ * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
+ * cache bouncing on large SMP machines for concurrent pinned gups.
+ */
+static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
+{
+       if (!test_bit(MMF_HAS_PINNED, mm_flags))
+               set_bit(MMF_HAS_PINNED, mm_flags);
+}
+
+/*
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
  */
@@ -1292,8 +1303,8 @@ static __always_inline long __get_user_p
 		BUG_ON(*locked != 1);
 	}
 
-	if ((flags & FOLL_PIN) && !atomic_read(&mm->has_pinned))
-		atomic_set(&mm->has_pinned, 1);
+	if (flags & FOLL_PIN)
+		mm_set_has_pinned_flag(&mm->flags);
 
 	/*
 	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
@@ -2613,8 +2624,8 @@ static int internal_get_user_pages_fast(
 				       FOLL_FAST_ONLY)))
 		return -EINVAL;
 
-	if ((gup_flags & FOLL_PIN) && !atomic_read(&current->mm->has_pinned))
-		atomic_set(&current->mm->has_pinned, 1);
+	if (gup_flags & FOLL_PIN)
+		mm_set_has_pinned_flag(&current->mm->flags);
 
 	if (!(gup_flags & FOLL_FAST_ONLY))
 		might_lock_read(&current->mm->mmap_lock);
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-gup-allow-foll_pin-to-scale-in-smp.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned.patch

