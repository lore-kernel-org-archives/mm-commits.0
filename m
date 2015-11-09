From: akpm@linux-foundation.org
Subject: + mm-uninline-slowpath-of-page_mapcount.patch added to -mm tree
Date: Mon, 09 Nov 2015 13:20:50 -0800
Message-ID: <56410e32.JFOPACjqdK+96CaN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbKIVUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline slowpath of page_mapcount()
has been added to the -mm tree.  Its filename is
     mm-uninline-slowpath-of-page_mapcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uninline-slowpath-of-page_mapcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uninline-slowpath-of-page_mapcount.patch

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
Subject: mm: uninline slowpath of page_mapcount()

Let's move page_mapcount() part for compound page into mm/util.c.

make allyesconfig:

  text	   data	    bss	    dec	    hex	filename
188515051	153360535	85458720	427334306	19789aa2	vmlinux.o.before
188512917	153356439	85458720	427328076	1978824c	vmlinux.o.after

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 +++++---------
 mm/util.c          |   14 ++++++++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~mm-uninline-slowpath-of-page_mapcount include/linux/mm.h
--- a/include/linux/mm.h~mm-uninline-slowpath-of-page_mapcount
+++ a/include/linux/mm.h
@@ -418,19 +418,15 @@ static inline void page_mapcount_reset(s
 	atomic_set(&(page)->_mapcount, -1);
 }
 
+int __page_mapcount(struct page *page);
+
 static inline int page_mapcount(struct page *page)
 {
-	int ret;
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 
-	ret = atomic_read(&page->_mapcount) + 1;
-	if (PageCompound(page)) {
-		page = compound_head(page);
-		ret += atomic_read(compound_mapcount_ptr(page)) + 1;
-		if (PageDoubleMap(page))
-			ret--;
-	}
-	return ret;
+	if (unlikely(PageCompound(page)))
+		return __page_mapcount(page);
+	return atomic_read(&page->_mapcount) + 1;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN mm/util.c~mm-uninline-slowpath-of-page_mapcount mm/util.c
--- a/mm/util.c~mm-uninline-slowpath-of-page_mapcount
+++ a/mm/util.c
@@ -376,6 +376,20 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+/* Slow path of page_mapcount() for compound pages */
+int __page_mapcount(struct page *page)
+{
+	int ret;
+
+	page = compound_head(page);
+	ret = atomic_read(&page->_mapcount) + 1;
+	ret += atomic_read(compound_mapcount_ptr(page)) + 1;
+	if (PageDoubleMap(page))
+		ret--;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__page_mapcount);
+
 int overcommit_ratio_handler(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
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
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-uninline-slowpath-of-page_mapcount.patch

