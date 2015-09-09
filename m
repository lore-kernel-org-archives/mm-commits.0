From: akpm@linux-foundation.org
Subject: [merged]
 mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:42:43 -0700
Message-ID: <55f08bb3.jAq6RjyMBWpDzTCY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, luto@kernel.org, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix the usage of ->vm_pgoff in special_mapping paths
has been removed from the -mm tree.  Its filename was
     mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mmap: fix the usage of ->vm_pgoff in special_mapping paths

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/mman.h>
	#include <assert.h>

	void *find_vdso_vaddr(void)
	{
		FILE *perl;
		char buf[32] = {};

		perl = popen("perl -e 'open STDIN,qq|/proc/@{[getppid]}/maps|;"
				"/^(.*?)-.*vdso/ && print hex $1 while <>'", "r");
		fread(buf, sizeof(buf), 1, perl);
		fclose(perl);

		return (void *)atol(buf);
	}

	#define PAGE_SIZE	4096

	int main(void)
	{
		void *vdso = find_vdso_vaddr();
		assert(vdso);

		// of course they should differ, and they do so far
		printf("vdso pages differ: %d\n",
			!!memcmp(vdso, vdso + PAGE_SIZE, PAGE_SIZE));

		// split into 2 vma's
		assert(mprotect(vdso, PAGE_SIZE, PROT_READ) == 0);

		// force another fault on the next check
		assert(madvise(vdso, 2 * PAGE_SIZE, MADV_DONTNEED) == 0);

		// now they no longer differ, the 2nd vm_pgoff is wrong
		printf("vdso pages differ: %d\n",
			!!memcmp(vdso, vdso + PAGE_SIZE, PAGE_SIZE));

		return 0;
	}

Output:

	vdso pages differ: 1
	vdso pages differ: 0

This is because split_vma() correctly updates ->vm_pgoff, but the logic
in insert_vm_struct() and special_mapping_fault() is absolutely broken,
so the fault at vdso + PAGE_SIZE return the 1st page. The same happens
if you simply unmap the 1st page.

special_mapping_fault() does:

	pgoff = vmf->pgoff - vma->vm_pgoff;

and this is _only_ correct if vma->vm_start mmaps the first page from
->vm_private_data array.

vdso or any other user of install_special_mapping() is not anonymous,
it has the "backing storage" even if it is just the array of pages.
So we actually need to make vm_pgoff work as an offset in this array.

Note: this also allows to fix another problem: currently gdb can't access
"[vvar]" memory because in this case special_mapping_fault() doesn't work.
Now that we can use ->vm_pgoff we can implement ->access() and fix this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/mmap.c~mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths mm/mmap.c
--- a/mm/mmap.c~mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths
+++ a/mm/mmap.c
@@ -2884,7 +2884,7 @@ int insert_vm_struct(struct mm_struct *m
 	 * using the existing file pgoff checks and manipulations.
 	 * Similarly in do_mmap_pgoff and in do_brk.
 	 */
-	if (!vma->vm_file) {
+	if (vma_is_anonymous(vma)) {
 		BUG_ON(vma->anon_vma);
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
@@ -3027,21 +3027,13 @@ static int special_mapping_fault(struct
 	pgoff_t pgoff;
 	struct page **pages;
 
-	/*
-	 * special mappings have no vm_file, and in that case, the mm
-	 * uses vm_pgoff internally. So we have to subtract it from here.
-	 * We are allowed to do this because we are the mm; do not copy
-	 * this code into drivers!
-	 */
-	pgoff = vmf->pgoff - vma->vm_pgoff;
