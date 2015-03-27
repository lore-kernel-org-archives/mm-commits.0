From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:45 -0700
Message-ID: <55159e8d.KXtnhdbbYgnOGy/2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbC0SQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, kazutomo.yoshii@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalk.c: prevent positive return value of walk_page_test() from being passed to callers
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/pagewalk.c: prevent positive return value of walk_page_test() from being passed to callers

walk_page_test() is purely pagewalk's internal stuff, and its positive
return values are not intended to be passed to the callers of pagewalk. 
However, in the current code if the last vma in the do-while loop in
walk_page_range() happens to return a positive value, it leaks outside
walk_page_range().  So the user visible effect is invalid/unexpected
return value (according to the reporter, mbind() causes it.)

This patch fixes it simply by reinitializing the return value after checked.

Another exposed interface, walk_page_vma(), already returns 0 for such
cases so no problem.

Fixes: fafaa4264eba ("pagewalk: improve vma handling")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kazutomo Yoshii <kazutomo.yoshii@gmail.com>
Reported-by: Kazutomo Yoshii <kazutomo.yoshii@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers
+++ a/mm/pagewalk.c
@@ -265,8 +265,15 @@ int walk_page_range(unsigned long start,
 			vma = vma->vm_next;
 
 			err = walk_page_test(start, next, walk);
-			if (err > 0)
+			if (err > 0) {
+				/*
+				 * positive return values are purely for
+				 * controlling the pagewalk, so should never
+				 * be passed to the callers.
+				 */
+				err = 0;
 				continue;
+			}
 			if (err < 0)
 				break;
 		}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
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

