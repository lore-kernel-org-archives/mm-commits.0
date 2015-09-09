From: akpm@linux-foundation.org
Subject: [merged] mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:42:46 -0700
Message-ID: <55f08bb6.jlzcb6gVQ3DUep8S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, luto@kernel.org, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: fix the wrong !vma->vm_file check in copy_vma()
has been removed from the -mm tree.  Its filename was
     mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mremap: fix the wrong !vma->vm_file check in copy_vma()

Test-case:

	#define _GNU_SOURCE
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

	void *get_unmapped_area(void)
	{
		void *p = mmap(0, PAGE_SIZE, PROT_NONE,
				MAP_PRIVATE|MAP_ANONYMOUS, -1,0);
		assert(p != MAP_FAILED);
		munmap(p, PAGE_SIZE);
		return p;
	}

	char save[2][PAGE_SIZE];

	int main(void)
	{
		void *vdso = find_vdso_vaddr();
		void *page[2];

		assert(vdso);
		memcpy(save, vdso, sizeof (save));
		// force another fault on the next check
		assert(madvise(vdso, 2 * PAGE_SIZE, MADV_DONTNEED) == 0);

		page[0] = mremap(vdso,
				PAGE_SIZE, PAGE_SIZE, MREMAP_FIXED | MREMAP_MAYMOVE,
				get_unmapped_area());
		page[1] = mremap(vdso + PAGE_SIZE,
				PAGE_SIZE, PAGE_SIZE, MREMAP_FIXED | MREMAP_MAYMOVE,
				get_unmapped_area());

		assert(page[0] != MAP_FAILED && page[1] != MAP_FAILED);
		printf("match: %d %d\n",
			!memcmp(save[0], page[0], PAGE_SIZE),
			!memcmp(save[1], page[1], PAGE_SIZE));

		return 0;
	}

fails without this patch. Before the previous commit it gets the wrong
page, now it segfaults (which is imho better).

This is because copy_vma() wrongly assumes that if vma->vm_file == NULL
is irrelevant until the first fault which will use do_anonymous_page().
This is obviously wrong for the special mapping.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma mm/mmap.c
--- a/mm/mmap.c~mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma
+++ a/mm/mmap.c
@@ -2918,7 +2918,7 @@ struct vm_area_struct *copy_vma(struct v
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
 	 */
-	if (unlikely(!vma->vm_file && !vma->anon_vma)) {
+	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
 		faulted_in_anon_vma = false;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

