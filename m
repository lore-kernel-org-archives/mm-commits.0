From: akpm@linux-foundation.org
Subject: - nommu-fix-sysv-ipc-shm.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:31 -0700
Message-ID: <200707312354.l6VNsVPa029147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759016AbXGaXyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     NOMMU: Fix SYSV IPC SHM
has been removed from the -mm tree.  Its filename was
     nommu-fix-sysv-ipc-shm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NOMMU: Fix SYSV IPC SHM
From: David Howells <dhowells@redhat.com>

Fix the SYSV IPC SHM to work with the changes applied by the new fault handler
patches when CONFIG_MMU=n.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    7 ++++++-
 ipc/shm.c             |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~nommu-fix-sysv-ipc-shm fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-fix-sysv-ipc-shm
+++ a/fs/ramfs/file-nommu.c
@@ -295,5 +295,10 @@ unsigned long ramfs_nommu_get_unmapped_a
  */
 int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -ENOSYS;
+
+	file_accessed(file);
+	vma->vm_ops = &generic_file_vm_ops;
+	return 0;
 }
diff -puN ipc/shm.c~nommu-fix-sysv-ipc-shm ipc/shm.c
--- a/ipc/shm.c~nommu-fix-sysv-ipc-shm
+++ a/ipc/shm.c
@@ -268,7 +268,9 @@ static int shm_mmap(struct file * file, 
 	if (ret != 0)
 		return ret;
 	sfd->vm_ops = vma->vm_ops;
+#ifdef CONFIG_MMU
 	BUG_ON(!sfd->vm_ops->fault);
+#endif
 	vma->vm_ops = &shm_vm_ops;
 	shm_open(vma);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
changing-include-asm-generic-pgtableh-for-non-mmu.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
