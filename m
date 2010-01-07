From: akpm@linux-foundation.org
Subject: [merged] nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:10:25 -0800
Message-ID: <201001072110.o07LAPEC017670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620Ab0AGVLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:11:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, david_mccullough@mcafee.com, dhowells@redhat.com, gerg@uclinux.org, jie.zhang@analog.com, lethal@linux-sh.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     nommu: avoid duplicate icache flushes of shared maps
has been removed from the -mm tree.  Its filename was
     nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: avoid duplicate icache flushes of shared maps
From: Mike Frysinger <vapier.adi@gmail.com>

When working with FDPIC, there are many shared mappings of read-only code
regions between applications (the C library, applet packages like busybox,
etc.), but the current do_mmap_pgoff() function will issue an icache flush
whenever a VMA is added to an MM instead of only doing it when the map is
initially created.

The flush can instead be done when a region is first mmapped PROT_EXEC. 
Note that we may not rely on the first mapping of a region being
executable - it's possible for it to be PROT_READ only, so we have to
remember whether we've flushed the region or not, and then flush the
entire region when a bit of it is made executable.

However, this also affects the brk area.  That will no longer be
executable.  We can mprotect() it to PROT_EXEC on MPU-mode kernels, but
for NOMMU mode kernels, when it increases the brk allocation, making
sys_brk() flush the extra from the icache should suffice.  The brk area
probably isn't used by NOMMU programs since the brk area can only use up
the leavings from the stack allocation, where the stack allocation is
larger than requested.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Jie Zhang <jie.zhang@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David McCullough <david_mccullough@mcafee.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 mm/nommu.c               |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/mm_types.h~nommu-avoiding-duplicate-icache-flushes-of-shared-maps include/linux/mm_types.h
--- a/include/linux/mm_types.h~nommu-avoiding-duplicate-icache-flushes-of-shared-maps
+++ a/include/linux/mm_types.h
@@ -123,6 +123,8 @@ struct vm_region {
 	struct file	*vm_file;	/* the backing file or NULL */
 
 	atomic_t	vm_usage;	/* region usage count */
+	bool		vm_icache_flushed : 1; /* true if the icache has been flushed for
+						* this region */
 };
 
 /*
diff -puN mm/nommu.c~nommu-avoiding-duplicate-icache-flushes-of-shared-maps mm/nommu.c
--- a/mm/nommu.c~nommu-avoiding-duplicate-icache-flushes-of-shared-maps
+++ a/mm/nommu.c
@@ -432,6 +432,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	/*
 	 * Ok, looks good - let it rip.
 	 */
+	flush_icache_range(mm->brk, brk);
 	return mm->brk = brk;
 }
 
@@ -1353,10 +1354,14 @@ unsigned long do_mmap_pgoff(struct file 
 share:
 	add_vma_to_mm(current->mm, vma);
 
-	up_write(&nommu_region_sem);
+	/* we flush the region from the icache only when the first executable
+	 * mapping of it is made  */
+	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
+		flush_icache_range(region->vm_start, region->vm_end);
+		region->vm_icache_flushed = true;
+	}
 
-	if (prot & PROT_EXEC)
-		flush_icache_range(result, result + len);
+	up_write(&nommu_region_sem);
 
 	kleave(" = %lx", result);
 	return result;
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch

