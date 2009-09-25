From: akpm@linux-foundation.org
Subject: [merged] nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:29 -0700
Message-ID: <200909251953.n8PJrT1k003055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZIYTzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, graff.yang@gmail.com, lethal@linux-sh.org, mel@csn.ul.ie, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nommu: fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
has been removed from the -mm tree.  Its filename was
     nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
From: David Howells <dhowells@redhat.com>

Fix MAP_PRIVATE mmap() of files and devices where the data in the backing
store might be mapped directly.  Use the BDI_CAP_MAP_DIRECT capability
flag to govern whether or not we should be trying to map a file directly. 
This can be used to determine whether or not a region has been filled in
at the point where we call do_mmap_shared() or do_mmap_private().

The BDI_CAP_MAP_DIRECT capability flag is cleared by
validate_mmap_request() if there's any reason we can't use it.  It's also
cleared in do_mmap_pgoff() if f_op->get_unmapped_area() fails.

Without this fix, attempting to run a program from a RomFS image on a
non-mappable MTD partition results in a BUG as the kernel attempts XIP,
and this can be caught in gdb:

Program received signal SIGABRT, Aborted.
0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
(gdb) bt
#0  0xc005dce8 in add_nommu_region (region=<value optimized out>) at mm/nommu.c:547
#1  0xc005f168 in do_mmap_pgoff (file=0xc31a6620, addr=<value optimized out>, len=3808, prot=3, flags=6146, pgoff=0) at mm/nommu.c:1373
#2  0xc00a96b8 in elf_fdpic_map_file (params=0xc33fbbec, file=0xc31a6620, mm=0xc31bef60, what=0xc0213144 "executable") at mm.h:1145
#3  0xc00aa8b4 in load_elf_fdpic_binary (bprm=0xc316cb00, regs=<value optimized out>) at fs/binfmt_elf_fdpic.c:343
#4  0xc006b588 in search_binary_handler (bprm=0x6, regs=0xc33fbce0) at fs/exec.c:1234
#5  0xc006c648 in do_execve (filename=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460, regs=0xc33fbce0) at fs/exec.c:1356
#6  0xc0008cf0 in sys_execve (name=<value optimized out>, argv=0xc3ad14cc, envp=0xc3ad1460) at arch/frv/kernel/process.c:263
#7  0xc00075dc in __syscall_call () at arch/frv/kernel/entry.S:897

Note that this fix does the following commit differently:

	commit a190887b58c32d19c2eee007c5eb8faa970a69ba
	Author: David Howells <dhowells@redhat.com>
	Date:   Sat Sep 5 11:17:07 2009 -0700
	nommu: fix error handling in do_mmap_pgoff()

Reported-by: Graff Yang <graff.yang@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN mm/nommu.c~nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly mm/nommu.c
--- a/mm/nommu.c~nommu-fix-map_private-mmap-of-objects-where-the-data-can-be-mapped-directly
+++ a/mm/nommu.c
@@ -1034,7 +1034,7 @@ static int do_mmap_shared_file(struct vm
 	ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
 	if (ret == 0) {
 		vma->vm_region->vm_top = vma->vm_region->vm_end;
-		return ret;
+		return 0;
 	}
 	if (ret != -ENOSYS)
 		return ret;
@@ -1051,7 +1051,8 @@ static int do_mmap_shared_file(struct vm
  */
 static int do_mmap_private(struct vm_area_struct *vma,
 			   struct vm_region *region,
-			   unsigned long len)
+			   unsigned long len,
+			   unsigned long capabilities)
 {
 	struct page *pages;
 	unsigned long total, point, n, rlen;
@@ -1062,13 +1063,13 @@ static int do_mmap_private(struct vm_are
 	 * shared mappings on devices or memory
 	 * - VM_MAYSHARE will be set if it may attempt to share
 	 */
-	if (vma->vm_file) {
+	if (capabilities & BDI_CAP_MAP_DIRECT) {
 		ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
 		if (ret == 0) {
 			/* shouldn't return success if we're not sharing */
 			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
 			vma->vm_region->vm_top = vma->vm_region->vm_end;
-			return ret;
+			return 0;
 		}
 		if (ret != -ENOSYS)
 			return ret;
@@ -1306,7 +1307,7 @@ unsigned long do_mmap_pgoff(struct file 
 		 * - this is the hook for quasi-memory character devices to
 		 *   tell us the location of a shared mapping
 		 */
-		if (file && file->f_op->get_unmapped_area) {
+		if (capabilities & BDI_CAP_MAP_DIRECT) {
 			addr = file->f_op->get_unmapped_area(file, addr, len,
 							     pgoff, flags);
 			if (IS_ERR((void *) addr)) {
@@ -1330,15 +1331,17 @@ unsigned long do_mmap_pgoff(struct file 
 	}
 
 	vma->vm_region = region;
-	add_nommu_region(region);
 
-	/* set up the mapping */
+	/* set up the mapping
+	 * - the region is filled in if BDI_CAP_MAP_DIRECT is still set
+	 */
 	if (file && vma->vm_flags & VM_SHARED)
 		ret = do_mmap_shared_file(vma);
 	else
-		ret = do_mmap_private(vma, region, len);
+		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
-		goto error_put_region;
+		goto error_just_free;
+	add_nommu_region(region);
 
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
@@ -1356,19 +1359,6 @@ share:
 	kleave(" = %lx", result);
 	return result;
 
-error_put_region:
-	__put_nommu_region(region);
-	if (vma) {
-		if (vma->vm_file) {
-			fput(vma->vm_file);
-			if (vma->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(vma->vm_mm);
-		}
-		kmem_cache_free(vm_area_cachep, vma);
-	}
-	kleave(" = %d [pr]", ret);
-	return ret;
