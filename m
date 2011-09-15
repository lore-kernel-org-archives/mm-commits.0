From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-make-copy_from_user-provably-correct.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:17 -0700
Message-ID: <201109151935.p8FJZH54005251@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:9802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab1IOTfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm/mempolicy.c: make copy_from_user() provably correct
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-make-copy_from_user-provably-correct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mempolicy.c: make copy_from_user() provably correct
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Because of x86-implement-strict-user-copy-checks-for-x86_64.patch

When compiling mm/mempolicy.c the following warning is shown.

In file included from arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:70,
                 from mm/mempolicy.c:68:
In function `copy_from_user',
    inlined from `compat_sys_get_mempolicy' at mm/mempolicy.c:1415:
arch/x86/include/asm/uaccess_64.h:64: warning: call to `copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
  LD      mm/built-in.o

Fix this by passing correct buffer size value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-make-copy_from_user-provably-correct mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-make-copy_from_user-provably-correct
+++ a/mm/mempolicy.c
@@ -1411,7 +1411,9 @@ asmlinkage long compat_sys_get_mempolicy
 	err = sys_get_mempolicy(policy, nm, nr_bits+1, addr, flags);
 
 	if (!err && nmask) {
-		err = copy_from_user(bm, nm, alloc_size);
+		unsigned long copy_size;
+		copy_size = min_t(unsigned long, sizeof(bm), alloc_size);
+		err = copy_from_user(bm, nm, copy_size);
 		/* ensure entire bitmap is zeroed */
 		err |= clear_user(nmask, ALIGN(maxnode-1, 8) / 8);
 		err |= compat_put_bitmap(nmask, bm, nr_bits);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
memcg-rename-mem-variable-to-memcg.patch
memcg-fix-oom-schedule_timeout.patch
memcg-replace-ss-id_lock-with-a-rwlock.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-close-race-between-charge-and-putback.patch

