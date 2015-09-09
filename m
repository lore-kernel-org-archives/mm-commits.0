From: akpm@linux-foundation.org
Subject: [merged]
 thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:43:27 -0700
Message-ID: <55f08bdf.edqNPVpPrTufwJbU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbIITn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: decrement refcount on huge zero page if it is split
has been removed from the -mm tree.  Its filename was
     thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: decrement refcount on huge zero page if it is split

The DAX code neglected to put the refcount on the huge zero page.
Also we must notify on splits.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-decrement-refcount-on-huge-zero-page-if-it-is-split mm/huge_memory.c
--- a/mm/huge_memory.c~thp-decrement-refcount-on-huge-zero-page-if-it-is-split
+++ a/mm/huge_memory.c
@@ -2978,7 +2978,9 @@ again:
 	if (unlikely(!pmd_trans_huge(*pmd)))
 		goto unlock;
 	if (vma_is_dax(vma)) {
-		pmdp_huge_clear_flush(vma, haddr, pmd);
+		pmd_t _pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+		if (is_huge_zero_pmd(_pmd))
+			put_huge_zero_page();
 	} else if (is_huge_zero_pmd(*pmd)) {
 		__split_huge_zero_page_pmd(vma, haddr, pmd);
 	} else {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

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
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

