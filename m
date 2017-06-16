From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 16 Jun 2017 12:27:11 -0700
Message-ID: <5944310f.MIOFWWlb2DLRoxNL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdFPT1W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 15:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/direct-io.c~linux-next-rejects fs/direct-io.c
--- a/fs/direct-io.c~linux-next-rejects
+++ a/fs/direct-io.c
@@ -473,13 +473,13 @@ static struct bio *dio_await_one(struct
 /*
  * Process one completed BIO.  No locks are held.
  */
-static int dio_bio_complete(struct dio *dio, struct bio *bio)
+static blk_status_t dio_bio_complete(struct dio *dio, struct bio *bio)
 {
 	struct bio_vec *bvec;
 	unsigned i;
-	int err;
+	blk_status_t err = bio->bi_status;
 
-	if (bio->bi_error) {
+	if (err) {
 		if (bio->bi_error == -EAGAIN && (bio->bi_opf & REQ_NOWAIT))
 			dio->io_error = -EAGAIN;
 		else
@@ -487,7 +487,6 @@ static int dio_bio_complete(struct dio *
 	}
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
-		err = bio->bi_error;
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-correct-the-comment-when-reclaimed-pages-exceed-the-scanned-pages-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
fs-introduce-filemap_range_has_page-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

