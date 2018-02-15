From: akpm@linux-foundation.org
Subject: + exec-pass-stack-rlimit-into-mm-layout-functions.patch added to
 -mm tree
Date: Wed, 14 Feb 2018 16:02:41 -0800
Message-ID: <5a84ce21.NolHGIoIwVBUiYk0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031901AbeBOACn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:02:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ben@decadent.org.uk, ben.hutchings@codethink.co.uk, greg@kroah.com, hughd@google.com, Jason@zx2c4.com, labbott@redhat.com, luto@kernel.org, mhocko@kernel.org, oleg@redhat.com, riel@redhat.com, spender@grsecurity.net, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: pass stack rlimit into mm layout functions
has been added to the -mm tree.  Its filename is
     exec-pass-stack-rlimit-into-mm-layout-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-pass-stack-rlimit-into-mm-layout-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-pass-stack-rlimit-into-mm-layout-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: pass stack rlimit into mm layout functions

Patch series "exec: Pin stack limit during exec".

Attempts to solve problems with the stack limit changing during exec
continue to be frustrated[1][2].  In addition to the specific issues
around the Stack Clash family of flaws, Andy Lutomirski pointed out[3]
other places during exec where the stack limit is used and is assumed to
be unchanging.  Given the many places it gets used and the fact that it
can be manipulated/raced via setrlimit() and prlimit(), I think the only
way to handle this is to move away from the "current" view of the stack
limit and instead attach it to the bprm, and plumb this down into the
functions that need to know the stack limits.  This series implements the
approach.

[1] 04e35f4495dd ("exec: avoid RLIMIT_STACK races with prlimit()")
[2] 779f4e1c6c7c ("Revert "exec: avoid RLIMIT_STACK races with prlimit()"")
[3] to security@kernel.org, "Subject: existing rlimit races?"


This patch (of 3):

Since it is possible that the stack rlimit can change externally during
exec (either via another thread calling setrlimit() or another process
calling prlimit()), provide a way to pass the rlimit down into the
per-architecture mm layout functions so that the rlimit can stay in the
bprm structure instead of sitting in the signal structure until exec is
finalized.

Link: http://lkml.kernel.org/r/1518638796-20819-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c               |   14 +++++++-------
 arch/arm64/mm/mmap.c             |   14 +++++++-------
 arch/mips/mm/mmap.c              |   14 +++++++-------
 arch/parisc/kernel/sys_parisc.c  |   16 +++++++++++-----
 arch/powerpc/mm/mmap.c           |   28 ++++++++++++++++------------
 arch/s390/mm/mmap.c              |   15 ++++++++-------
 arch/sparc/kernel/sys_sparc_64.c |    4 ++--
 arch/tile/mm/mmap.c              |   11 ++++++-----
 arch/x86/mm/mmap.c               |   18 +++++++++++-------
 fs/exec.c                        |    8 +++++++-
 include/linux/sched/mm.h         |    6 ++++--
 mm/util.c                        |    2 +-
 12 files changed, 87 insertions(+), 63 deletions(-)

diff -puN arch/arm64/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/arm64/mm/mmap.c
@@ -38,12 +38,12 @@
 #define MIN_GAP (SZ_128M)
 #define MAX_GAP	(STACK_TOP/6*5)
 
-static int mmap_is_legacy(void)
+static int mmap_is_legacy(struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+	if (rlim_stack->rlim_cur == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
@@ -62,9 +62,9 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static unsigned long mmap_base(unsigned long rnd)
+static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = (STACK_RND_MASK << PAGE_SHIFT) + stack_guard_gap;
 
 	/* Values close to RLIM_INFINITY can overflow. */
@@ -83,7 +83,7 @@ static unsigned long mmap_base(unsigned
  * This function, called very early during the creation of a new process VM
  * image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
@@ -94,11 +94,11 @@ void arch_pick_mmap_layout(struct mm_str
 	 * Fall back to the standard layout if the personality bit is set, or
 	 * if the expected stack growth is unlimited:
 	 */
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/arm/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/arm/mm/mmap.c
@@ -21,20 +21,20 @@
 #define MIN_GAP (128*1024*1024UL)
 #define MAX_GAP ((TASK_SIZE)/6*5)
 
-static int mmap_is_legacy(void)
+static int mmap_is_legacy(struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+	if (rlim_stack->rlim_cur == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_base(unsigned long rnd)
+static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
@@ -180,18 +180,18 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
 		random_factor = arch_mmap_rnd();
 
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/mips/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/mips/mm/mmap.c
@@ -24,20 +24,20 @@ EXPORT_SYMBOL(shm_align_mask);
 #define MIN_GAP (128*1024*1024UL)
 #define MAX_GAP ((TASK_SIZE)/6*5)
 
-static int mmap_is_legacy(void)
+static int mmap_is_legacy(struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+	if (rlim_stack->rlim_cur == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_base(unsigned long rnd)
+static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
@@ -158,18 +158,18 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
 		random_factor = arch_mmap_rnd();
 
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/parisc/kernel/sys_parisc.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -70,12 +70,18 @@ static inline unsigned long COLOR_ALIGN(
  * Top of mmap area (just below the process stack).
  */
 
-static unsigned long mmap_upper_limit(void)
+/*
+ * When called from arch_get_unmapped_area(), rlim_stack will be NULL,
+ * indicating that "current" should be used instead of a passed-in
+ * value from the exec bprm as done with arch_pick_mmap_layout().
+ */
+static unsigned long mmap_upper_limit(struct rlimit *rlim_stack)
 {
 	unsigned long stack_base;
 
 	/* Limit stack size - see setup_arg_pages() in fs/exec.c */
-	stack_base = rlimit_max(RLIMIT_STACK);
+	stack_base = rlim_stack ? rlim_stack->rlim_max
+				: rlimit_max(RLIMIT_STACK);
 	if (stack_base > STACK_SIZE_MAX)
 		stack_base = STACK_SIZE_MAX;
 
@@ -127,7 +133,7 @@ unsigned long arch_get_unmapped_area(str
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = mm->mmap_legacy_base;
-	info.high_limit = mmap_upper_limit();
+	info.high_limit = mmap_upper_limit(NULL);
 	info.align_mask = last_mmap ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
 	info.align_offset = shared_align_offset(last_mmap, pgoff);
 	addr = vm_unmapped_area(&info);
@@ -250,10 +256,10 @@ static unsigned long mmap_legacy_base(vo
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	mm->mmap_legacy_base = mmap_legacy_base();
-	mm->mmap_base = mmap_upper_limit();
+	mm->mmap_base = mmap_upper_limit(rlim_stack);
 
 	if (mmap_is_legacy()) {
 		mm->mmap_base = mm->mmap_legacy_base;
diff -puN arch/powerpc/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/powerpc/mm/mmap.c
@@ -39,12 +39,12 @@
 #define MIN_GAP (128*1024*1024)
 #define MAX_GAP (TASK_SIZE/6*5)
 
-static inline int mmap_is_legacy(void)
+static inline int mmap_is_legacy(struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+	if (rlim_stack->rlim_cur == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
@@ -76,9 +76,10 @@ static inline unsigned long stack_maxran
 		return (1<<30);
 }
 
-static inline unsigned long mmap_base(unsigned long rnd)
+static inline unsigned long mmap_base(unsigned long rnd,
+				      struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size() + stack_guard_gap;
 
 	/* Values close to RLIM_INFINITY can overflow. */
@@ -196,26 +197,28 @@ radix__arch_get_unmapped_area_topdown(st
 }
 
 static void radix__arch_pick_mmap_layout(struct mm_struct *mm,
-					unsigned long random_factor)
+					unsigned long random_factor,
+					struct rlimit *rlim_stack)
 {
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = radix__arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = radix__arch_get_unmapped_area_topdown;
 	}
 }
 #else
 /* dummy */
 extern void radix__arch_pick_mmap_layout(struct mm_struct *mm,
-					unsigned long random_factor);
+					unsigned long random_factor,
+					struct rlimit *rlim_stack);
 #endif
 /*
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
@@ -223,16 +226,17 @@ void arch_pick_mmap_layout(struct mm_str
 		random_factor = arch_mmap_rnd();
 
 	if (radix_enabled())
-		return radix__arch_pick_mmap_layout(mm, random_factor);
+		return radix__arch_pick_mmap_layout(mm, random_factor,
+						    rlim_stack);
 	/*
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/s390/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/s390/mm/mmap.c
@@ -37,11 +37,11 @@ static unsigned long stack_maxrandom_siz
 #define MIN_GAP (32*1024*1024)
 #define MAX_GAP (STACK_TOP/6*5)
 
-static inline int mmap_is_legacy(void)
+static inline int mmap_is_legacy(struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
+	if (rlim_stack->rlim_cur == RLIM_INFINITY)
 		return 1;
 	return sysctl_legacy_va_layout;
 }
@@ -56,9 +56,10 @@ static unsigned long mmap_base_legacy(un
 	return TASK_UNMAPPED_BASE + rnd;
 }
 
-static inline unsigned long mmap_base(unsigned long rnd)
+static inline unsigned long mmap_base(unsigned long rnd,
+				      struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
@@ -184,7 +185,7 @@ check_asce_limit:
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
@@ -195,11 +196,11 @@ void arch_pick_mmap_layout(struct mm_str
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
-	if (mmap_is_legacy()) {
+	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = mmap_base_legacy(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(random_factor);
+		mm->mmap_base = mmap_base(random_factor, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/sparc/kernel/sys_sparc_64.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -276,7 +276,7 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = mmap_rnd();
 	unsigned long gap;
@@ -285,7 +285,7 @@ void arch_pick_mmap_layout(struct mm_str
 	 * Fall back to the standard layout if the personality
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
-	gap = rlimit(RLIMIT_STACK);
+	gap = rlim_stack->rlim_cur;
 	if (!test_thread_flag(TIF_32BIT) ||
 	    (current->personality & ADDR_COMPAT_LAYOUT) ||
 	    gap == RLIM_INFINITY ||
diff -puN arch/tile/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/tile/mm/mmap.c
--- a/arch/tile/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/tile/mm/mmap.c
@@ -30,9 +30,10 @@
 #define MIN_GAP (128*1024*1024)
 #define MAX_GAP (TASK_SIZE/6*5)
 
-static inline unsigned long mmap_base(struct mm_struct *mm)
+static inline unsigned long mmap_base(struct mm_struct *mm,
+				      struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long random_factor = 0;
 
 	if (current->flags & PF_RANDOMIZE)
@@ -50,7 +51,7 @@ static inline unsigned long mmap_base(st
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 #if !defined(__tilegx__)
 	int is_32bit = 1;
@@ -78,11 +79,11 @@ void arch_pick_mmap_layout(struct mm_str
 	 * Use standard layout if the expected stack growth is unlimited
 	 * or we are running native 64 bits.
 	 */
-	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
+	if (rlim_stack->rlim_cur == RLIM_INFINITY) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base(mm);
+		mm->mmap_base = mmap_base(mm, rlim_stack);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
diff -puN arch/x86/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/arch/x86/mm/mmap.c
@@ -90,9 +90,10 @@ unsigned long arch_mmap_rnd(void)
 	return arch_rnd(mmap_is_ia32() ? mmap32_rnd_bits : mmap64_rnd_bits);
 }
 
-static unsigned long mmap_base(unsigned long rnd, unsigned long task_size)
+static unsigned long mmap_base(unsigned long rnd, unsigned long task_size,
+			       struct rlimit *rlim_stack)
 {
-	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size(task_size) + stack_guard_gap;
 	unsigned long gap_min, gap_max;
 
@@ -126,16 +127,17 @@ static unsigned long mmap_legacy_base(un
  * process VM image, sets up which VM layout function to use:
  */
 static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
-		unsigned long random_factor, unsigned long task_size)
+		unsigned long random_factor, unsigned long task_size,
+		struct rlimit *rlim_stack)
 {
 	*legacy_base = mmap_legacy_base(random_factor, task_size);
 	if (mmap_is_legacy())
 		*base = *legacy_base;
 	else
-		*base = mmap_base(random_factor, task_size);
+		*base = mmap_base(random_factor, task_size, rlim_stack);
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	if (mmap_is_legacy())
 		mm->get_unmapped_area = arch_get_unmapped_area;
@@ -143,7 +145,8 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 
 	arch_pick_mmap_base(&mm->mmap_base, &mm->mmap_legacy_base,
-			arch_rnd(mmap64_rnd_bits), task_size_64bit(0));
+			arch_rnd(mmap64_rnd_bits), task_size_64bit(0),
+			rlim_stack);
 
 #ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
 	/*
@@ -153,7 +156,8 @@ void arch_pick_mmap_layout(struct mm_str
 	 * mmap_base, the compat syscall uses mmap_compat_base.
 	 */
 	arch_pick_mmap_base(&mm->mmap_compat_base, &mm->mmap_compat_legacy_base,
-			arch_rnd(mmap32_rnd_bits), task_size_32bit());
+			arch_rnd(mmap32_rnd_bits), task_size_32bit(),
+			rlim_stack);
 #endif
 }
 
diff -puN fs/exec.c~exec-pass-stack-rlimit-into-mm-layout-functions fs/exec.c
--- a/fs/exec.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/fs/exec.c
@@ -1323,6 +1323,8 @@ EXPORT_SYMBOL(would_dump);
 
 void setup_new_exec(struct linux_binprm * bprm)
 {
+	struct rlimit rlim_stack;
+
 	/*
 	 * Once here, prepare_binrpm() will not be called any more, so
 	 * the final state of setuid/setgid/fscaps can be merged into the
@@ -1346,7 +1348,11 @@ void setup_new_exec(struct linux_binprm
 			current->signal->rlim[RLIMIT_STACK].rlim_cur = _STK_LIM;
 	}
 
-	arch_pick_mmap_layout(current->mm);
+	task_lock(current->group_leader);
+	rlim_stack = current->signal->rlim[RLIMIT_STACK];
+	task_unlock(current->group_leader);
+
+	arch_pick_mmap_layout(current->mm, &rlim_stack);
 
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
diff -puN include/linux/sched/mm.h~exec-pass-stack-rlimit-into-mm-layout-functions include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/include/linux/sched/mm.h
@@ -104,7 +104,8 @@ static inline void mm_update_next_owner(
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MMU
-extern void arch_pick_mmap_layout(struct mm_struct *mm);
+extern void arch_pick_mmap_layout(struct mm_struct *mm,
+				  struct rlimit *rlim_stack);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
 		       unsigned long, unsigned long);
@@ -113,7 +114,8 @@ arch_get_unmapped_area_topdown(struct fi
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags);
 #else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
+static inline void arch_pick_mmap_layout(struct mm_struct *mm,
+					 struct rlimit *rlim_stack) {}
 #endif
 
 static inline bool in_vfork(struct task_struct *tsk)
diff -puN mm/util.c~exec-pass-stack-rlimit-into-mm-layout-functions mm/util.c
--- a/mm/util.c~exec-pass-stack-rlimit-into-mm-layout-functions
+++ a/mm/util.c
@@ -287,7 +287,7 @@ int vma_is_stack_for_current(struct vm_a
 }
 
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
-void arch_pick_mmap_layout(struct mm_struct *mm)
+void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	mm->get_unmapped_area = arch_get_unmapped_area;
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch

