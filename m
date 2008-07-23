From: akpm@linux-foundation.org
Subject: - access_process_vm-device-memory-infrastructure-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:54:54 -0700
Message-ID: <200807232307.m6NN7VN2016716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYGWXHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     Add documentation for the vm_ops->access function.
has been removed from the -mm tree.  Its filename was
     access_process_vm-device-memory-infrastructure-fix.patch

This patch was dropped because it was folded into access_process_vm-device-memory-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add documentation for the vm_ops->access function.
From: Rik van Riel <riel@redhat.com>

Add documentation for the vm_ops->access function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/filesystems/Locking~access_process_vm-device-memory-infrastructure-fix Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~access_process_vm-device-memory-infrastructure-fix
+++ a/Documentation/filesystems/Locking
@@ -510,6 +510,7 @@ prototypes:
 	void (*close)(struct vm_area_struct*);
 	int (*fault)(struct vm_area_struct*, struct vm_fault *);
 	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
+	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
 		BKL	mmap_sem	PageLocked(page)
@@ -517,6 +518,7 @@ open:		no	yes
 close:		no	yes
 fault:		no	yes
 page_mkwrite:	no	yes		no
+access:		no	yes
 
 	->page_mkwrite() is called when a previously read-only page is
 about to become writeable. The file system is responsible for
@@ -525,6 +527,11 @@ taking to lock out truncate, the page ra
 within i_size. The page mapping should also be checked that it is not
 NULL.
 
+	->access() is called when get_user_pages() fails in
+acces_process_vm(), typically used to debug a process through
+/proc/pid/mem or ptrace.  This function is needed only for
+VM_IO | VM_PFNMAP VMAs.
+
 ================================================================================
 			Dubious stuff
 
_

Patches currently in -mm which might be from riel@redhat.com are

access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch

