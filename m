From: akpm@linux-foundation.org
Subject: + ksm-prevent-mremap-move-poisoning.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:07:49 -0700
Message-ID: <200907232107.n6NL7n7o027844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862AbZGWVIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     ksm: prevent mremap move poisoning
has been added to the -mm tree.  Its filename is
     ksm-prevent-mremap-move-poisoning.patch

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
Subject: ksm: prevent mremap move poisoning
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM's scan allows for user pages to be COWed or unmapped at any time,
without requiring any notification.  But its stable tree does assume that
when it finds a KSM page where it placed a KSM page, then it is the same
KSM page that it placed there.

mremap move could break that assumption: if an area containing a KSM page
was unmapped, then an area containing a different KSM page was moved with
mremap into the place of the original, before KSM's scan came around to
notice.  That could then poison a node of the stable tree, so that memcmps
would "lie" and upset the ordering of the tree.

Probably noone will ever need mremap move on a VM_MERGEABLE area; except
that prohibiting it would make trouble for schemes in which we try making
everything VM_MERGEABLE e.g.  for testing: an mremap which normally works
would then fail mysteriously.

There's no need to go to any trouble, such as re-sorting KSM's list of
rmap_items to match the new layout: simply unmerge the area to COW all its
KSM pages before moving, but leave VM_MERGEABLE on so that they're
remerged later.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/mremap.c~ksm-prevent-mremap-move-poisoning mm/mremap.c
--- a/mm/mremap.c~ksm-prevent-mremap-move-poisoning
+++ a/mm/mremap.c
@@ -11,6 +11,7 @@
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/shm.h>
+#include <linux/ksm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/capability.h>
@@ -182,6 +183,17 @@ static unsigned long move_vma(struct vm_
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	/*
+	 * Advise KSM to break any KSM pages in the area to be moved:
+	 * it would be confusing if they were to turn up at the new
+	 * location, where they happen to coincide with different KSM
+	 * pages recently unmapped.  But leave vma->vm_flags as it was,
+	 * so KSM can come around to merge on vma and new_vma afterwards.
+	 */
+	if (ksm_madvise(vma, old_addr, old_addr + old_len,
+						MADV_UNMERGEABLE, &vm_flags))
+		return -ENOMEM;
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
 	if (!new_vma)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mm-avoid-endless-looping-for-oom-killed-tasks.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
prio_tree-debugging-patch.patch

