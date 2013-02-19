From: akpm@linux-foundation.org
Subject: + lockdep-check-that-no-locks-held-at-freeze-time-fix.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:24:05 -0800
Message-ID: <20130220001608.5BB675A44EC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52175 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3BTAQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 19:16:12 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so733147yhr.0
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 16:16:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benchan@chromium.org, mingo@redhat.com, msb@chromium.org, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: lockdep-check-that-no-locks-held-at-freeze-time-fix
has been added to the -mm tree.  Its filename is
     lockdep-check-that-no-locks-held-at-freeze-time-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lockdep-check-that-no-locks-held-at-freeze-time-fix

ERROR: "debug_check_no_locks_held" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "debug_check_no_locks_held" [net/core/pktgen.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/xfs/xfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfsv4.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfsv3.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/nfs/nfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/lockd/lockd.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jfs/jfs.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jffs2/jffs2.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/jbd2/jbd2.ko] undefined!
ERROR: "debug_check_no_locks_held" [fs/gfs2/gfs2.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/w1/wire.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/usb/atm/ueagle-atm.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/net/irda/stir4200.ko] undefined!
ERROR: "debug_check_no_locks_held" [drivers/block/pktcdvd.ko] undefined!

testing fail :(

Cc: Ben Chan <benchan@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-fix kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-check-that-no-locks-held-at-freeze-time-fix
+++ a/kernel/lockdep.c
@@ -4115,6 +4115,7 @@ void debug_check_no_locks_held(struct ta
 	if (unlikely(task->lockdep_depth > 0))
 		print_held_locks_bug(task);
 }
+EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
 #ifdef __KERNEL__
 void debug_show_all_locks(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
goldfish-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
ocfs2-remove-kfree-redundant-null-checks-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
kernel-smpc-cleanups.patch
maintainers-remove-mark-m-hoffman-fix.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

