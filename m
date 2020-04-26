From: akpm@linux-foundation.org
Subject: + mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
 added to -mm tree
Date: Sat, 25 Apr 2020 23:54:07 -0700
Message-ID: <20200426065407.uRUZ4F2dw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgDZGyJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Apr 2020 02:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, jannh@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch

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
Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix

whoops

Cc: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-pass-task-and-mm-to-do_madvise-fix-fix-fix
+++ a/mm/madvise.c
@@ -1143,7 +1143,7 @@ int do_madvise(struct task_struct *targe
 		 * model.
 		 */
 		if (!mmget_still_valid(mm)) {
-			up_write(mm->mmap_sem);
+			up_write(&mm->mmap_sem);
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
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
linux-next-git-rejects-fix.patch
