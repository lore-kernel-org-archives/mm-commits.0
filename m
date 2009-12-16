From: akpm@linux-foundation.org
Subject: [merged] gru-fix-bug-in-allocation-of-kernel-contexts.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:05 -0800
Message-ID: <200912162041.nBGKf5f8013701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964838AbZLPUlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix bug in allocation of kernel contexts
has been removed from the -mm tree.  Its filename was
     gru-fix-bug-in-allocation-of-kernel-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix bug in allocation of kernel contexts
From: Jack Steiner <steiner@sgi.com>

Fix a bug in the assignment of GRU contexts used for kernel functions.  If
a sleep occurs on the wait for a semaphore, the thread could switch cpus
and allocate resources on the wrong blade.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-allocation-of-kernel-contexts drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-allocation-of-kernel-contexts
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -221,13 +221,21 @@ static int gru_free_kernel_contexts(void
 static struct gru_blade_state *gru_lock_kernel_context(int blade_id)
 {
 	struct gru_blade_state *bs;
+	int bid;
 
 	STAT(lock_kernel_context);
-	bs = gru_base[blade_id];
+again:
+	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
+	bs = gru_base[bid];
 
+	/* Handle the case where migration occured while waiting for the sema */
 	down_read(&bs->bs_kgts_sema);
+	if (blade_id < 0 && bid != uv_numa_blade_id()) {
+		up_read(&bs->bs_kgts_sema);
+		goto again;
+	}
 	if (!bs->bs_kgts || !bs->bs_kgts->ts_gru)
-		gru_load_kernel_context(bs, blade_id);
+		gru_load_kernel_context(bs, bid);
 	return bs;
 
 }
@@ -256,7 +264,7 @@ static int gru_get_cpu_resources(int dsr
 
 	BUG_ON(dsr_bytes > GRU_NUM_KERNEL_DSR_BYTES);
 	preempt_disable();
-	bs = gru_lock_kernel_context(uv_numa_blade_id());
+	bs = gru_lock_kernel_context(-1);
 	lcpu = uv_blade_processor_id();
 	*cb = bs->kernel_cb + lcpu * GRU_HANDLE_STRIDE;
 	*dsr = bs->kernel_dsr + lcpu * GRU_NUM_KERNEL_DSR_BYTES;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

