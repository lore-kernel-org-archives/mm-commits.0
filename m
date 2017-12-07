From: akpm@linux-foundation.org
Subject: +
 mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch added to -mm tree
Date: Wed, 06 Dec 2017 16:07:57 -0800
Message-ID: <5a28865d.Modhq8S/tNSYoYYB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLGAH6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:07:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix
has been added to the -mm tree.  Its filename is
     mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch

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
Subject: mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix

add comment

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix
+++ a/mm/memory.c
@@ -3831,6 +3831,7 @@ static inline int create_huge_pmd(struct
 	return VM_FAULT_FALLBACK;
 }
 
+/* `inline' is required to avoid gcc 4.1.2 build error */
 static inline int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	if (vma_is_anonymous(vmf->vma))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

