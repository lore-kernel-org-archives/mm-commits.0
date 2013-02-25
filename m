From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:49:26 -0800
Message-ID: <20130225204926.BE40F31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40123 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3BYUt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:28 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so157761yen.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, gregungerer@westnet.com.au, luto@amacapital.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_POPULATE flag to better deal with racy userspace programs
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: introduce VM_POPULATE flag to better deal with racy userspace programs

The vm_populate() code populates user mappings without constantly
holding the mmap_sem. This makes it susceptible to racy userspace
programs: the user mappings may change while vm_populate() is running,
and in this case vm_populate() may end up populating the new mapping
instead of the old one.

In order to reduce the possibility of userspace getting surprised by
this behavior, this change introduces the VM_POPULATE vma flag which
gets set on vmas we want vm_populate() to work on. This way
vm_populate() may still end up populating the new mapping after such a
race, but only if the new mapping is also one that the user has
requested (using MAP_SHARED, MAP_LOCKED or mlock) to be populated.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Ungerer <gregungerer@westnet.com.au>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    1 +
 include/linux/mman.h |    4 +++-
 mm/fremap.c          |   12 ++++++++++--
 mm/mlock.c           |   19 ++++++++++---------
 mm/mmap.c            |    4 +---
 5 files changed, 25 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/include/linux/mm.h
@@ -87,6 +87,7 @@ extern unsigned int kobjsize(const void 
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
+#define VM_POPULATE     0x00001000
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
diff -puN include/linux/mman.h~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs include/linux/mman.h
--- a/include/linux/mman.h~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/include/linux/mman.h
@@ -79,6 +79,8 @@ calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
-	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
+	       ((flags & MAP_LOCKED) ? (VM_LOCKED | VM_POPULATE) : 0) |
+	       (((flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE) ?
+							VM_POPULATE : 0);
 }
 #endif /* _LINUX_MMAN_H */
diff -puN mm/fremap.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/fremap.c
--- a/mm/fremap.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/fremap.c
@@ -204,8 +204,10 @@ get_write_lock:
 			unsigned long addr;
 			struct file *file = get_file(vma->vm_file);
 
-			addr = mmap_region(file, start, size,
-					vma->vm_flags, pgoff);
+			vm_flags = vma->vm_flags;
+			if (!(flags & MAP_NONBLOCK))
+				vm_flags |= VM_POPULATE;
+			addr = mmap_region(file, start, size, vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
@@ -224,6 +226,12 @@ get_write_lock:
 		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
+	if (!(flags & MAP_NONBLOCK) && !(vma->vm_flags & VM_POPULATE)) {
+		if (!has_write_lock)
+			goto get_write_lock;
+		vma->vm_flags |= VM_POPULATE;
+	}
+
 	if (vma->vm_flags & VM_LOCKED) {
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
diff -puN mm/mlock.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/mlock.c
--- a/mm/mlock.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/mlock.c
@@ -340,9 +340,9 @@ static int do_mlock(unsigned long start,
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
-		newflags = vma->vm_flags | VM_LOCKED;
-		if (!on)
-			newflags &= ~VM_LOCKED;
+		newflags = vma->vm_flags & ~VM_LOCKED;
+		if (on)
+			newflags |= VM_LOCKED | VM_POPULATE;
 
 		tmp = vma->vm_end;
 		if (tmp > end)
@@ -402,7 +402,8 @@ int __mm_populate(unsigned long start, u
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if ((vma->vm_flags & (VM_IO | VM_PFNMAP | VM_POPULATE)) !=
+		    VM_POPULATE)
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -475,18 +476,18 @@ static int do_mlockall(int flags)
 	struct vm_area_struct * vma, * prev = NULL;
 
 	if (flags & MCL_FUTURE)
-		current->mm->def_flags |= VM_LOCKED;
+		current->mm->def_flags |= VM_LOCKED | VM_POPULATE;
 	else
-		current->mm->def_flags &= ~VM_LOCKED;
+		current->mm->def_flags &= ~(VM_LOCKED | VM_POPULATE);
 	if (flags == MCL_FUTURE)
 		goto out;
 
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags | VM_LOCKED;
-		if (!(flags & MCL_CURRENT))
-			newflags &= ~VM_LOCKED;
+		newflags = vma->vm_flags & ~VM_LOCKED;
+		if (flags & MCL_CURRENT)
+			newflags |= VM_LOCKED | VM_POPULATE;
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
diff -puN mm/mmap.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs mm/mmap.c
--- a/mm/mmap.c~mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs
+++ a/mm/mmap.c
@@ -1306,9 +1306,7 @@ unsigned long do_mmap_pgoff(struct file 
 	}
 
 	addr = mmap_region(file, addr, len, vm_flags, pgoff);
-	if (!IS_ERR_VALUE(addr) &&
-	    ((vm_flags & VM_LOCKED) ||
-	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
+	if (!IS_ERR_VALUE(addr) && (vm_flags & VM_POPULATE))
 		*populate = true;
 	return addr;
 }
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remove-free_area_cache.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

