From: akpm@linux-foundation.org
Subject: + mm-turn-vmap_purge_lock-into-a-mutex.patch added to -mm tree
Date: Mon, 21 Nov 2016 22:11:43 -0800
Message-ID: <5833e19f.i4g6Jt5TirCe00sl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbcKVGLp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:11:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: turn vmap_purge_lock into a mutex
has been added to the -mm tree.  Its filename is
     mm-turn-vmap_purge_lock-into-a-mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-turn-vmap_purge_lock-into-a-mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-turn-vmap_purge_lock-into-a-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are

mm-remove-free_unmap_vmap_area_noflush.patch
mm-remove-free_unmap_vmap_area_addr.patch
mm-refactor-__purge_vmap_area_lazy.patch
mm-warn-about-vfree-from-atomic-context.patch
mm-mark-all-calls-into-the-vmalloc-subsystem-as-potentially-sleeping.patch
mm-turn-vmap_purge_lock-into-a-mutex.patch

