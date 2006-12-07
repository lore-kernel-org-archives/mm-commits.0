From: akpm@osdl.org
Subject: - mm-kummap_atomic-vs-in_atomic.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:50 -0800
Message-ID: <200612072256.kB7MuojQ029241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163570AbWLGW44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: k{,um}map_atomic() vs in_atomic()
has been removed from the -mm tree.  Its filename was
     mm-kummap_atomic-vs-in_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: k{,um}map_atomic() vs in_atomic()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Make kmap_atomic/kunmap_atomic denote a pagefault disabled scope.  All non
trivial implementations already do this anyway.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-mips/highmem.h |   10 ++++++++--
 include/linux/highmem.h    |    8 +++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/asm-mips/highmem.h~mm-kummap_atomic-vs-in_atomic include/asm-mips/highmem.h
--- a/include/asm-mips/highmem.h~mm-kummap_atomic-vs-in_atomic
+++ a/include/asm-mips/highmem.h
@@ -21,6 +21,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 #include <asm/kmap_types.h>
 
 /* undef for production */
@@ -70,11 +71,16 @@ static inline void *kmap(struct page *pa
 
 static inline void *kmap_atomic(struct page *page, enum km_type type)
 {
+	pagefault_disable();
 	return page_address(page);
 }
 
-static inline void kunmap_atomic(void *kvaddr, enum km_type type) { }
-#define kmap_atomic_pfn(pfn, idx)	page_address(pfn_to_page(pfn))
+static inline void kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	pagefault_enable();
+}
+
+#define kmap_atomic_pfn(pfn, idx) kmap_atomic(pfn_to_page(pfn), (idx))
 
 #define kmap_atomic_to_page(ptr) virt_to_page(ptr)
 
diff -puN include/linux/highmem.h~mm-kummap_atomic-vs-in_atomic include/linux/highmem.h
--- a/include/linux/highmem.h~mm-kummap_atomic-vs-in_atomic
+++ a/include/linux/highmem.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 
 #include <asm/cacheflush.h>
 
@@ -41,9 +42,10 @@ static inline void *kmap(struct page *pa
 
 #define kunmap(page) do { (void) (page); } while (0)
 
-#define kmap_atomic(page, idx)		page_address(page)
-#define kunmap_atomic(addr, idx)	do { } while (0)
-#define kmap_atomic_pfn(pfn, idx)	page_address(pfn_to_page(pfn))
+#define kmap_atomic(page, idx) \
+	({ pagefault_disable(); page_address(page); })
+#define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
+#define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 #endif
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

