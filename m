From: akpm@linux-foundation.org
Subject: + mm-reduce-atomic-use-on-use_mm-fast-path.patch added to -mm tree
Date: Mon, 21 Sep 2009 13:48:51 -0700
Message-ID: <200909212048.n8LKmpCD004750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZIUUtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 16:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, aarcange@redhat.com


The patch titled
     mm: reduce atomic use on use_mm fast path
has been added to the -mm tree.  Its filename is
     mm-reduce-atomic-use-on-use_mm-fast-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reduce atomic use on use_mm fast path
From: "Michael S. Tsirkin" <mst@redhat.com>

When the mm being switched to matches the active mm, we don't need to
increment and then drop the mm count.  In a simple benchmark this happens
in about 50% of time.  Making that conditional reduces contention on that
cacheline on SMP systems.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_context.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/mmu_context.c~mm-reduce-atomic-use-on-use_mm-fast-path mm/mmu_context.c
--- a/mm/mmu_context.c~mm-reduce-atomic-use-on-use_mm-fast-path
+++ a/mm/mmu_context.c
@@ -26,13 +26,16 @@ void use_mm(struct mm_struct *mm)
 
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
-	atomic_inc(&mm->mm_count);
+	if (active_mm != mm) {
+		atomic_inc(&mm->mm_count);
+		tsk->active_mm = mm;
+	}
 	tsk->mm = mm;
-	tsk->active_mm = mm;
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
 
-	mmdrop(active_mm);
+	if (active_mm != mm)
+		mmdrop(active_mm);
 }
 
 /*
_

Patches currently in -mm which might be from mst@redhat.com are

origin.patch
linux-next.patch
mm-move-use_mm-unuse_mm-from-aioc-to-mm.patch
mm-reduce-atomic-use-on-use_mm-fast-path.patch

