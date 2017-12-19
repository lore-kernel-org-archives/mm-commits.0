From: akpm@linux-foundation.org
Subject: + kernel-exitc-export-abort-to-modules.patch added to -mm tree
Date: Tue, 19 Dec 2017 13:56:20 -0800
Message-ID: <5a398b04.23i5LtEGh7et7kcH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdLSV4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 16:56:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Alexey.Brodkin@synopsys.com, arnd@arndb.de, sudipm.mukherjee@gmail.com, Vineet.Gupta1@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: export abort() to modules
has been added to the -mm tree.  Its filename is
     kernel-exitc-export-abort-to-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-exitc-export-abort-to-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-exitc-export-abort-to-modules.patch

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
Subject: kernel/exit.c: export abort() to modules

gcc -fisolate-erroneous-paths-dereference can generate calls to abort()
from modular code too.

Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Alexey Brodkin" <Alexey.Brodkin@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/exit.c~kernel-exitc-export-abort-to-modules kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-export-abort-to-modules
+++ a/kernel/exit.c
@@ -1763,3 +1763,4 @@ __weak void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
+EXPORT_SYMBOL(abort);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-exitc-export-abort-to-modules.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch
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
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

