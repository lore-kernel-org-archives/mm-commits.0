From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 15 Jun 2017 16:27:10 -0700
Message-ID: <594317ce.iqJyAtRKuwSeHoli%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdFOX1L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
fs-introduce-filemap_range_has_page-fix.patch
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
lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

