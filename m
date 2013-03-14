From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:50:29 -0700
Message-ID: <20130314185029.E2FE831C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36773 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3CNSub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:50:31 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so80355vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:50:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 kernel/workqueue.c          |   15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/res_counter.h~linux-next-rejects include/linux/res_counter.h
--- a/include/linux/res_counter.h~linux-next-rejects
+++ a/include/linux/res_counter.h
@@ -13,7 +13,7 @@
  * info about what this counter is.
  */
 
-#include <linux/cgroup.h>
+#include <linux/spinlock.h>
 #include <linux/errno.h>
 
 /*
diff -puN kernel/workqueue.c~linux-next-rejects kernel/workqueue.c
--- a/kernel/workqueue.c~linux-next-rejects
+++ a/kernel/workqueue.c
@@ -461,16 +461,19 @@ static int std_worker_pool_pri(struct wo
 	return pool - std_worker_pools(pool->cpu);
 }
 
-/* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
-	mutex_lock(&worker_pool_idr_mutex);
-	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
-	if (ret >= 0)
-		pool->id = ret;
-	mutex_unlock(&worker_pool_idr_mutex);
+	do {
+		idr_preload(GFP_KERNEL);
+		spin_lock_irq(&workqueue_lock);
+		ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_NOWAIT);
+		if (ret >= 0)
+			pool->id = ret;
+		spin_unlock_irq(&workqueue_lock);
+		idr_preload_end();
+	} while (ret == -EAGAIN);
 
 	return ret < 0 ? ret : 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

