From: akpm@linux-foundation.org
Subject: [merged] mm-page-writeback-check-before-clear-pagereclaim.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:31 -0700
Message-ID: <552fe893.4WOcX80bUkayagAi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbDPQqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: check-before-clear PageReclaim
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-check-before-clear-pagereclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/page-writeback: check-before-clear PageReclaim

With the page flag sanitization patchset, an invalid usage of
ClearPageReclaim() is detected in set_page_dirty().  This can be called
from __unmap_hugepage_range(), so let's check PageReclaim() before trying
to clear it to avoid the misuse.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writeback-check-before-clear-pagereclaim mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writeback-check-before-clear-pagereclaim
+++ a/mm/page-writeback.c
@@ -2228,7 +2228,8 @@ int set_page_dirty(struct page *page)
 		 * it will confuse readahead and make it restart the size rampup
 		 * process. But it's a trivial problem.
 		 */
-		ClearPageReclaim(page);
+		if (PageReclaim(page))
+			ClearPageReclaim(page);
 #ifdef CONFIG_BLOCK
 		if (!spd)
 			spd = __set_page_dirty_buffers;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
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
do_shared_fault-check-that-mmap_sem-is-held.patch

