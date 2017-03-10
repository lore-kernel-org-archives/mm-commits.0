From: akpm@linux-foundation.org
Subject: [merged]
 rmap-fix-null-pointer-dereference-on-thp-munlocking.patch removed from -mm
 tree
Date: Fri, 10 Mar 2017 13:43:23 -0800
Message-ID: <58c31dfb.vgxKUqlIvFMZ6c5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38082 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: fix NULL-pointer dereference on THP munlocking
has been removed from the -mm tree.  Its filename was
     rmap-fix-null-pointer-dereference-on-thp-munlocking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: fix NULL-pointer dereference on THP munlocking

The following test case triggers NULL-pointer derefernce in
try_to_unmap_one():

	#include <fcntl.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/mman.h>

	int main(int argc, char *argv[])
	{
		int fd;

		system("mount -t tmpfs -o huge=always none /mnt");
		fd = open("/mnt/test", O_CREAT | O_RDWR);
		ftruncate(fd, 2UL << 20);
		mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_FIXED | MAP_LOCKED, fd, 0);
		mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_LOCKED, fd, 0);
		munlockall();
		return 0;
	}

Apparently, there's a case when we call try_to_unmap() on huge PMDs:
it's TTU_MUNLOCK.

Let's handle this case correctly.

Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Link: http://lkml.kernel.org/r/20170302151159.30592-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/rmap.c~rmap-fix-null-pointer-dereference-on-thp-munlocking mm/rmap.c
--- a/mm/rmap.c~rmap-fix-null-pointer-dereference-on-thp-munlocking
+++ a/mm/rmap.c
@@ -1316,12 +1316,6 @@ static int try_to_unmap_one(struct page
 	}
 
 	while (page_vma_mapped_walk(&pvmw)) {
-		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
-		address = pvmw.address;
-
-		/* Unexpected PMD-mapped THP? */
-		VM_BUG_ON_PAGE(!pvmw.pte, page);
-
 		/*
 		 * If the page is mlock()d, we cannot swap it out.
 		 * If it's recently referenced (perhaps page_referenced
@@ -1345,6 +1339,13 @@ static int try_to_unmap_one(struct page
 				continue;
 		}
 
+		/* Unexpected PMD-mapped THP? */
+		VM_BUG_ON_PAGE(!pvmw.pte, page);
+
+		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
+		address = pvmw.address;
+
+
 		if (!(flags & TTU_IGNORE_ACCESS)) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
mm-drop-unused-pmdp_huge_get_and_clear_notify.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-madv_free-race-fix.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

