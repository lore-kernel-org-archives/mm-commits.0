From: akpm@linux-foundation.org
Subject: [merged] shmem-let-shared-anonymous-be-nonlinear-again.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:15 -0700
Message-ID: <201103232041.p2NKfq6P028689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933408Ab1CWUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, stable@kernel.org, theonetruekenny@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     shmem: let shared anonymous be nonlinear again
has been removed from the -mm tree.  Its filename was
     shmem-let-shared-anonymous-be-nonlinear-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: let shared anonymous be nonlinear again
From: Hugh Dickins <hughd@google.com>

Up to 2.6.22, you could use remap_file_pages(2) on a tmpfs file or a
shared mapping of /dev/zero or a shared anonymous mapping.  In 2.6.23 we
disabled it by default, but set VM_CAN_NONLINEAR to enable it on safe
mappings.  We made sure to set it in shmem_mmap() for tmpfs files, but
missed it in shmem_zero_setup() for the others.  Fix that at last.

Reported-by: Kenny Simpson <theonetruekenny@yahoo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~shmem-let-shared-anonymous-be-nonlinear-again mm/shmem.c
--- a/mm/shmem.c~shmem-let-shared-anonymous-be-nonlinear-again
+++ a/mm/shmem.c
@@ -2793,5 +2793,6 @@ int shmem_zero_setup(struct vm_area_stru
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

