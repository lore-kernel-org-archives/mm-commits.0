From: akpm@linux-foundation.org
Subject: + sched-mm-optimize-current_gfp_context.patch added to -mm
 tree
Date: Sat, 20 Jun 2020 17:23:57 -0700
Message-ID: <20200621002357.mYUf7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgFUAX7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 20:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, peterz@infradead.org, mingo@redhat.com, mathieu.desnoyers@efficios.com, longman@redhat.com


The patch titled
     Subject: include/linux/sched/mm.h: optimize current_gfp_context()
has been added to the -mm tree.  Its filename is
     sched-mm-optimize-current_gfp_context.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-mm-optimize-current_gfp_context.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-mm-optimize-current_gfp_context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: include/linux/sched/mm.h: optimize current_gfp_context()

The current_gfp_context() converts a number of PF_MEMALLOC_* per-process
flags into the corresponding GFP_* flags for memory allocation.  In that
function, current->flags is accessed 3 times.  That may lead to duplicated
access of the same memory location.

This is not usually a problem with minimal debug config options on as the
compiler can optimize away the duplicated memory accesses.  With most of
the debug config options on, however, that may not be the case.  For
example, the x86-64 object size of the __need_fs_reclaim() in a debug
kernel that calls current_gfp_context() was 309 bytes.  With this patch
applied, the object size is reduced to 202 bytes.  This is a saving of 107
bytes and will probably be slightly faster too.

Link: http://lkml.kernel.org/r/20200618212936.9776-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/sched/mm.h~sched-mm-optimize-current_gfp_context
+++ a/include/linux/sched/mm.h
@@ -181,18 +181,20 @@ static inline bool in_vfork(struct task_
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags &
+	unsigned int pflags = READ_ONCE(current->flags);
+
+	if (unlikely(pflags &
 		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
-		if (current->flags & PF_MEMALLOC_NOIO)
+		if (pflags & PF_MEMALLOC_NOIO)
 			flags &= ~(__GFP_IO | __GFP_FS);
-		else if (current->flags & PF_MEMALLOC_NOFS)
+		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
 #ifdef CONFIG_CMA
-		if (current->flags & PF_MEMALLOC_NOCMA)
+		if (pflags & PF_MEMALLOC_NOCMA)
 			flags &= ~__GFP_MOVABLE;
 #endif
 	}
_

Patches currently in -mm which might be from longman@redhat.com are

mm-slab-use-memzero_explicit-in-kzfree.patch
mm-slab-fix-sign-conversion-problem-in-memcg_uncharge_slab.patch
mm-treewide-rename-kzfree-to-kfree_sensitive.patch
sched-mm-optimize-current_gfp_context.patch
