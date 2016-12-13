From: akpm@linux-foundation.org
Subject: [patch 076/123] mm: turn vmap_purge_lock into a mutex
Date: Mon, 12 Dec 2016 16:44:23 -0800
Message-ID: <584f4467.DrRaEE6vY7gLHNGf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbcLMAoY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de

From: Christoph Hellwig <hch@lst.de>
Subject: mm: turn vmap_purge_lock into a mutex

The purge_lock spinlock causes high latencies with non RT kernel. This
has been reported multiple times on lkml [1] [2] and affects
applications like audio.

This patch replaces it with a mutex to allow preemption while holding
the lock.

Thanks to Joel Fernandes for the detailed report and analysis as well
as an earlier attempt at fixing this issue.

[1] http://lists.openwall.net/linux-kernel/2016/03/23/29
[2] https://lkml.org/lkml/2016/10/9/59

Link: http://lkml.kernel.org/r/1479474236-4139-10-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jisheng Zhang <jszhang@marvell.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/vmalloc.c~mm-turn-vmap_purge_lock-into-a-mutex mm/vmalloc.c
--- a/mm/vmalloc.c~mm-turn-vmap_purge_lock-into-a-mutex
+++ a/mm/vmalloc.c
@@ -606,7 +606,7 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
  * by this look, but we want to avoid concurrent calls for performance
  * reasons and to make the pcpu_get_vm_areas more deterministic.
  */
-static DEFINE_SPINLOCK(vmap_purge_lock);
+static DEFINE_MUTEX(vmap_purge_lock);
 
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
@@ -660,9 +660,9 @@ static bool __purge_vmap_area_lazy(unsig
  */
 static void try_purge_vmap_area_lazy(void)
 {
-	if (spin_trylock(&vmap_purge_lock)) {
+	if (mutex_trylock(&vmap_purge_lock)) {
 		__purge_vmap_area_lazy(ULONG_MAX, 0);
-		spin_unlock(&vmap_purge_lock);
+		mutex_unlock(&vmap_purge_lock);
 	}
 }
 
@@ -671,10 +671,10 @@ static void try_purge_vmap_area_lazy(voi
  */
 static void purge_vmap_area_lazy(void)
 {
-	spin_lock(&vmap_purge_lock);
+	mutex_lock(&vmap_purge_lock);
 	purge_fragmented_blocks_allcpus();
 	__purge_vmap_area_lazy(ULONG_MAX, 0);
-	spin_unlock(&vmap_purge_lock);
+	mutex_unlock(&vmap_purge_lock);
 }
 
 /*
@@ -1063,11 +1063,11 @@ void vm_unmap_aliases(void)
 		rcu_read_unlock();
 	}
 
-	spin_lock(&vmap_purge_lock);
+	mutex_lock(&vmap_purge_lock);
 	purge_fragmented_blocks_allcpus();
 	if (!__purge_vmap_area_lazy(start, end) && flush)
 		flush_tlb_kernel_range(start, end);
-	spin_unlock(&vmap_purge_lock);
+	mutex_unlock(&vmap_purge_lock);
 }
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
_
