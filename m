From: akpm@linux-foundation.org
Subject: + tmpfs-fix-shmem_getpage_gfp-vm_bug_on-fix.patch added to -mm tree
Date: Fri, 16 Nov 2012 11:54:09 -0800
Message-ID: <20121116195410.07F85200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65207 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2KPTyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 14:54:12 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so202824eei.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 11:54:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, davej@redhat.com, hannes@cmpxchg.com


The patch titled
     Subject: tmpfs: fix shmem_getpage_gfp VM_BUG_ON fix
has been added to the -mm tree.  Its filename is
     tmpfs-fix-shmem_getpage_gfp-vm_bug_on-fix.patch

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
Subject: tmpfs: fix shmem_getpage_gfp VM_BUG_ON fix

We're still hoping to hear back from Dave Jones, but either way, please
fold this patch into the earlier fix for 3.7 and -stable.

Remove its VM_BUG_ON: because either it's as I believe, a tautology
which cannot happen, and does not assert what I'd intended when I put
it in,and would even be wrong if it did (a non-NULL entry can validly
materialize there); or Dave actually hit it on his updated kernel,
in which case more research will be needed, but for upstream we
do not want a user to BUG there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-shmem_getpage_gfp-vm_bug_on-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-shmem_getpage_gfp-vm_bug_on-fix
+++ a/mm/shmem.c
@@ -1157,10 +1157,8 @@ repeat:
 			 * Reset swap.val? No, leave it so "failed" goes back to
 			 * "repeat": reading a hole and writing should succeed.
 			 */
-			if (error) {
-				VM_BUG_ON(error != -ENOENT);
+			if (error)
 				delete_from_swap_cache(page);
-			}
 		}
 		if (error)
 			goto failed;
_

Patches currently in -mm which might be from hughd@google.com are

memcg-fix-hotplugged-memory-zone-oops.patch
linux-next.patch
tmpfs-fix-shmem_getpage_gfp-vm_bug_on.patch
tmpfs-fix-shmem_getpage_gfp-vm_bug_on-fix.patch
tmpfs-change-final-i_blocks-bug-to-warning.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

