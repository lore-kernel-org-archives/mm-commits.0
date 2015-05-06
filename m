From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch
 removed from -mm tree
Date: Wed, 06 May 2015 11:58:13 -0700
Message-ID: <554a6445.68ppvWT8AUiHTq2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbEFS6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, ak@linux.intel.com, dnelson@redhat.com, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: call shake_page() when error hits thp tail page
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure: call shake_page() when error hits thp tail page

Currently memory_failure() calls shake_page() to sweep pages out from
pcplists only when the victim page is 4kB LRU page or thp head page.  But
we should do this for a thp tail page too.

Consider that a memory error hits a thp tail page whose head page is on a
pcplist when memory_failure() runs.  Then, the current kernel skips
shake_pages() part, so hwpoison_user_mappings() returns without calling
split_huge_page() nor try_to_unmap() because PageLRU of the thp head is
still cleared due to the skip of shake_page().

As a result, me_huge_page() runs for the thp, which is broken behavior.

One effect is a leak of the thp.  And another is to fail to isolate the
memory error, so later access to the error address causes another MCE,
which kills the processes which used the thp.

This patch fixes this problem by calling shake_page() for thp tail case.

Fixes: 385de35722c9 ("thp: allow a hwpoisoned head page to be put back to LRU")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Dean Nelson <dnelson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: <stable@vger.kernel.org>	[3.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page
+++ a/mm/memory-failure.c
@@ -1187,10 +1187,10 @@ int memory_failure(unsigned long pfn, in
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageHuge(p) && !PageTransTail(p)) {
-		if (!PageLRU(p))
-			shake_page(p, 0);
-		if (!PageLRU(p)) {
+	if (!PageHuge(p)) {
+		if (!PageLRU(hpage))
+			shake_page(hpage, 0);
+		if (!PageLRU(hpage)) {
 			/*
 			 * shake_page could have turned it free.
 			 */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
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

