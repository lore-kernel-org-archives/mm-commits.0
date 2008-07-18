From: akpm@linux-foundation.org
Subject: - ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:00:38 -0700
Message-ID: <200807182300.m6IN0c0s003138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbYGRXBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, alan@redhat.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     ia64/hp/sim/simserial.c adapt to new tty framework
has been removed from the -mm tree.  Its filename was
     ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64/hp/sim/simserial.c adapt to new tty framework
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently, Alan Cox made cleanup tty widely.  But unfortunately it cause
simserial build error.  This patch fixes it.

  arch/ia64/hp/sim/simserial.c: In function 'rs_flush_buffer':
  arch/ia64/hp/sim/simserial.c:357: error: 'struct tty_ldisc' has no member named 'write_wakeup'
  arch/ia64/hp/sim/simserial.c:358: error: 'struct tty_ldisc' has no member named 'write_wakeup'
  arch/ia64/hp/sim/simserial.c: In function 'rs_close':
  arch/ia64/hp/sim/simserial.c:628: error: 'struct tty_ldisc' has no member named 'flush_buffer'
  arch/ia64/hp/sim/simserial.c:628: error: 'struct tty_ldisc' has no member named 'flush_buffer'
  arch/ia64/hp/sim/simserial.c: At top level:
  arch/ia64/hp/sim/simserial.c:958: warning: initialization from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alan Cox <alan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simserial.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/ia64/hp/sim/simserial.c~ia64-hp-sim-simserialc-adapt-to-new-tty-framework arch/ia64/hp/sim/simserial.c
--- a/arch/ia64/hp/sim/simserial.c~ia64-hp-sim-simserialc-adapt-to-new-tty-framework
+++ a/arch/ia64/hp/sim/simserial.c
@@ -354,8 +354,8 @@ static void rs_flush_buffer(struct tty_s
 	wake_up_interruptible(&tty->write_wait);
 
 	if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-	    tty->ldisc.write_wakeup)
-		(tty->ldisc.write_wakeup)(tty);
+	    tty->ldisc.ops->write_wakeup)
+		(tty->ldisc.ops->write_wakeup)(tty);
 }
 
 /*
@@ -407,8 +407,9 @@ static void rs_unthrottle(struct tty_str
 /*
  * rs_break() --- routine which turns the break handling on or off
  */
-static void rs_break(struct tty_struct *tty, int break_state)
+static int rs_break(struct tty_struct *tty, int break_state)
 {
+	return 0;
 }
 
 static int rs_ioctl(struct tty_struct *tty, struct file * file,
@@ -625,7 +626,8 @@ static void rs_close(struct tty_struct *
 	shutdown(info);
 	if (tty->ops->flush_buffer)
 		tty->ops->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
+	if (tty->ldisc.ops->flush_buffer)
+		tty->ldisc.ops->flush_buffer(tty);
 	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

adapt-drivers-base-topologyc-to-new-sysfs-api.patch
ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch
ahci-use-correct-type-for-cpu-flags.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm-fix.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

