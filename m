From: akpm@linux-foundation.org
Subject: [merged]
 lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:53 -0800
Message-ID: <52867f55.6KsHA+x1hBOEJFX3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, kirill.shutemov@linux.intel.com, peterz@infradead.org

Subject: [merged] lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch removed from -mm tree
To: peterz@infradead.org,kirill.shutemov@linux.intel.com,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:53 -0800


The patch titled
     Subject: lockref: use BLOATED_SPINLOCKS to avoid explicit config dependencies
has been removed from the -mm tree.  Its filename was
     lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
