From: akpm@linux-foundation.org
Subject: + mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch added
 to -mm tree
Date: Tue, 02 Feb 2016 14:26:15 -0800
Message-ID: <56b12d07.P/M1zPgYVnHsmz0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbcBBW0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:26:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dvyukov@google.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: downgrade VM_BUG in isolate_lru_page() to warning
has been added to the -mm tree.  Its filename is
     mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch

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
Subject: mm: downgrade VM_BUG in isolate_lru_page() to warning

Calling isolate_lru_page() is wrong and shouldn't happen, but it not
nessesary fatal: the page just will not be isolated if it's not on LRU.

Let's downgrade the VM_BUG_ON_PAGE() to WARN_RATELIMIT().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-downgrade-vm_bug-in-isolate_lru_page-to-warning mm/vmscan.c
--- a/mm/vmscan.c~mm-downgrade-vm_bug-in-isolate_lru_page-to-warning
+++ a/mm/vmscan.c
@@ -1443,7 +1443,7 @@ int isolate_lru_page(struct page *page)
 	int ret = -EBUSY;
 
 	VM_BUG_ON_PAGE(!page_count(page), page);
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
 
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue-fix.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
drivers-scsi-sgc-mark-vma-as-vm_io-to-prevent-migration.patch
mempolicy-do-not-try-to-queue-pages-from-vma_migratable.patch
mm-downgrade-vm_bug-in-isolate_lru_page-to-warning.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

