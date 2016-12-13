From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-vfree_atomic-fix-fix.patch removed from
 -mm tree
Date: Mon, 12 Dec 2016 16:23:38 -0800
Message-ID: <584f3f8a.lKguW3pLEgq7XNTP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAWy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-vfree_atomic-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-add-vfree_atomic-fix-fix.patch

This patch was dropped because it was folded into mm-add-vfree_atomic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-vfree_atomic-fix-fix

tweak comment grammar

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-add-vfree_atomic-fix-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-add-vfree_atomic-fix-fix
+++ a/mm/vmalloc.c
@@ -1491,10 +1491,9 @@ static inline void __vfree_deferred(cons
 {
 	/*
 	 * Use raw_cpu_ptr() because this can be called from preemptible
-	 * context. Preemption is absolutely fine here, because llist_add()
-	 * implementation is lockless, so it works even if we adding to list
-	 * of the other cpu.
-	 * schedule_work() should be fine with this too.
+	 * context. Preemption is absolutely fine here, because the llist_add()
+	 * implementation is lockless, so it works even if we are adding to
+	 * nother cpu's list.  schedule_work() should be fine with this too.
 	 */
 	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

