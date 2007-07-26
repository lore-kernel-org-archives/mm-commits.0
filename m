From: akpm@linux-foundation.org
Subject: + nommu-fix-sysv-ipc-shm.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:15:05 -0700
Message-ID: <200707261915.l6QJF58e016379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928AbXGZTPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     NOMMU: Fix SYSV IPC SHM
has been added to the -mm tree.  Its filename is
     nommu-fix-sysv-ipc-shm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nommu-fix-sysv-ipc-shm.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
afs-fix-file-locking.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
