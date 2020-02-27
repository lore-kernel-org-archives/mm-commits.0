From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-add-missing-annotation-for-pin_tag.patch
 added to -mm tree
Date: Thu, 27 Feb 2020 15:04:05 -0800
Message-ID: <20200227230405.NW-pQepP3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbgB0XEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:04:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add missing annotation for pin_tag()
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-add-missing-annotation-for-pin_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-add-missing-annotation-for-pin_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-add-missing-annotation-for-pin_tag.patch

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
Subject: mm/zsmalloc: add missing annotation for pin_tag()

Sparse reports a warning at pin_tag()()

warning: context imbalance in pin_tag() - wrong count at exit

The root cause is the missing annotation at pin_tag()
Add the missing __acquires(bitlock) annotation

Link: http://lkml.kernel.org/r/20200214204741.94112-13-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-missing-annotation-for-pin_tag
+++ a/mm/zsmalloc.c
@@ -891,7 +891,7 @@ static inline int trypin_tag(unsigned lo
 	return bit_spin_trylock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
-static void pin_tag(unsigned long handle)
+static void pin_tag(unsigned long handle) __acquires(bitlock)
 {
 	bit_spin_lock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
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
