From: akpm@linux-foundation.org
Subject: [folded] do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix.patch removed from -mm tree
Date: Wed, 01 Dec 2010 17:11:06 -0800
Message-ID: <201012020111.oB21B7Wh022575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab0LBBLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 20:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nelhage@ksplice.com, mm-commits@vger.kernel.org


The patch titled
     do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix
has been removed from the -mm tree.  Its filename was
     do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix.patch

This patch was dropped because it was folded into do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix kernel/exit.c
--- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds-fix
+++ a/kernel/exit.c
@@ -917,8 +917,9 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * If do_exit is called because this processes oopsed, it's possible
 	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
-	 * continuing. This is relevant at least for clearing clear_child_tid in
-	 * mm_release.
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
 	 */
 	set_fs(USER_DS);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
documentation-filesystems-vfstxt-fix-repeasepage-description.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch
do_exit-make-sure-we-run-with-get_fs-==-user_ds.patch
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

