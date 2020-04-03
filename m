From: akpm@linux-foundation.org
Subject: [merged] mm-disable-kcsan-for-kmemleak.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:36:03 -0700
Message-ID: <20200403203603.bklIZ8xGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, catalin.marinas@arm.com, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Makefile: disable KCSAN for kmemleak
has been removed from the -mm tree.  Its filename was
     mm-disable-kcsan-for-kmemleak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/Makefile: disable KCSAN for kmemleak

Kmemleak could scan task stacks while plain writes happens to those stack
variables which could results in data races.  For example, in
sys_rt_sigaction and do_sigaction(), it could have plain writes in a
32-byte size.  Since the kmemleak does not care about the actual values of
a non-pointer and all do_sigaction() call sites only copy to stack
variables, just disable KCSAN for kmemleak to avoid annotating anything
outside Kmemleak just because Kmemleak scans everything.

Link: http://lkml.kernel.org/r/1583263716-25150-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Makefile~mm-disable-kcsan-for-kmemleak
+++ a/mm/Makefile
@@ -6,6 +6,7 @@
 KASAN_SANITIZE_slab_common.o := n
 KASAN_SANITIZE_slab.o := n
 KASAN_SANITIZE_slub.o := n
+KCSAN_SANITIZE_kmemleak.o := n
 
 # These files are disabled because they produce non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. E.g. slab is out of
_

Patches currently in -mm which might be from cai@lca.pw are

percpu_counter-fix-a-data-race-at-vm_committed_as.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
