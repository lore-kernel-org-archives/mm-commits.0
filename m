From: akpm@linux-foundation.org
Subject: [merged] percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:54 -0800
Message-ID: <201001112017.o0BKHsvF025439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab0AKUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:30:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamalesh@linux.vnet.ibm.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     percpu: avoid calling __pcpu_ptr_to_addr(NULL)
has been removed from the -mm tree.  Its filename was
     percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu: avoid calling __pcpu_ptr_to_addr(NULL)
From: Andrew Morton <akpm@linux-foundation.org>

__pcpu_ptr_to_addr() can be overridden by the architecture and might not
behave well if passed a NULL pointer.  So avoid calling it until we have
verified that its arg is not NULL.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull mm/percpu.c
--- a/mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull
+++ a/mm/percpu.c
@@ -1271,7 +1271,7 @@ static void pcpu_reclaim(struct work_str
  */
 void free_percpu(void *ptr)
 {
-	void *addr = __pcpu_ptr_to_addr(ptr);
+	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int off;
@@ -1279,6 +1279,8 @@ void free_percpu(void *ptr)
 	if (!ptr)
 		return;
 
+	addr = __pcpu_ptr_to_addr(ptr);
+
 	spin_lock_irqsave(&pcpu_lock, flags);
 
 	chunk = pcpu_chunk_addr_search(addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

