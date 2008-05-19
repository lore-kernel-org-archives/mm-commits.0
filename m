From: akpm@linux-foundation.org
Subject: + access_process_vm-device-memory-infrastructure-fix.patch added to -mm tree
Date: Mon, 19 May 2008 14:38:28 -0700
Message-ID: <200805192138.m4JLcSwo021796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756273AbYESVj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, a.p.zijlstra@chello.nl


The patch titled
     Add documentation for the vm_ops->access function.
has been added to the -mm tree.  Its filename is
     access_process_vm-device-memory-infrastructure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

