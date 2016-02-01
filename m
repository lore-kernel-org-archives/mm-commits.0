From: akpm@linux-foundation.org
Subject: + mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page.patch added to
 -mm tree
Date: Mon, 01 Feb 2016 13:23:20 -0800
Message-ID: <56afccc8.57UBNR5Wg+LjjaE3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcBAVXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 16:23:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dvyukov@google.com, hannes@cmpxchg.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix bogus VM_BUG_ON_PAGE() in isolate_lru_page()
has been added to the -mm tree.  Its filename is
     mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page.patch

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
Subject: mm: fix bogus VM_BUG_ON_PAGE() in isolate_lru_page()

We don't care if there's a tail pages which is not on LRU. We are not
going to isolate them anyway.

Testcase:

	#include <fcntl.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <sys/mman.h>
	#include <numaif.h>

	#define SIZE 0x2000

	int foo;

	int main()
	{
		int fd;
		char *p;
		unsigned long mask = 2;

		fd = open("/dev/sg0", O_RDWR);
		p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		/* Faultin pages */
		foo = p[0] + p[0x1000];
		mbind(p, SIZE, MPOL_BIND, &mask, 4, MPOL_MF_MOVE | MPOL_MF_STRICT);
		return 0;
	}

MPOL_MF_STRICT makes queue_pages_test_walk() ignore !vma_megratable()
and we try to queue such pages for migration. It's good question why we
ignore !vma_megratable() for MPOL_MF_STRICT, but it's subject for a
separate patch.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: bb5b8589767a ("mm: make sure isolate_lru_page() is never called for tail page"
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page
+++ a/mm/vmscan.c
@@ -1443,7 +1443,7 @@ int isolate_lru_page(struct page *page)
 	int ret = -EBUSY;
 
 	VM_BUG_ON_PAGE(!page_count(page), page);
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageLRU(page) && PageTail(page), page);
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
mm-fix-bogus-vm_bug_on_page-in-isolate_lru_page.patch
mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

