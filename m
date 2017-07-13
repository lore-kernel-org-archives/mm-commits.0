From: akpm@linux-foundation.org
Subject: [merged]
 powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:42:49 -0700
Message-ID: <20170713204249.2bU42QrNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hughd@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, will.deacon@arm.com


The patch titled
     Subject: powerpc,mmap: properly account for stack randomization in mmap_base
has been removed from the -mm tree.  Its filename was
     powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: powerpc,mmap: properly account for stack randomization in mmap_base

When RLIMIT_STACK is, for example, 256MB, the current code results in a
gap between the top of the task and mmap_base of 256MB, failing to take
into account the amount by which the stack address was randomized.  In
other words, the stack gets less than RLIMIT_STACK space.

Ensure that the gap between the stack and mmap_base always takes stack
randomization and the stack guard gap into account.

Inspired by Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170622200033.25714-4-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmap.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/mm/mmap.c~powerpcmmap-properly-account-for-stack-randomization-in-mmap_base arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~powerpcmmap-properly-account-for-stack-randomization-in-mmap_base
+++ a/arch/powerpc/mm/mmap.c
@@ -34,16 +34,9 @@
 /*
  * Top of mmap area (just below the process stack).
  *
- * Leave at least a ~128 MB hole on 32bit applications.
- *
- * On 64bit applications we randomise the stack by 1GB so we need to
- * space our mmap start address by a further 1GB, otherwise there is a
- * chance the mmap area will end up closer to the stack than our ulimit
- * requires.
+ * Leave at least a ~128 MB hole.
  */
-#define MIN_GAP32 (128*1024*1024)
-#define MIN_GAP64 ((128 + 1024)*1024*1024UL)
-#define MIN_GAP ((is_32bit_task()) ? MIN_GAP32 : MIN_GAP64)
+#define MIN_GAP (128*1024*1024)
 #define MAX_GAP (TASK_SIZE/6*5)
 
 static inline int mmap_is_legacy(void)
@@ -71,9 +64,26 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
+static inline unsigned long stack_maxrandom_size(void)
+{
+	if (!(current->flags & PF_RANDOMIZE))
+		return 0;
+
+	/* 8MB for 32bit, 1GB for 64bit */
+	if (is_32bit_task())
+		return (1<<23);
+	else
+		return (1<<30);
+}
+
 static inline unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = stack_maxrandom_size() + stack_guard_gap;
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
_

Patches currently in -mm which might be from riel@redhat.com are


