From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 20:17:50 -0700
Message-ID: <20200609031750.hgqLfH4Wa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDRv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jhubbard@nvidia.com, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch

This patch was dropped because it was folded into mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix

fix it for mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch

Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix
+++ a/mm/gup.c
@@ -2750,7 +2750,7 @@ static int internal_get_user_pages_fast(
 		return -EINVAL;
 
 	if (!(gup_flags & FOLL_FAST_ONLY))
-		might_lock_read(&current->mm->mmap_sem);
+		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
 	addr = start;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
