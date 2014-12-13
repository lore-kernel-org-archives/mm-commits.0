From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:47:05 -0800
Message-ID: <548b8c89.ZeAE3wPYDCFT66YA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaLMArG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix
has been removed from the -mm tree.  Its filename was
     ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch

This patch was dropped because it was folded into ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix ipc/sem.c
--- a/ipc/sem.c~ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix
+++ a/ipc/sem.c
@@ -330,8 +330,8 @@ static inline int sem_lock(struct sem_ar
 			 * The ipc object lock check must be visible on all
 			 * cores before rechecking the complex count.  Otherwise
 			 * we can race with  another thread that does:
-			 * 	complex_count++++;
-			 * 	spin_unlock(sem_perm.lock);
+			 *	complex_count++;
+			 *	spin_unlock(sem_perm.lock);
 			 */
 			smp_rmb();
 
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
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

