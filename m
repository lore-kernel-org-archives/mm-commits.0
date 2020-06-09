From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mmap-locking-api-convert-mmap=5Fsem-call-sites-missed-by-?=
 =?US-ASCII?Q?coccinelle-fix-fix.patch?= removed from -mm tree
Date: Mon, 08 Jun 2020 20:16:51 -0700
Message-ID: <20200609031651.LCb87d799%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix

more linux-next leftovers

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix
+++ a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
@@ -982,9 +982,9 @@ static int alloc_user_pages(struct hmm_b
 	}
 
 	mutex_unlock(&bo->mutex);
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma(current->mm, (unsigned long)userptr);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	if (!vma) {
 		dev_err(atomisp_dev, "find_vma failed\n");
 		kfree(bo->page_obj);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
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
