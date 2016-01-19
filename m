From: akpm@linux-foundation.org
Subject: [merged] page-flags-drop-__testclearpage-helpers.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:01:15 -0800
Message-ID: <569e960b.WW2UbpLoz1TtvJR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbcASUBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: drop __TestClearPage*() helpers
has been removed from the -mm tree.  Its filename was
     page-flags-drop-__testclearpage-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: drop __TestClearPage*() helpers

Nobody uses them.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +---------
 scripts/tags.sh            |    2 --
 2 files changed, 1 insertion(+), 11 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-drop-__testclearpage-helpers include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-drop-__testclearpage-helpers
+++ a/include/linux/page-flags.h
@@ -211,10 +211,6 @@ static inline int TestSetPage##uname(str
 static inline int TestClearPage##uname(struct page *page)		\
 	{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
-#define __TESTCLEARFLAG(uname, lname, policy)				\
-static inline int __TestClearPage##uname(struct page *page)		\
-	{ return __test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
-
 #define PAGEFLAG(uname, lname, policy)					\
 	TESTPAGEFLAG(uname, lname, policy)				\
 	SETPAGEFLAG(uname, lname, policy)				\
@@ -247,9 +243,6 @@ static inline int TestSetPage##uname(str
 #define TESTCLEARFLAG_FALSE(uname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
-#define __TESTCLEARFLAG_FALSE(uname)					\
-static inline int __TestClearPage##uname(struct page *page) { return 0; }
-
 #define PAGEFLAG_FALSE(uname) TESTPAGEFLAG_FALSE(uname)			\
 	SETPAGEFLAG_NOOP(uname) CLEARPAGEFLAG_NOOP(uname)
 
@@ -331,10 +324,9 @@ PAGEFLAG(Unevictable, unevictable, PF_HE
 PAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
 	__CLEARPAGEFLAG(Mlocked, mlocked, PF_NO_TAIL)
 	TESTSCFLAG(Mlocked, mlocked, PF_NO_TAIL)
-	__TESTCLEARFLAG(Mlocked, mlocked, PF_NO_TAIL)
 #else
 PAGEFLAG_FALSE(Mlocked) __CLEARPAGEFLAG_NOOP(Mlocked)
-	TESTSCFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
+	TESTSCFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
diff -puN scripts/tags.sh~page-flags-drop-__testclearpage-helpers scripts/tags.sh
--- a/scripts/tags.sh~page-flags-drop-__testclearpage-helpers
+++ a/scripts/tags.sh
@@ -193,7 +193,6 @@ exuberant()
 	--regex-c++='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
 	--regex-c++='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/'	\
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
-	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
 	--regex-c++='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'	\
 	--regex-c++='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
@@ -260,7 +259,6 @@ emacs()
 	--regex='/CLEARPAGEFLAG_NOOP(\([^,)]*\).*/ClearPage\1/'	\
 	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
-	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
 	--regex='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'		\
 	--regex='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
 	--regex='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'	\
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

