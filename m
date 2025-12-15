Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9A3009E1
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819016; cv=none; b=KM2BrzWXmsrancW8zACJX4shfzHRnNribXcWCgjA5KuTMIpLikrhJE7IZeYT4cYeB+JRdsz6h1h3dCHUCBh2U6mKPM+0U/f5x9/qAYVSV+wutrh1etViZUPYEzgNnquCpHZU8RzFsdkO6AUwgC47bR3JHiRbaaCu43aLal/8cy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819016; c=relaxed/simple;
	bh=qE58IZtIAJQhMO9Xm6DXP2o/v/EM0E2CpFvvEiXMOgk=;
	h=Date:To:From:Subject:Message-Id; b=TAPCPu4KudV/tI7Ciie6eqiEQQMeWWZs6T2G9xgQSm8/9tUIEAN5llO4qdjqPZX7nY5ZhLrUqajr5pn4S8lEiH16Yq+6AwzIFH1YZROpi/fBhDy8gV8Sp3DOHhTZmRbv1ChmPOmp1y5Z00qK8QYFuq2iK80vhuutwiv0IQLZKQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4T58Tpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4T58Tpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABE3C4CEF5;
	Mon, 15 Dec 2025 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765819015;
	bh=qE58IZtIAJQhMO9Xm6DXP2o/v/EM0E2CpFvvEiXMOgk=;
	h=Date:To:From:Subject:From;
	b=u4T58TpmPiNnJPwYKJHSi3ClKGwZgKjeXHTrVue0eq67rE/02Y7EGeElvVR7xJh9a
	 0lGVsNw6Agl8MXYlID6og6QyCLteDJKX4Twbc08tBszCc8Tlc2XhPcLNiYJ97KrHzx
	 3sXEqcaZByWJMAtZdVy1XVqd51Fe2U0oxEsiJg3c=
Date: Mon, 15 Dec 2025 09:16:54 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-lazy_mmu-sections-to-nest.patch added to mm-new branch
Message-Id: <20251215171655.8ABE3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable lazy_mmu sections to nest
has been added to the -mm mm-new branch.  Its filename is
     mm-enable-lazy_mmu-sections-to-nest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-lazy_mmu-sections-to-nest.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: enable lazy_mmu sections to nest
Date: Mon, 15 Dec 2025 15:03:18 +0000

Despite recent efforts to prevent lazy_mmu sections from nesting, it
remains difficult to ensure that it never occurs - and in fact it does
occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).  Commit
1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested") made nesting
tolerable on arm64, but without truly supporting it: the inner call to
leave() disables the batching optimisation before the outer section ends.

This patch actually enables lazy_mmu sections to nest by tracking the
nesting level in task_struct, in a similar fashion to e.g. 
pagefault_{enable,disable}().  This is fully handled by the generic
lazy_mmu helpers that were recently introduced.

lazy_mmu sections were not initially intended to nest, so we need to
clarify the semantics w.r.t.  the arch_*_lazy_mmu_mode() callbacks.  This
patch takes the following approach:

* The outermost calls to lazy_mmu_mode_{enable,disable}() trigger
  calls to arch_{enter,leave}_lazy_mmu_mode() - this is unchanged.

* Nested calls to lazy_mmu_mode_{enable,disable}() are not forwarded
  to the arch via arch_{enter,leave} - lazy MMU remains enabled so
  the assumption is that these callbacks are not relevant. However,
  existing code may rely on a call to disable() to flush any batched
  state, regardless of nesting. arch_flush_lazy_mmu_mode() is
  therefore called in that situation.

A separate interface was recently introduced to temporarily pause the lazy
MMU mode: lazy_mmu_mode_{pause,resume}().  pause() fully exits the mode
*regardless of the nesting level*, and resume() restores the mode at the
same nesting level.

pause()/resume() are themselves allowed to nest, so we actually store two
nesting levels in task_struct: enable_count and pause_count.  A new helper
is_lazy_mmu_mode_active() is introduced to determine whether we are
currently in lazy MMU mode; this will be used in subsequent patches to
replace the various ways arch's currently track whether the mode is
enabled.

In summary (enable/pause represent the values *after* the call):

lazy_mmu_mode_enable()		-> arch_enter()	    enable=1 pause=0
    lazy_mmu_mode_enable()	-> ø		    enable=2 pause=0
	lazy_mmu_mode_pause()	-> arch_leave()     enable=2 pause=1
	lazy_mmu_mode_resume()	-> arch_enter()     enable=2 pause=0
    lazy_mmu_mode_disable()	-> arch_flush()     enable=1 pause=0
lazy_mmu_mode_disable()		-> arch_leave()     enable=0 pause=0

Note: is_lazy_mmu_mode_active() is added to <linux/sched.h> to allow
arch headers included by <linux/pgtable.h> to use it.

Link: https://lkml.kernel.org/r/20251215150323.2218608-10-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   12 ---
 include/linux/mm_types_task.h    |    5 +
 include/linux/pgtable.h          |  114 +++++++++++++++++++++++++++--
 include/linux/sched.h            |   45 +++++++++++
 4 files changed, 157 insertions(+), 19 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-enable-lazy_mmu-sections-to-nest
+++ a/arch/arm64/include/asm/pgtable.h
@@ -82,18 +82,6 @@ static inline void queue_pte_barriers(vo
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	/*
-	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
-	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
-	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
-	 * permissions on the linear map with apply_to_page_range(), which
-	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
-	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
-	 * flush and clear the flag such that the remainder of the work in the
-	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
-	 * keeps tracking simple.
-	 */
-
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
--- a/include/linux/mm_types_task.h~mm-enable-lazy_mmu-sections-to-nest
+++ a/include/linux/mm_types_task.h
@@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
 #endif
 };
 
+struct lazy_mmu_state {
+	u8 enable_count;
+	u8 pause_count;
+};
+
 #endif /* _LINUX_MM_TYPES_TASK_H */
--- a/include/linux/pgtable.h~mm-enable-lazy_mmu-sections-to-nest
+++ a/include/linux/pgtable.h
@@ -236,39 +236,139 @@ static inline int pmd_dirty(pmd_t pmd)
  * The mode is disabled in interrupt context and calls to the lazy_mmu API have
  * no effect.
  *
- * Nesting is not permitted.
+ * The lazy MMU mode is enabled for a given block of code using:
+ *
+ *   lazy_mmu_mode_enable();
+ *   <code>
+ *   lazy_mmu_mode_disable();
+ *
+ * Nesting is permitted: <code> may itself use an enable()/disable() pair.
+ * A nested call to enable() has no functional effect; however disable() causes
+ * any batched architectural state to be flushed regardless of nesting. After a
+ * call to disable(), the caller can therefore rely on all previous page table
+ * modifications to have taken effect, but the lazy MMU mode may still be
+ * enabled.
+ *
+ * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
+ * This can be done using:
+ *
+ *   lazy_mmu_mode_pause();
+ *   <code>
+ *   lazy_mmu_mode_resume();
+ *
+ * pause() ensures that the mode is exited regardless of the nesting level;
+ * resume() re-enters the mode at the same nesting level. Any call to the
+ * lazy_mmu_mode_* API between those two calls has no effect. In particular,
+ * this means that pause()/resume() pairs may nest.
+ *
+ * is_lazy_mmu_mode_active() can be used to check whether the lazy MMU mode is
+ * currently enabled.
  */
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+/**
+ * lazy_mmu_mode_enable() - Enable the lazy MMU mode.
+ *
+ * Enters a new lazy MMU mode section; if the mode was not already enabled,
+ * enables it and calls arch_enter_lazy_mmu_mode().
+ *
+ * Must be paired with a call to lazy_mmu_mode_disable().
+ *
+ * Has no effect if called:
+ * - While paused - see lazy_mmu_mode_pause()
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_enable(void)
 {
-	if (in_interrupt())
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
 		return;
 
-	arch_enter_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
+
+	if (state->enable_count++ == 0)
+		arch_enter_lazy_mmu_mode();
 }
 
+/**
+ * lazy_mmu_mode_disable() - Disable the lazy MMU mode.
+ *
+ * Exits the current lazy MMU mode section. If it is the outermost section,
+ * disables the mode and calls arch_leave_lazy_mmu_mode(). Otherwise (nested
+ * section), calls arch_flush_lazy_mmu_mode().
+ *
+ * Must match a call to lazy_mmu_mode_enable().
+ *
+ * Has no effect if called:
+ * - While paused - see lazy_mmu_mode_pause()
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_disable(void)
 {
-	if (in_interrupt())
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
 		return;
 
-	arch_leave_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->enable_count == 0);
+
+	if (--state->enable_count == 0)
+		arch_leave_lazy_mmu_mode();
+	else /* Exiting a nested section */
+		arch_flush_lazy_mmu_mode();
+
 }
 
+/**
+ * lazy_mmu_mode_pause() - Pause the lazy MMU mode.
+ *
+ * Pauses the lazy MMU mode; if it is currently active, disables it and calls
+ * arch_leave_lazy_mmu_mode().
+ *
+ * Must be paired with a call to lazy_mmu_mode_resume(). Calls to the
+ * lazy_mmu_mode_* API have no effect until the matching resume() call.
+ *
+ * Has no effect if called:
+ * - While paused (inside another pause()/resume() pair)
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_pause(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
 	if (in_interrupt())
 		return;
 
-	arch_leave_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
+
+	if (state->pause_count++ == 0 && state->enable_count > 0)
+		arch_leave_lazy_mmu_mode();
 }
 
+/**
+ * lazy_mmu_mode_resume() - Resume the lazy MMU mode.
+ *
+ * Resumes the lazy MMU mode; if it was active at the point where the matching
+ * call to lazy_mmu_mode_pause() was made, re-enables it and calls
+ * arch_enter_lazy_mmu_mode().
+ *
+ * Must match a call to lazy_mmu_mode_pause().
+ *
+ * Has no effect if called:
+ * - While paused (inside another pause()/resume() pair)
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_resume(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
 	if (in_interrupt())
 		return;
 
-	arch_enter_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->pause_count == 0);
+
+	if (--state->pause_count == 0 && state->enable_count > 0)
+		arch_enter_lazy_mmu_mode();
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
--- a/include/linux/sched.h~mm-enable-lazy_mmu-sections-to-nest
+++ a/include/linux/sched.h
@@ -1419,6 +1419,10 @@ struct task_struct {
 
 	struct page_frag		task_frag;
 
+#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+	struct lazy_mmu_state		lazy_mmu_state;
+#endif
+
 #ifdef CONFIG_TASK_DELAY_ACCT
 	struct task_delay_info		*delays;
 #endif
@@ -1702,6 +1706,47 @@ static inline char task_state_to_char(st
 	return task_index_to_char(task_state_index(tsk));
 }
 
+#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+/**
+ * __task_lazy_mmu_mode_active() - Test the lazy MMU mode state for a task.
+ * @tsk: The task to check.
+ *
+ * Test whether @tsk has its lazy MMU mode state set to active (i.e. enabled
+ * and not paused).
+ *
+ * This function only considers the state saved in task_struct; to test whether
+ * current actually is in lazy MMU mode, is_lazy_mmu_mode_active() should be
+ * used instead.
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline bool __task_lazy_mmu_mode_active(struct task_struct *tsk)
+{
+	struct lazy_mmu_state *state = &tsk->lazy_mmu_state;
+
+	return state->enable_count > 0 && state->pause_count == 0;
+}
+
+/**
+ * is_lazy_mmu_mode_active() - Test whether we are currently in lazy MMU mode.
+ *
+ * Test whether the current context is in lazy MMU mode. This is true if both:
+ * 1. We are not in interrupt context
+ * 2. Lazy MMU mode is active for the current task
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline bool is_lazy_mmu_mode_active(void)
+{
+	if (in_interrupt())
+		return false;
+
+	return __task_lazy_mmu_mode_active(current);
+}
+#endif
+
 extern struct pid *cad_pid;
 
 /*
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch

