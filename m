From: akpm@linux-foundation.org
Subject: [merged] nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:21 -0700
Message-ID: <200905071916.n47JGLNr020273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbZEGTUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gerg@snapgear.com, lanttor.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     nommu: clamp zone_batchsize() to 0 under NOMMU conditions
has been removed from the -mm tree.  Its filename was
     nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: clamp zone_batchsize() to 0 under NOMMU conditions
From: David Howells <dhowells@redhat.com>

Clamp zone_batchsize() to 0 under NOMMU conditions to stop
free_hot_cold_page() from queueing and batching frees.

The problem is that under NOMMU conditions it is really important to be
able to allocate large contiguous chunks of memory, but when munmap() or
exit_mmap() releases big stretches of memory, return of these to the buddy
allocator can be deferred, and when it does finally happen, it can be in
small chunks.

Whilst the fragmentation this incurs isn't so much of a problem under MMU
conditions as userspace VM is glued together from individual pages with
the aid of the MMU, it is a real problem if there isn't an MMU.

By clamping the page freeing queue size to 0, pages are returned to the
allocator immediately, and the buddy detector is more likely to be able to
glue them together into large chunks immediately, and fragmentation is
less likely to occur.

By disabling batching of frees, and by turning off the trimming of excess
space during boot, Coldfire can manage to boot.

Reported-by: Lanttor Guo <lanttor.guo@freescale.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/page_alloc.c~nommu-clamp-zone_batchsize-to-0-under-nommu-conditions mm/page_alloc.c
--- a/mm/page_alloc.c~nommu-clamp-zone_batchsize-to-0-under-nommu-conditions
+++ a/mm/page_alloc.c
@@ -2681,6 +2681,7 @@ static void __meminit zone_init_free_lis
 
 static int zone_batchsize(struct zone *zone)
 {
+#ifdef CONFIG_MMU
 	int batch;
 
 	/*
@@ -2709,6 +2710,23 @@ static int zone_batchsize(struct zone *z
 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
 
 	return batch;
+
+#else
+	/* The deferral and batching of frees should be suppressed under NOMMU
+	 * conditions.
+	 *
+	 * The problem is that NOMMU needs to be able to allocate large chunks
+	 * of contiguous memory as there's no hardware page translation to
+	 * assemble apparent contiguous memory from discontiguous pages.
+	 *
+	 * Queueing large contiguous runs of pages for batching, however,
+	 * causes the pages to actually be freed in smaller chunks.  As there
+	 * can be a significant delay between the individual batches being
+	 * recycled, this leads to the once large chunks of space being
+	 * fragmented and becoming unavailable for high-order allocations.
+	 */
+	return 0;
+#endif
 }
 
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-remove-in-kernel-strace-code.patch
frv-implement-tif_notify_resume.patch
frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch
frv-implement-new-style-ptrace.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
mutex-subsystem-synchro-test-module.patch

