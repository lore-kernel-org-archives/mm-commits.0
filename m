From: akpm@linux-foundation.org
Subject: + mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
 added to -mm tree
Date: Thu, 07 Dec 2017 16:05:16 -0800
Message-ID: <5a29d73c.PiTnMfeprfX+kq1s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbdLHAFR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 19:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, sergey.senozhatsky.work@gmail.com, surenb@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-terminate-shrink_slab-loop-if-signal-is-pending-fix
has been added to the -mm tree.  Its filename is
     mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch

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
Subject: mm-terminate-shrink_slab-loop-if-signal-is-pending-fix

fix build, per Sergey

Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending-fix
+++ a/mm/vmscan.c
@@ -490,7 +490,7 @@ static unsigned long shrink_slab(gfp_t g
 		 * We are about to die and free our memory.
 		 * Stop shrinking which might delay signal handling.
 		 */
-		if (unlikely(fatal_signal_pending(current))
+		if (unlikely(fatal_signal_pending(current)))
 			break;
 
 		/*
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
mm-oom-cgroup-aware-oom-killer-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch

