From: akpm@linux-foundation.org
Subject: [folded-merged]
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:31:40 -0800
Message-ID: <569821cc.suJq4A9Y65GfY39w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbcANWbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: hide PF_* validation check under separate config option
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch

This patch was dropped because it was folded into page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: hide PF_* validation check under separate config option

VM_BUG_ONs in PF_NO_TAIL() and PF_NO_COMPOUND() add 4+ KiB to
mm/build-in.o for DEBUG_VM kernel.

Let's hide them under new config option -- CONFIG_DEBUG_VM_PGFLAGS.
With the option enabled VM_BUG_ON_PGFLAGS() is equal to VM_BUG_ON_PAGE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h    |    6 ++++++
 include/linux/page-flags.h |    6 ++----
 lib/Kconfig.debug          |    8 ++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/mmdebug.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/include/linux/mmdebug.h
@@ -56,4 +56,10 @@ void dump_mm(const struct mm_struct *mm)
 #define VIRTUAL_BUG_ON(cond) do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_VM_PGFLAGS
+#define VM_BUG_ON_PGFLAGS(cond, page) VM_BUG_ON_PAGE(cond, page)
+#else
+#define VM_BUG_ON_PGFLAGS(cond, page) BUILD_BUG_ON_INVALID(cond)
+#endif
+
 #endif
diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/include/linux/page-flags.h
@@ -174,12 +174,10 @@ static inline int PageCompound(struct pa
 #define PF_ANY(page, enforce)	page
 #define PF_HEAD(page, enforce)	compound_head(page)
 #define PF_NO_TAIL(page, enforce) ({					\
-		if (enforce)						\
-			VM_BUG_ON_PAGE(PageTail(page), page);		\
+		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
 		compound_head(page);})
 #define PF_NO_COMPOUND(page, enforce) ({					\
-		if (enforce)						\
-			VM_BUG_ON_PAGE(PageCompound(page), page);	\
+		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
 		page;})
 
 /*
diff -puN lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3 lib/Kconfig.debug
--- a/lib/Kconfig.debug~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3
+++ a/lib/Kconfig.debug
@@ -580,6 +580,14 @@ config DEBUG_VM_RB
 
 	  If unsure, say N.
 
+config DEBUG_VM_PGFLAGS
+	bool "Debug page-flags operations"
+	depends on DEBUG_VM
+	help
+	  Enables extra validation on page flags operations.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
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

