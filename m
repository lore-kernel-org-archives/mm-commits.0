From: akpm@linux-foundation.org
Subject: [merged] drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:47:58 -0800
Message-ID: <20130225204800.87BF331C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64157 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3BYUsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:04 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so346169ggn.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agk@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/persistent-data/dm-transaction-manager.c: rename HASH_SIZE
has been removed from the -mm tree.  Its filename was
     drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
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
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
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
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

