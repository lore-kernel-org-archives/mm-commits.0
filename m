From: akpm@linux-foundation.org
Subject: + block-return-on-congested-block-device-fix.patch added to -mm
 tree
Date: Fri, 16 Jun 2017 12:28:21 -0700
Message-ID: <59443155.dAGFsWzZbzZJ8ncJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbdFPT21 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 15:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de, rgoldwyn@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block-return-on-congested-block-device-fix
has been added to the -mm tree.  Its filename is
     block-return-on-congested-block-device-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-return-on-congested-block-device-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-return-on-congested-block-device-fix.patch

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
Subject: block-return-on-congested-block-device-fix

bi_error was renamed

Cc: Christoph Hellwig <hch@lst.de>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bio.h~block-return-on-congested-block-device-fix include/linux/bio.h
--- a/include/linux/bio.h~block-return-on-congested-block-device-fix
+++ a/include/linux/bio.h
@@ -420,7 +420,7 @@ static inline void bio_io_error(struct b
 
 static inline void bio_wouldblock_error(struct bio *bio)
 {
-	bio->bi_error = -EAGAIN;
+	bio->bi_status = -EAGAIN;
 	bio_endio(bio);
 }
 
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
block-return-on-congested-block-device-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

