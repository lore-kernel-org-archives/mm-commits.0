From: akpm@linux-foundation.org
Subject: [merged]
 arm64-mmap-properly-account-for-stack-randomization-in-mmap_base.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:42:47 -0700
Message-ID: <20170713204247.fD_sGDSUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdGMUms (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hughd@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, will.deacon@arm.com


The patch titled
     Subject: arm64/mmap: properly account for stack randomization in mmap_base
has been removed from the -mm tree.  Its filename was
     arm64-mmap-properly-account-for-stack-randomization-in-mmap_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: arm64/mmap: properly account for stack randomization in mmap_base

When RLIMIT_STACK is, for example, 256MB, the current code results in a
gap between the top of the task and mmap_base of 256MB, failing to take
into account the amount by which the stack address was randomized.  In
other words, the stack gets less than RLIMIT_STACK space.

Ensure that the gap between the stack and mmap_base always takes stack
randomization and the stack guard gap into account.

Obtained from Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170622200033.25714-3-riel@redhat.com
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
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

 arch/arm64/mm/mmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/arm64/mm/mmap.c~arm64-mmap-properly-account-for-stack-randomization-in-mmap_base arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-mmap-properly-account-for-stack-randomization-in-mmap_base
+++ a/arch/arm64/mm/mmap.c
@@ -35,7 +35,7 @@
  * Leave enough space between the mmap area and the stack to honour ulimit in
  * the face of randomisation.
  */
-#define MIN_GAP (SZ_128M + ((STACK_RND_MASK << PAGE_SHIFT) + 1))
+#define MIN_GAP (SZ_128M)
 #define MAX_GAP	(STACK_TOP/6*5)
 
 static int mmap_is_legacy(void)
@@ -65,6 +65,11 @@ unsigned long arch_mmap_rnd(void)
 static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = (STACK_RND_MASK << PAGE_SHIFT) + stack_guard_gap;
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
_

Patches currently in -mm which might be from riel@redhat.com are


