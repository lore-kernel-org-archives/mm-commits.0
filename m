From: akpm@linux-foundation.org
Subject: + mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch added
 to -mm tree
Date: Fri, 10 Jul 2015 14:52:34 -0700
Message-ID: <55a03ea2.EgJfkjm9VSy7yx2J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbGJVwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, luto@kernel.org, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: fix the wrong !vma->vm_file check in copy_vma()
has been added to the -mm tree.  Its filename is
     mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
mm-cleaning-per-architecture-mm-hook-header-files.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch

