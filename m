From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:36:44 -0800
Message-ID: <58b0b57c.N3xCF3ycYZ/0GMyC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdBXWgu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2.patch

This patch was dropped because it was folded into userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2

The prototypes for MMU-based machines and MMU-less builds have to be the
same, this fixes the build errors I saw:

mm/nommu.c:1201:15: error: conflicting types for 'do_mmap'
mm/nommu.c:1580:5: error: conflicting types for 'do_munmap'

Fixes: mmtom ("userfaultfd: non-cooperative: add event for memory unmaps")
Link: http://lkml.kernel.org/r/20170203165141.3665284-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c  |    2 +-
 mm/nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2 ipc/shm.c
--- a/ipc/shm.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2
+++ a/ipc/shm.c
@@ -1365,7 +1365,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 	 * given
 	 */
 	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
-		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
+		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
 		retval = 0;
 	}
 
diff -puN mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2 mm/nommu.c
--- a/mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix-2
+++ a/mm/nommu.c
@@ -1206,7 +1206,7 @@ unsigned long do_mmap(struct file *file,
 			vm_flags_t vm_flags,
 			unsigned long pgoff,
 			unsigned long *populate,
-			struct list_head *uf_unused)
+			struct list_head *uf)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
_

Patches currently in -mm which might be from arnd@arndb.de are

userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix.patch

