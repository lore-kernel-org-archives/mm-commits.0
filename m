From: akpm@linux-foundation.org
Subject: + slub-remove-obsolete-comments-of-put_cpu_partial.patch added to -mm tree
Date: Fri, 26 Jan 2018 13:04:32 -0800
Message-ID: <5a6b97e0./GwcqHKGMyihDy1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbeAZVEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jan 2018 16:04:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: remove obsolete comments of put_cpu_partial()
has been added to the -mm tree.  Its filename is
     slub-remove-obsolete-comments-of-put_cpu_partial.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-remove-obsolete-comments-of-put_cpu_partial.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-remove-obsolete-comments-of-put_cpu_partial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Vladimir Davydov <vdavydov@parallels.com>
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

Patches currently in -mm which might be from miles.chen@mediatek.com are

slub-remove-obsolete-comments-of-put_cpu_partial.patch

