From: akpm@linux-foundation.org
Subject: + mm-fix-regression-in-remap_file_pages-emulation.patch added to
 -mm tree
Date: Tue, 16 Feb 2016 12:58:32 -0800
Message-ID: <56c38d78.2vdcE6eljWbW/Tl5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbcBPU6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 15:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, notasas@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix regression in remap_file_pages() emulation
has been added to the -mm tree.  Its filename is
     mm-fix-regression-in-remap_file_pages-emulation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-regression-in-remap_file_pages-emulation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-regression-in-remap_file_pages-emulation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix regression in remap_file_pages() emulation

Grazvydas Ignotas has reported a regression in remap_file_pages()
emulation.

Testcase:
	#define _GNU_SOURCE
	#include <assert.h>
	#include <stdlib.h>
	#include <stdio.h>
	#include <sys/mman.h>

	#define SIZE    (4096 * 3)

	int main(int argc, char **argv)
	{
		unsigned long *p;
		long i;

		p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_ANONYMOUS, -1, 0);
		if (p == MAP_FAILED) {
			perror("mmap");
			return -1;
		}

		for (i = 0; i < SIZE / 4096; i++)
			p[i * 4096 / sizeof(*p)] = i;

		if (remap_file_pages(p, 4096, 0, 1, 0)) {
			perror("remap_file_pages");
			return -1;
		}

		if (remap_file_pages(p, 4096 * 2, 0, 1, 0)) {
			perror("remap_file_pages");
			return -1;
		}

		assert(p[0] == 1);

		munmap(p, SIZE);

		return 0;
	}

The second remap_file_pages() fails with -EINVAL.

The reason is that remap_file_pages() emulation assumes that the target
vma covers whole area we want to over map.  That assumption is broken by
first remap_file_pages() call: it split the area into two vma.

The solution is to check next adjacent vmas, if they map the same file
with the same flags.

Fixes: c8d78c1823f4 ("mm: replace remap_file_pages() syscall with emulation")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Grazvydas Ignotas <notasas@gmail.com>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mm-fix-regression-in-remap_file_pages-emulation mm/mmap.c
--- a/mm/mmap.c~mm-fix-regression-in-remap_file_pages-emulation
+++ a/mm/mmap.c
@@ -2664,12 +2664,29 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
-	if (start < vma->vm_start || start + size > vma->vm_end)
+	if (start < vma->vm_start)
 		goto out;
 
-	if (pgoff == linear_page_index(vma, start)) {
-		ret = 0;
-		goto out;
+	if (start + size > vma->vm_end) {
+		struct vm_area_struct *next;
+
+		for (next = vma->vm_next; next; next = next->vm_next) {
+			/* hole between vmas ? */
+			if (next->vm_start != next->vm_prev->vm_end)
+				goto out;
+
+			if (next->vm_file != vma->vm_file)
+				goto out;
+
+			if (next->vm_flags != vma->vm_flags)
+				goto out;
+
+			if (start + size <= next->vm_end)
+				break;
+		}
+
+		if (!next)
+			goto out;
 	}
 
 	prot |= vma->vm_flags & VM_READ ? PROT_READ : 0;
@@ -2679,9 +2696,16 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	flags &= MAP_NONBLOCK;
 	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
 	if (vma->vm_flags & VM_LOCKED) {
+		struct vm_area_struct *tmp;
 		flags |= MAP_LOCKED;
+
 		/* drop PG_Mlocked flag for over-mapped range */
-		munlock_vma_pages_range(vma, start, start + size);
+		for (tmp = vma; tmp->vm_start >= start + size;
+				tmp = tmp->vm_next) {
+			munlock_vma_pages_range(tmp,
+					max(tmp->vm_start, start),
+					min(tmp->vm_end, start + size));
+		}
 	}
 
 	file = get_file(vma->vm_file);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch
mm-fix-regression-in-remap_file_pages-emulation.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

