From: akpm@linux-foundation.org
Subject: + ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch added to -mm tree
Date: Wed, 01 Dec 2010 16:10:13 -0800
Message-ID: <201012020010.oB20ADO4019999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab0LBAKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 19:10:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, andi@firstfloor.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix
has been added to the -mm tree.  Its filename is
     ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch

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
Subject: ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix
From: Andrew Morton <akpm@linux-foundation.org>

update comment, from Hugh

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix mm/ksm.c
--- a/mm/ksm.c~ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix
+++ a/mm/ksm.c
@@ -1724,8 +1724,11 @@ static int ksm_memory_callback(struct no
 		/*
 		 * Keep it very simple for now: just lock out ksmd and
 		 * MADV_UNMERGEABLE while any memory is going offline.
-		 * Mutex_lock_nested() is necessary to tell that
-		 * ksm_thread_mutex is not unlocked here intentionally.
+		 * mutex_lock_nested() is necessary because lockdep was alarmed
+		 * that here we take ksm_thread_mutex inside notifier chain
+		 * mutex, and later take notifier chain mutex inside
+		 * ksm_thread_mutex to unlock it.   But that's safe because both
+		 * are inside mem_hotplug_mutex.
 		 */
 		mutex_lock_nested(&ksm_thread_mutex, SINGLE_DEPTH_NESTING);
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
documentation-filesystems-vfstxt-fix-repeasepage-description.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

