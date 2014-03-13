From: akpm@linux-foundation.org
Subject: + mm-per-thread-vma-caching-fix-6.patch added to -mm tree
Date: Thu, 13 Mar 2014 14:05:26 -0700
Message-ID: <53221d96.tM40uERW/A5YAop6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaCMVF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 17:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, oleg@redhat.com, davidlohr@hp.com, hughd@google.com

Subject: + mm-per-thread-vma-caching-fix-6.patch added to -mm tree
To: hughd@google.com,davidlohr@hp.com,oleg@redhat.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 14:05:26 -0700


The patch titled
     Subject: mm-per-thread-vma-caching-fix-6
has been added to the -mm tree.  Its filename is
     mm-per-thread-vma-caching-fix-6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-per-thread-vma-caching-fix-6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-per-thread-vma-caching-fix-6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-implement-map_pages-for-page-cache-fix.patch
mm-per-thread-vma-caching-fix-6.patch
mm-per-thread-vma-caching-fix-6-fix.patch

