From: akpm@linux-foundation.org
Subject: + move-might_sleep-and-friends-from-kernelh-to-schedh.patch added to -mm tree
Date: Tue, 20 Aug 2013 13:12:31 -0700
Message-ID: <5213cdaf.sw7QuHnRu+RzPUap%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTUMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 16:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl, ak@linux.intel.com

Subject: + move-might_sleep-and-friends-from-kernelh-to-schedh.patch added to -mm tree
To: ak@linux.intel.com,a.p.zijlstra@chello.nl,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 13:12:31 -0700


The patch titled
     Subject: include/: move might_sleep and friends from kernel.h to sched.h
has been added to the -mm tree.  Its filename is
     move-might_sleep-and-friends-from-kernelh-to-schedh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/move-might_sleep-and-friends-from-kernelh-to-schedh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/move-might_sleep-and-friends-from-kernelh-to-schedh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: include/: move might_sleep and friends from kernel.h to sched.h

These are really related to scheduling, so they should be in sched.h Users
usually will need to schedule anyways.

The advantage of having them there is that we can access some of the
scheduler inlines to make their fast path more efficient.  This will come
in a followon patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   35 -----------------------------------
 include/linux/sched.h  |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 35 deletions(-)

diff -puN include/linux/kernel.h~move-might_sleep-and-friends-from-kernelh-to-schedh include/linux/kernel.h
--- a/include/linux/kernel.h~move-might_sleep-and-friends-from-kernelh-to-schedh
+++ a/include/linux/kernel.h
@@ -141,35 +141,6 @@ struct completion;
 struct pt_regs;
 struct user;
 
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int _cond_resched(void);
-# define might_resched() _cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-  void __might_sleep(const char *file, int line, int preempt_offset);
-/**
- * might_sleep - annotation for functions that can sleep
- *
- * this macro will print a stack trace if it is executed in an atomic
- * context (spinlock, irq-handler, ...).
- *
- * This is a useful debugging help to be able to catch problems early and not
- * be bitten later when the calling function happens to sleep when it is not
- * supposed to.
- */
-# define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
-#else
-  static inline void __might_sleep(const char *file, int line,
-				   int preempt_offset) { }
-# define might_sleep() do { might_resched(); } while (0)
-#endif
-
-#define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
-
 /*
  * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
  * input types abs() returns a signed long.
@@ -193,12 +164,6 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
-void might_fault(void);
-#else
-static inline void might_fault(void) { }
-#endif
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 __printf(1, 2)
diff -puN include/linux/sched.h~move-might_sleep-and-friends-from-kernelh-to-schedh include/linux/sched.h
--- a/include/linux/sched.h~move-might_sleep-and-friends-from-kernelh-to-schedh
+++ a/include/linux/sched.h
@@ -2440,6 +2440,35 @@ extern int __cond_resched_softirq(void);
 	__cond_resched_softirq();					\
 })
 
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
+#else
+# define might_resched() do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+ void __might_sleep(const char *file, int line, int preempt_offset);
+/**
+ * might_sleep - annotation for functions that can sleep
+ *
+ * this macro will print a stack trace if it is executed in an atomic
+ * context (spinlock, irq-handler, ...).
+ *
+ * This is a useful debugging help to be able to catch problems early and not
+ * be bitten later when the calling function happens to sleep when it is not
+ * supposed to.
+ */
+# define might_sleep() \
+	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+#else
+  static inline void __might_sleep(const char *file, int line,
+				   int preempt_offset) { }
+# define might_sleep() do { might_resched(); } while (0)
+#endif
+
+#define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
+
 static inline void cond_resched_rcu(void)
 {
 #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
@@ -2449,6 +2478,14 @@ static inline void cond_resched_rcu(void
 #endif
 }
 
+#ifdef CONFIG_PROVE_LOCKING
+void might_fault(void);
+#else
+static inline void might_fault(void)
+{
+}
+#endif
+
 /*
  * Does a critical section need to be broken due to another
  * task waiting?: (technically does not depend on CONFIG_PREEMPT,
_

Patches currently in -mm which might be from ak@linux.intel.com are

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
x86-include-linux-schedh-in-asm-uaccessh.patch
tree-sweep-include-linux-schedh-for-might_sleep-users.patch
move-might_sleep-and-friends-from-kernelh-to-schedh.patch
sched-mark-should_resched-__always_inline.patch
sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch
linux-next.patch

