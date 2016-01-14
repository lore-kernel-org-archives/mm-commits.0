From: akpm@linux-foundation.org
Subject: [folded-merged]
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:31:37 -0800
Message-ID: <569821c9.qanvR3ZFbx9Gd2vG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbcANWbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:31:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: add documentation for policies
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch

This patch was dropped because it was folded into page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: add documentation for policies

The patch adds description for page flags policies.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix
+++ a/include/linux/page-flags.h
@@ -154,7 +154,23 @@ static inline int PageCompound(struct pa
 	return test_bit(PG_head, &page->flags) || PageTail(page);
 }
 
-/* Page flags policies wrt compound pages */
+/*
+ * Page flags policies wrt compound pages
+ *
+ * PF_ANY:
+ *     the page flag is relevant for small, head and tail pages.
+ *
+ * PF_HEAD:
+ *     for compound page all operations related to the page flag applied to
+ *     head page.
+ *
+ * PF_NO_TAIL:
+ *     modifications of the page flag must be done on small or head pages,
+ *     checks can be done on tail pages too.
+ *
+ * PF_NO_COMPOUND:
+ *     the page flag is not relevant for compound pages.
+ */
 #define PF_ANY(page, enforce)	page
 #define PF_HEAD(page, enforce)	compound_head(page)
 #define PF_NO_TAIL(page, enforce) ({					\
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
thp-reintroduce-split_huge_page-fix-4.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
migrate_pages-try-to-split-pages-on-queuing-fix.patch
thp-introduce-deferred_split_huge_page.patch
thp-introduce-deferred_split_huge_page-fix.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
thp-allow-mlocked-thp-again-fix.patch
thp-allow-mlocked-thp-again-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch

