From: akpm@linux-foundation.org
Subject: + mm-pass-task-and-mm-to-do_madvise-fix-fix.patch added
 to -mm tree
Date: Sat, 25 Apr 2020 16:01:07 -0700
Message-ID: <20200425230107.LWhErP1dA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgDYXBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 19:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, jannh@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix
has been added to the -mm tree.  Its filename is
     mm-pass-task-and-mm-to-do_madvise-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix

fix it for upstream changes

Cc: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-pass-task-and-mm-to-do_madvise-fix-fix
+++ a/mm/madvise.c
@@ -1108,8 +1108,8 @@ int do_madvise(struct task_struct *targe
 		 * but for now we have the mmget_still_valid()
 		 * model.
 		 */
-		if (!mmget_still_valid(current->mm)) {
-			up_write(&current->mm->mmap_sem);
+		if (!mmget_still_valid(mm)) {
+			up_write(mm->mmap_sem);
 			return -EINTR;
 		}
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
