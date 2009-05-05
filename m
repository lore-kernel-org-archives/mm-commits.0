From: akpm@linux-foundation.org
Subject: + nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch added to -mm tree
Date: Tue, 05 May 2009 15:16:43 -0700
Message-ID: <200905052216.n45MGhSL016450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZEEWTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, lanttor.guo@freescale.com


The patch titled
     nommu: clamp zone_batchsize() to 0 under NOMMU conditions
has been added to the -mm tree.  Its filename is
     nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2682,6 +2682,7 @@ static void __meminit zone_init_free_lis
 
 static int zone_batchsize(struct zone *zone)
 {
+#ifdef CONFIG_MMU
 	int batch;
 
 	/*
@@ -2710,6 +2711,23 @@ static int zone_batchsize(struct zone *z
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
mm-use-roundown_pow_of_two-in-zone_batchsize.patch
nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch
nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable.patch
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

