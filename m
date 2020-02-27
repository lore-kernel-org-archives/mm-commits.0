From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch added
 to -mm tree
Date: Thu, 27 Feb 2020 15:03:51 -0800
Message-ID: <20200227230351.2YDFVW4gc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgB0XDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: add missing annotation for compact_lock_irqsave
has been added to the -mm tree.  Its filename is
     mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/compaction: add missing annotation for compact_lock_irqsave

Sparse reports a warning at compact_lock_irqsave()

warning: context imbalance in compact_lock_irqsave() - wrong count at exit

The root cause is the missing annotation at compact_lock_irqsave()
Add the missing __acquires(lock) annotation.

Link: http://lkml.kernel.org/r/20200214204741.94112-6-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/compaction.c~mm-compaction-add-missing-annotation-for-compact_lock_irqsave
+++ a/mm/compaction.c
@@ -481,6 +481,7 @@ static bool test_and_set_skip(struct com
  */
 static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 						struct compact_control *cc)
+	__acquires(lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch
mm-memcontrol-add-missing-annotation-for-unlock_page_lru.patch
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
