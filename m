From: akpm@linux-foundation.org
Subject: +
 powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
 added to -mm tree
Date: Fri, 02 Jun 2017 12:42:21 -0700
Message-ID: <5931bf9d.25giVBYVUJ1Teb9X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38286 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdFBTmW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 15:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, benh@kernel.crashing.org, catalin.marinas@arm.com, danielmicay@gmail.com, fweimer@redhat.com, hpa@zytor.com, lwoodman@redhat.com, mhocko@kernel.org, mingo@kernel.org, oleg@redhat.com, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc,mmap: properly account for stack randomization in mmap_base
has been added to the -mm tree.  Its filename is
     powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: powerpc,mmap: properly account for stack randomization in mmap_base

When RLIMIT_STACK is, for example, 256MB, the current code results in a
gap between the top of the task and mmap_base of 256MB, failing to take
into account the amount by which the stack address was randomized.  In
other words, the stack gets less than RLIMIT_STACK space.

Ensure that the gap between the stack and mmap_base always takes stack
randomization into account.

Inspired by Daniel Micay's linux-hardened tree.

Link: http://lkml.kernel.org/r/20170602152010.2064-7-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
+	unsigned long pad = stack_maxrandom_size();
+
+	/* Values close to RLIM_INFINITY can overflow. */
+	if (gap + pad > gap)
+		gap += pad;
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
_

Patches currently in -mm which might be from riel@redhat.com are

binfmt_elf-document-load_bias-a-little-bit.patch
x86-elf-move-32-bit-elf_et_dyn_base-to-256mb.patch
x86-mmap-properly-account-for-stack-randomization-in-mmap_base.patch
arm64-mmap-properly-account-for-stack-randomization-in-mmap_base.patch
arm64-move-compat_elf_et_dyn_base-lower-in-the-address-space.patch
powerpcmmap-properly-account-for-stack-randomization-in-mmap_base.patch
randomstackprotect-introduce-get_random_canary-function.patch
forkrandom-use-get_random_canary-to-set-tsk-stack_canary.patch
x86-ascii-armor-the-x86_64-boot-init-stack-canary.patch
arm64-ascii-armor-the-arm64-boot-init-stack-canary.patch
sh64-ascii-armor-the-sh64-boot-init-stack-canary.patch

