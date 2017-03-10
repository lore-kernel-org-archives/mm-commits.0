From: akpm@linux-foundation.org
Subject: [patch 19/26] rmap: fix NULL-pointer dereference on THP
 munlocking
Date: Thu, 09 Mar 2017 16:17:20 -0800
Message-ID: <58c1f090.JY/w1F7E4bHagbWO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754556AbdCJARV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, aarcange@redhat.com

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
