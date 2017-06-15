From: akpm@linux-foundation.org
Subject: + fs-introduce-filemap_range_has_page-fix.patch added to -mm tree
Date: Thu, 15 Jun 2017 15:01:38 -0700
Message-ID: <594303c2.NnRNHY2nBOF83f6N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdFOWBj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, rgoldwyn@suse.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-introduce-filemap_range_has_page-fix
has been added to the -mm tree.  Its filename is
     fs-introduce-filemap_range_has_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-introduce-filemap_range_has_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-introduce-filemap_range_has_page-fix.patch

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
Subject: fs-introduce-filemap_range_has_page-fix

make filemap_range_has_page return bool, fix kerneldoc

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 mm/filemap.c       |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/fs.h~fs-introduce-filemap_range_has_page-fix include/linux/fs.h
--- a/include/linux/fs.h~fs-introduce-filemap_range_has_page-fix
+++ a/include/linux/fs.h
@@ -2517,8 +2517,8 @@ extern int filemap_fdatawait(struct addr
 extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
-extern int filemap_range_has_page(struct address_space *, loff_t lstart,
-				  loff_t lend);
+extern bool filemap_range_has_page(struct address_space *, loff_t lstart,
+				   loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
diff -puN mm/filemap.c~fs-introduce-filemap_range_has_page-fix mm/filemap.c
--- a/mm/filemap.c~fs-introduce-filemap_range_has_page-fix
+++ a/mm/filemap.c
@@ -378,31 +378,30 @@ EXPORT_SYMBOL(filemap_flush);
 
 /**
  * filemap_range_has_page - check if a page exists in range.
- * @mapping:           address space structure to wait for
+ * @mapping:           address space within which to check
  * @start_byte:        offset in bytes where the range starts
  * @end_byte:          offset in bytes where the range ends (inclusive)
  *
  * Find at least one page in the range supplied, usually used to check if
  * direct writing in this range will trigger a writeback.
  */
-int filemap_range_has_page(struct address_space *mapping,
-			   loff_t start_byte, loff_t end_byte)
+bool filemap_range_has_page(struct address_space *mapping,
+			    loff_t start_byte, loff_t end_byte)
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
 	struct pagevec pvec;
-	int ret;
+	bool ret;
 
 	if (end_byte < start_byte)
-		return 0;
+		return false;
 
 	if (mapping->nrpages == 0)
-		return 0;
+		return false;
 
 	pagevec_init(&pvec, 0);
-	ret = pagevec_lookup(&pvec, mapping, index, 1);
-	if (!ret)
-		return 0;
+	if (!pagevec_lookup(&pvec, mapping, index, 1))
+		return false;
 	ret = (pvec.pages[0]->index <= end);
 	pagevec_release(&pvec);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
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
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

