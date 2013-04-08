From: akpm@linux-foundation.org
Subject: [merged] revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:18:01 -0700
Message-ID: <20130408191801.88D0631C24B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:60256 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741Ab3DHTSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:18:05 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1549451iad.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:18:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, hughd@google.com, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: introduce VM_POPULATE flag to better deal with racy userspace programs"
has been removed from the -mm tree.  Its filename was
     revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: Revert "mm: introduce VM_POPULATE flag to better deal with racy userspace programs"

This reverts commit 1869305009857 ("mm: introduce VM_POPULATE flag to
better deal with racy userspace programs").

VM_POPULATE only has any effect when userspace plays racy games with vmas
by trying to unmap and remap memory regions that mmap or mlock are
operating on.

Also, the only effect of VM_POPULATE when userspace plays such games is
that it avoids populating new memory regions that get remapped into the
address range that was being operated on by the original mmap or mlock
calls.

Let's remove VM_POPULATE as there isn't any strong argument to mandate a
new vm_flag.

Proposed by Hugh Dickins.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    1 -
 include/linux/mman.h |    4 +---
 mm/fremap.c          |   12 ++----------
 mm/mlock.c           |   11 +++++------
 mm/mmap.c            |    4 +++-
 5 files changed, 11 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs include/linux/mm.h
--- a/include/linux/mm.h~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/include/linux/mm.h
@@ -87,7 +87,6 @@ extern unsigned int kobjsize(const void
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
-#define VM_POPULATE     0x00001000
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
diff -puN include/linux/mman.h~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs include/linux/mman.h
--- a/include/linux/mman.h~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/include/linux/mman.h
@@ -79,8 +79,6 @@ calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
-	       ((flags & MAP_LOCKED) ? (VM_LOCKED | VM_POPULATE) : 0) |
-	       (((flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE) ?
-							VM_POPULATE : 0);
+	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
 #endif /* _LINUX_MMAN_H */
diff -puN mm/fremap.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/fremap.c
--- a/mm/fremap.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/fremap.c
@@ -204,10 +204,8 @@ get_write_lock:
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
 
-			vm_flags = vma->vm_flags;
-			if (!(flags & MAP_NONBLOCK))
-				vm_flags |= VM_POPULATE;
-			addr = mmap_region(file, start, size, vm_flags, pgoff);
+			addr = mmap_region(file, start, size,
+					vma->vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
@@ -226,12 +224,6 @@ get_write_lock:
 		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
-	if (!(flags & MAP_NONBLOCK) && !(vma->vm_flags & VM_POPULATE)) {
-		if (!has_write_lock)
-			goto get_write_lock;
-		vma->vm_flags |= VM_POPULATE;
-	}
-
 	if (vma->vm_flags & VM_LOCKED) {
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
diff -puN mm/mlock.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/mlock.c
--- a/mm/mlock.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/mlock.c
@@ -358,7 +358,7 @@ static int do_mlock(unsigned long start,
 
 		newflags = vma->vm_flags & ~VM_LOCKED;
 		if (on)
-			newflags |= VM_LOCKED | VM_POPULATE;
+			newflags |= VM_LOCKED;
 
 		tmp = vma->vm_end;
 		if (tmp > end)
@@ -418,8 +418,7 @@ int __mm_populate(unsigned long start, u
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP | VM_POPULATE)) !=
-		    VM_POPULATE)
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -492,9 +491,9 @@ static int do_mlockall(int flags)
 	struct vm_area_struct * vma, * prev = NULL;
 
 	if (flags & MCL_FUTURE)
-		current->mm->def_flags |= VM_LOCKED | VM_POPULATE;
+		current->mm->def_flags |= VM_LOCKED;
 	else
-		current->mm->def_flags &= ~(VM_LOCKED | VM_POPULATE);
+		current->mm->def_flags &= ~VM_LOCKED;
 	if (flags == MCL_FUTURE)
 		goto out;
 
@@ -503,7 +502,7 @@ static int do_mlockall(int flags)
 
 		newflags = vma->vm_flags & ~VM_LOCKED;
 		if (flags & MCL_CURRENT)
-			newflags |= VM_LOCKED | VM_POPULATE;
+			newflags |= VM_LOCKED;
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
diff -puN mm/mmap.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/mmap.c
--- a/mm/mmap.c~revert-mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/mmap.c
@@ -1306,7 +1306,9 @@ unsigned long do_mmap_pgoff(struct file
 	}
 
 	addr = mmap_region(file, addr, len, vm_flags, pgoff);
-	if (!IS_ERR_VALUE(addr) && (vm_flags & VM_POPULATE))
+	if (!IS_ERR_VALUE(addr) &&
+	    ((vm_flags & VM_LOCKED) ||
+	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
 		*populate = len;
 	return addr;
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-remove-free_area_cache.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix.patch
mutex-subsystem-synchro-test-module.patch

