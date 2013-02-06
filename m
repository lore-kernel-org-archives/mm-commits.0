From: akpm@linux-foundation.org
Subject: + drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch added to -mm tree
Date: Tue, 05 Feb 2013 16:00:37 -0800
Message-ID: <20130206000037.A22EA31C257@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49563 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3BFAAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 19:00:38 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so92132qen.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 16:00:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agk@redhat.com, neilb@suse.de


The patch titled
     Subject: drivers/md/persistent-data/dm-transaction-manager.c: rename HASH_SIZE
has been added to the -mm tree.  Its filename is
     drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch

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
Subject: drivers/md/persistent-data/dm-transaction-manager.c: rename HASH_SIZE

drivers/md/persistent-data/dm-transaction-manager.c:28:1: warning: "HASH_SIZE" redefined
In file included from include/linux/elevator.h:5,
                 from include/linux/blkdev.h:216,
                 from drivers/md/persistent-data/dm-block-manager.h:11,
                 from drivers/md/persistent-data/dm-transaction-manager.h:10,
                 from drivers/md/persistent-data/dm-transaction-manager.c:6:
include/linux/hashtable.h:22:1: warning: this is the location of the previous definition
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/persistent-data/dm-transaction-manager.c |   14 +++++-----
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/md/persistent-data/dm-transaction-manager.c~drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size drivers/md/persistent-data/dm-transaction-manager.c
--- a/drivers/md/persistent-data/dm-transaction-manager.c~drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size
+++ a/drivers/md/persistent-data/dm-transaction-manager.c
@@ -25,8 +25,8 @@ struct shadow_info {
 /*
  * It would be nice if we scaled with the size of transaction.
  */
-#define HASH_SIZE 256
-#define HASH_MASK (HASH_SIZE - 1)
+#define DM_HASH_SIZE 256
+#define DM_HASH_MASK (DM_HASH_SIZE - 1)
 
 struct dm_transaction_manager {
 	int is_clone;
@@ -36,7 +36,7 @@ struct dm_transaction_manager {
 	struct dm_space_map *sm;
 
 	spinlock_t lock;
-	struct hlist_head buckets[HASH_SIZE];
+	struct hlist_head buckets[DM_HASH_SIZE];
 };
 
 /*----------------------------------------------------------------*/
@@ -44,7 +44,7 @@ struct dm_transaction_manager {
 static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
 {
 	int r = 0;
-	unsigned bucket = dm_hash_block(b, HASH_MASK);
+	unsigned bucket = dm_hash_block(b, DM_HASH_MASK);
 	struct shadow_info *si;
 	struct hlist_node *n;
 
@@ -71,7 +71,7 @@ static void insert_shadow(struct dm_tran
 	si = kmalloc(sizeof(*si), GFP_NOIO);
 	if (si) {
 		si->where = b;
-		bucket = dm_hash_block(b, HASH_MASK);
+		bucket = dm_hash_block(b, DM_HASH_MASK);
 		spin_lock(&tm->lock);
 		hlist_add_head(&si->hlist, tm->buckets + bucket);
 		spin_unlock(&tm->lock);
@@ -86,7 +86,7 @@ static void wipe_shadow_table(struct dm_
 	int i;
 
 	spin_lock(&tm->lock);
-	for (i = 0; i < HASH_SIZE; i++) {
+	for (i = 0; i < DM_HASH_SIZE; i++) {
 		bucket = tm->buckets + i;
 		hlist_for_each_entry_safe(si, n, tmp, bucket, hlist)
 			kfree(si);
@@ -115,7 +115,7 @@ static struct dm_transaction_manager *dm
 	tm->sm = sm;
 
 	spin_lock_init(&tm->lock);
-	for (i = 0; i < HASH_SIZE; i++)
+	for (i = 0; i < DM_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(tm->buckets + i);
 
 	return tm;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
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
mm-break-circular-include-from-linux-mmzoneh-fix.patch
mm-break-circular-include-from-linux-mmzoneh-fix-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
printk-avoid-softlockups-in-console_unlock-fix.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
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
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch

