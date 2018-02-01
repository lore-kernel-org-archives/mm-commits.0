From: akpm@linux-foundation.org
Subject: [patch 029/119] slub: remove obsolete comments of
 put_cpu_partial()
Date: Wed, 31 Jan 2018 16:15:47 -0800
Message-ID: <20180201001547.dK_FNEicR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAPt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Miles Chen <miles.chen@mediatek.com>
Subject: slub: remove obsolete comments of put_cpu_partial()

d6e0b7fa1186 ("slub: make dead caches discard free slabs immediately")
makes put_cpu_partial() run with preemption disabled and interrupts
disabled when calling unfreeze_partials().

The comment: "put_cpu_partial() is done without interrupts disabled and
without preemption disabled" looks obsolete, so remove it.

Link: http://lkml.kernel.org/r/1516968550-1520-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slub.c~slub-remove-obsolete-comments-of-put_cpu_partial mm/slub.c
--- a/mm/slub.c~slub-remove-obsolete-comments-of-put_cpu_partial
+++ a/mm/slub.c
@@ -2222,9 +2222,7 @@ static void unfreeze_partials(struct kme
 
 /*
  * Put a page that was just frozen (in __slab_free) into a partial page
- * slot if available. This is done without interrupts disabled and without
- * preemption disabled. The cmpxchg is racy and may put the partial page
- * onto a random cpus partial slot.
+ * slot if available.
  *
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
_
