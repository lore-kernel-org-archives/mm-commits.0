From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Mon, 11 Feb 2013 13:48:24 -0800
Message-ID: <20130211214824.C919A5A40A5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:43146 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3BKVs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 16:48:26 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so1235277iad.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 13:48:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, sasha.levin@oracle.com


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch

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
Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix drivers/net/ethernet/mellanox/mlx4/en_netdev.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix
+++ a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -573,13 +573,13 @@ static void mlx4_en_put_qp(struct mlx4_e
 
 	if (dev->caps.steering_mode != MLX4_STEERING_MODE_A0) {
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 
 		mac_hash = priv->dev->dev_addr[MLX4_EN_MAC_HASH_IDX];
 		bucket = &priv->mac_hash[mac_hash];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac,
 						    priv->dev->dev_addr)) {
 				en_dbg(DRV, priv, "Releasing qp: port %d, MAC %pM, qpn %d\n",
@@ -608,11 +608,11 @@ static int mlx4_en_replace_mac(struct ml
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		u64 prev_mac_u64 = mlx4_en_mac_to_u64(prev_mac);
 
 		bucket = &priv->mac_hash[prev_mac[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, prev_mac)) {
 				mlx4_en_uc_steer_release(priv, entry->mac,
 							 qpn, entry->reg_id);
@@ -1018,7 +1018,7 @@ static void mlx4_en_do_uc_filter(struct 
 {
 	struct netdev_hw_addr *ha;
 	struct mlx4_mac_entry *entry;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	bool found;
 	u64 mac;
 	int err = 0;
@@ -1034,7 +1034,7 @@ static void mlx4_en_do_uc_filter(struct 
 	/* find what to remove */
 	for (i = 0; i < MLX4_EN_MAC_HASH_SIZE; ++i) {
 		bucket = &priv->mac_hash[i];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			found = false;
 			netdev_for_each_uc_addr(ha, dev) {
 				if (ether_addr_equal_64bits(entry->mac,
@@ -1077,7 +1077,7 @@ static void mlx4_en_do_uc_filter(struct 
 	netdev_for_each_uc_addr(ha, dev) {
 		found = false;
 		bucket = &priv->mac_hash[ha->addr[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry(entry, n, bucket, hlist) {
+		hlist_for_each_entry(entry, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, ha->addr)) {
 				found = true;
 				break;
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
kernel-smpc-cleanups.patch
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
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
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
tools-testing-selftests-makefile-rearrange-targets.patch
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

