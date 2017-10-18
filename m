From: akpm@linux-foundation.org
Subject: +
 mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch added to -mm tree
Date: Wed, 18 Oct 2017 15:02:24 -0700
Message-ID: <59e7cf70.t9tM6jpMjGrLsBD9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdJRWCZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-batch-radix-tree-operations-when-truncating-pages-fix-fix
has been added to the -mm tree.  Its filename is
     mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch

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
Subject: mm-batch-radix-tree-operations-when-truncating-pages-fix-fix

move struct pagevec forward declaration to top-of-file

To avoid possible duplication in the future.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-batch-radix-tree-operations-when-truncating-pages-fix-fix
+++ a/include/linux/pagemap.h
@@ -15,6 +15,8 @@
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
 
+struct pagevec;
+
 /*
  * Bits in mapping->flags.
  */
@@ -616,8 +618,6 @@ static inline int fault_in_pages_readabl
 	return 0;
 }
 
-struct pagevec;
-
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-deferred_init_memmap-improvements-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

