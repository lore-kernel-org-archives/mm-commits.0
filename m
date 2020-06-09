From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mmap-locking-api-convert-mmap=5Fsem-call-sites-missed-by-?=
 =?US-ASCII?Q?coccinelle-fix-fix-fix.patch?= removed from -mm tree
Date: Mon, 08 Jun 2020 20:16:58 -0700
Message-ID: <20200609031658.-vD1phAz8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDRB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix

more linux-next leftovers

Cc: Michel Lespinasse <walken@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/vfio_pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/vfio/pci/vfio_pci.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1422,17 +1422,17 @@ static int vfio_pci_zap_and_vma_lock(str
 		mutex_unlock(&vdev->vma_lock);
 
 		if (try) {
-			if (!down_read_trylock(&mm->mmap_sem)) {
+			if (!mmap_read_trylock(mm)) {
 				mmput(mm);
 				return 0;
 			}
 		} else {
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 		}
 		if (mmget_still_valid(mm)) {
 			if (try) {
 				if (!mutex_trylock(&vdev->vma_lock)) {
-					up_read(&mm->mmap_sem);
+					mmap_read_unlock(mm);
 					mmput(mm);
 					return 0;
 				}
@@ -1454,7 +1454,7 @@ static int vfio_pci_zap_and_vma_lock(str
 			}
 			mutex_unlock(&vdev->vma_lock);
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
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
