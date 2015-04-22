From: akpm@linux-foundation.org
Subject: + mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch added to -mm
 tree
Date: Wed, 22 Apr 2015 15:14:05 -0700
Message-ID: <55381d2d.nkTPCr8ye59tjGF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbbDVWOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 18:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mprotect() behaviour on VM_LOCKED VMAs
has been added to the -mm tree.  Its filename is
     mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch

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
Subject: mm: fix mprotect() behaviour on VM_LOCKED VMAs

On mlock(2) we trigger COW on private writable VMA to avoid faults in
future.

mm/gup.c:
 840 long populate_vma_page_range(struct vm_area_struct *vma,
 841                 unsigned long start, unsigned long end, int *nonblocking)
 842 {
 ...
 855          * We want to touch writable mappings with a write fault in order
 856          * to break COW, except for shared mappings because these don't COW
 857          * and we would not want to dirty them for nothing.
 858          */
 859         if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 860                 gup_flags |= FOLL_WRITE;

But we miss this case when we make VM_LOCKED VMA writeable via
mprotect(2). The test case:

	#define _GNU_SOURCE
	#include <fcntl.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/resource.h>
	#include <sys/stat.h>
	#include <sys/time.h>
	#include <sys/types.h>

	#define PAGE_SIZE 4096

	int main(int argc, char **argv)
	{
		struct rusage usage;
		long before;
		char *p;
		int fd;

		/* Create a file and populate first page of page cache */
		fd = open("/tmp", O_TMPFILE | O_RDWR, S_IRUSR | S_IWUSR);
		write(fd, "1", 1);

		/* Create a *read-only* *private* mapping of the file */
		p = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);

		/*
		 * Since the mapping is read-only, mlock() will populate the mapping
		 * with PTEs pointing to page cache without triggering COW.
		 */
		mlock(p, PAGE_SIZE);

		/*
		 * Mapping became read-write, but it's still populated with PTEs
		 * pointing to page cache.
		 */
		mprotect(p, PAGE_SIZE, PROT_READ | PROT_WRITE);

		getrusage(RUSAGE_SELF, &usage);
		before = usage.ru_minflt;

		/* Trigger COW: fault in mlock()ed VMA. */
		*p = 1;

		getrusage(RUSAGE_SELF, &usage);
		printf("faults: %ld\n", usage.ru_minflt - before);

		return 0;
	}

	$ ./test
	faults: 1

Let's fix it by triggering populating of VMA in mprotect_fixup() on this
condition. We don't care about population error as we don't in other
similar cases i.e. mremap.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/mprotect.c~mm-fix-mprotect-behaviour-on-vm_locked-vmas mm/mprotect.c
--- a/mm/mprotect.c~mm-fix-mprotect-behaviour-on-vm_locked-vmas
+++ a/mm/mprotect.c
@@ -29,6 +29,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 /*
  * For a prot_numa update we only hold mmap_sem for read so there is a
  * potential race with faulting where a pmd was temporarily none. This
@@ -322,6 +324,15 @@ success:
 	change_protection(vma, start, end, vma->vm_page_prot,
 			  dirty_accountable, 0);
 
+	/*
+	 * Private VM_LOCKED VMA become writable: trigger COW to avoid major
+	 * fault on access.
+	 */
+	if ((oldflags & (VM_WRITE | VM_SHARED | VM_LOCKED)) == VM_LOCKED &&
+			(newflags & VM_WRITE)) {
+		populate_vma_page_range(vma, start, end, NULL);
+	}
+
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
 	perf_event_mmap(vma);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
linux-next.patch

