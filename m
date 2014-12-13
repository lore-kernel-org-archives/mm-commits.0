From: akpm@linux-foundation.org
Subject: [folded-merged]
 zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:44:46 -0800
Message-ID: <548b8bfe.0ufCG1vJqb8MR+qK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaLMAor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch

This patch was dropped because it was folded into zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix

use __init and __exit

Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Mahendran Ganesh <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix
+++ a/mm/zsmalloc.c
@@ -911,7 +911,7 @@ static int zs_register_cpu_notifier(void
 	return notifier_to_errno(ret);
 }
 
-static void zs_exit(void)
+static void __exit zs_exit(void)
 {
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
@@ -919,7 +919,7 @@ static void zs_exit(void)
 	zs_unregister_cpu_notifier();
 }
 
-static int zs_init(void)
+static int __init zs_init(void)
 {
 	int ret = zs_register_cpu_notifier();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

