From: akpm@linux-foundation.org
Subject: [patch 70/96] x86/mmap: properly account for stack
 randomization in mmap_base
Date: Wed, 12 Jul 2017 14:36:33 -0700
Message-ID: <20170712213633.KB9DvaU2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbdGLVge (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hughd@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, will.deacon@arm.com

From: Rik van Riel <riel@redhat.com>
Subject: x86/mmap: properly account for stack randomization in mmap_base

When RLIMIT_STACK is, for example, 256MB, the current code results in a
gap between the top of the task and mmap_base of 256MB, failing to take
into account the amount by which the stack address was randomized.  In
other words, the stack gets less than RLIMIT_STACK space.

Ensure that the gap between the stack and mmap_base always takes stack
randomization and the stack guard gap into account.

Obtained from Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170622200033.25714-2-riel@redhat.com
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Florian Weimer <fweimer@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/mmap.c~x86-mmap-properly-account-for-stack-randomization-in-mmap_base arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-mmap-properly-account-for-stack-randomization-in-mmap_base
+++ a/arch/x86/mm/mmap.c
@@ -92,13 +92,18 @@ unsigned long arch_mmap_rnd(void)
 static unsigned long mmap_base(unsigned long rnd, unsigned long task_size)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
+	unsigned long pad = stack_maxrandom_size(task_size) + stack_guard_gap;
 	unsigned long gap_min, gap_max;
 
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
+
 	/*
 	 * Top of mmap area (just below the process stack).
 	 * Leave an at least ~128 MB hole with possible stack randomization.
 	 */
-	gap_min = SIZE_128M + stack_maxrandom_size(task_size);
+	gap_min = SIZE_128M;
 	gap_max = (task_size / 6) * 5;
 
 	if (gap < gap_min)
_
