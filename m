From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch added to
 -mm tree
Date: Tue, 19 Dec 2017 15:27:50 -0800
Message-ID: <5a39a076.IYEoOwvX1z7WGeqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbdLSX1v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 18:27:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akaraliou.dev@gmail.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-simplify-shrinker-init-destroy-fix
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch

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
Subject: mm-zsmalloc-simplify-shrinker-init-destroy-fix

update comment (Aliaksei), make zs_register_shrinker() return void

Cc: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy-fix
+++ a/mm/zsmalloc.c
@@ -2323,14 +2323,14 @@ static void zs_unregister_shrinker(struc
 	unregister_shrinker(&pool->shrinker);
 }
 
-static int zs_register_shrinker(struct zs_pool *pool)
+static void zs_register_shrinker(struct zs_pool *pool)
 {
 	pool->shrinker.scan_objects = zs_shrinker_scan;
 	pool->shrinker.count_objects = zs_shrinker_count;
 	pool->shrinker.batch = 0;
 	pool->shrinker.seeks = DEFAULT_SEEKS;
 
-	return register_shrinker(&pool->shrinker);
+	register_shrinker(&pool->shrinker);
 }
 
 /**
@@ -2419,10 +2419,12 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	/*
-	 * Not critical, we still can use the pool
-	 * and user can trigger compaction manually.
+	 * Not critical since shrinker is only used to trigger internal
+	 * defragmentation of the pool which is pretty optional thing.  If
+	 * registration fails we still can use the pool normally and user can
+	 * trigger compaction manually. Thus, ignore return code.
 	 */
-	(void) zs_register_shrinker(pool);
+	zs_register_shrinker(pool);
 
 	return pool;
 
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
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

