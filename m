From: akpm@linux-foundation.org
Subject: [folded-merged] mm-per-thread-vma-caching-fix-6.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:04:44 -0700
Message-ID: <534320fc.hsrjeG2ayKEsilab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaDGWEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, oleg@redhat.com, davidlohr@hp.com, hughd@google.com

Subject: [folded-merged] mm-per-thread-vma-caching-fix-6.patch removed from -mm tree
To: hughd@google.com,davidlohr@hp.com,oleg@redhat.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:44 -0700


The patch titled
     Subject: mm-per-thread-vma-caching-fix-6
has been removed from the -mm tree.  Its filename was
     mm-per-thread-vma-caching-fix-6.patch

This patch was dropped because it was folded into mm-per-thread-vma-caching.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-per-thread-vma-caching-fix-6

I was getting the "kernel BUG at mm/vmacache.c:76!" running KSM
on mmotm: Oleg's patch (buildable version below) fixes it for me.

Tested-by: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-6 mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-6
+++ a/mm/vmacache.c
@@ -31,15 +31,20 @@ void vmacache_flush_all(struct mm_struct
 	rcu_read_unlock();
 }
 
+static bool vmacache_valid_mm(struct mm_struct *mm)
+{
+	return current->mm == mm && !(current->flags & PF_KTHREAD);
+}
+
 void vmacache_update(unsigned long addr, struct vm_area_struct *newvma)
 {
-	int idx = VMACACHE_HASH(addr);
-	current->vmacache[idx] = newvma;
+	if (vmacache_valid_mm(newvma->vm_mm))
+		current->vmacache[VMACACHE_HASH(addr)] = newvma;
 }
 
 static bool vmacache_valid(struct mm_struct *mm)
 {
-	struct task_struct *curr = current;
+	struct task_struct *curr;
 
 	/*
 	 * This task may be accessing a foreign mm via (for example)
@@ -47,9 +52,10 @@ static bool vmacache_valid(struct mm_str
 	 * task's vmacache pertains to a different mm (ie, its own).  There is
 	 * nothing we can do here.
 	 */
-	if (mm != curr->mm)
-		return false;
+	if (!vmacache_valid_mm(mm))
+ 		return false;
 
+	curr = current;
 	if (mm->vmacache_seqnum != curr->vmacache_seqnum) {
 		/*
 		 * First attempt will always be invalid, initialize
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-implement-map_pages-for-page-cache.patch
mm-implement-map_pages-for-shmem-tmpfs.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

