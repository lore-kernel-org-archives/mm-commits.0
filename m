From: akpm@linux-foundation.org
Subject: +
 lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch
 added to -mm tree
Date: Thu, 07 Nov 2013 14:01:04 -0800
Message-ID: <527c0da0.P37FuguQ8nq714mp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3KGWBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, kirill.shutemov@linux.intel.com, peterz@infradead.org

Subject: + lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch added to -mm tree
To: peterz@infradead.org,kirill.shutemov@linux.intel.com,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:01:04 -0800


The patch titled
     Subject: lockref: use BLOATED_SPINLOCKS to avoid explicit config dependencies
has been added to the -mm tree.  Its filename is
     lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: lockref: use BLOATED_SPINLOCKS to avoid explicit config dependencies

Avoid the fragile Kconfig construct guestimating spinlock_t sizes; use a
friendly compile-time test to determine this.

[kirill.shutemov@linux.intel.com: drop CONFIG_CMPXCHG_LOCKREF]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockref.h |    7 ++++++-
 lib/Kconfig             |    7 -------
 lib/lockref.c           |    2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/lockref.h~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies include/linux/lockref.h
--- a/include/linux/lockref.h~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies
+++ a/include/linux/lockref.h
@@ -15,10 +15,15 @@
  */
 
 #include <linux/spinlock.h>
+#include <generated/bounds.h>
+
+#define USE_CMPXCHG_LOCKREF \
+	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
+	 IS_ENABLED(CONFIG_SMP) && !BLOATED_SPINLOCKS)
 
 struct lockref {
 	union {
-#ifdef CONFIG_CMPXCHG_LOCKREF
+#if USE_CMPXCHG_LOCKREF
 		aligned_u64 lock_count;
 #endif
 		struct {
diff -puN lib/Kconfig~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies lib/Kconfig
--- a/lib/Kconfig~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies
+++ a/lib/Kconfig
@@ -51,13 +51,6 @@ config PERCPU_RWSEM
 config ARCH_USE_CMPXCHG_LOCKREF
 	bool
 
-config CMPXCHG_LOCKREF
-	def_bool y if ARCH_USE_CMPXCHG_LOCKREF
-	depends on SMP
-	depends on !GENERIC_LOCKBREAK
-	depends on !DEBUG_SPINLOCK
-	depends on !DEBUG_LOCK_ALLOC
-
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff -puN lib/lockref.c~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies lib/lockref.c
--- a/lib/lockref.c~lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies
+++ a/lib/lockref.c
@@ -1,7 +1,7 @@
 #include <linux/export.h>
 #include <linux/lockref.h>
 
-#ifdef CONFIG_CMPXCHG_LOCKREF
+#if USE_CMPXCHG_LOCKREF
 
 /*
  * Allow weakly-ordered memory architectures to provide barrier-less
_

Patches currently in -mm which might be from peterz@infradead.org are

checkpatch-make-the-memory-barrier-test-noisier.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch
lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch

