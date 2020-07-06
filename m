From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch added to
 -mm tree
Date: Mon, 06 Jul 2020 16:15:56 -0700
Message-ID: <20200706231556.LFvGuZe-v%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgGFXP5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:15:57 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mm-commits@vger.kernel.org, penberg@kernel.org, songmuchun@bytedance.com


The patch titled
     Subject: mm/page_alloc.c: skip setting nodemask when we are in interrupt
has been added to the -mm tree.  Its filename is
     mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_alloc.c: skip setting nodemask when we are in interrupt

When we are in the interrupt context, it is irrelevant to the current task
context.  If we use current task's mems_allowed, we can be fair to alloc
pages in the fast path and fall back to slow path memory allocation when
the current node(which is the current task mems_allowed) does not have
enough memory to allocate.  In this case, it slows down the memory
allocation speed of interrupt context.  So we can skip setting the
nodemask to allow any node to allocate memory, so that fast path
allocation can success.

Link: http://lkml.kernel.org/r/20200706025921.53683-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt
+++ a/mm/page_alloc.c
@@ -4790,7 +4790,11 @@ static inline bool prepare_alloc_pages(g
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
-		if (!ac->nodemask)
+		/*
+		 * When we are in the interrupt context, it is irrelevant
+		 * to the current task context. It means that any node ok.
+		 */
+		if (!in_interrupt() && !ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-page_alloc-skip-setting-nodemask-when-we-are-in-interrupt.patch
