From: akpm@linux-foundation.org
Subject: + x86-mm-provide-pmdp_establish-helper-fix.patch added to -mm
 tree
Date: Wed, 13 Dec 2017 16:11:36 -0800
Message-ID: <5a31c1b8.xJ1hJedUfMb2+iub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdLNALh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-provide-pmdp_establish-helper-fix
has been added to the -mm tree.  Its filename is
     x86-mm-provide-pmdp_establish-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-provide-pmdp_establish-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-provide-pmdp_establish-helper-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-mm-provide-pmdp_establish-helper-fix

add missing `do' to do-while loop

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable-3level.h~x86-mm-provide-pmdp_establish-helper-fix arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-mm-provide-pmdp_establish-helper-fix
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -208,7 +208,7 @@ static inline pmd_t pmdp_establish(struc
 		return old.pmd;
 	}
 
-	{
+	do {
 		old = *pmdp;
 	} while (cmpxchg64(&pmdp->pmd, old.pmd, pmd.pmd) != old.pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

