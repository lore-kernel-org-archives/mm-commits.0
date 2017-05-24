From: akpm@linux-foundation.org
Subject: + swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 24 May 2017 14:03:59 -0700
Message-ID: <5925f53f.s0sEJtRfMtH9VMG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031603AbdEXVEA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch

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
Subject: swap-add-block-io-poll-in-swapin-path-checkpatch-fixes

WARNING: function definition argument 'struct page *' should also have an identifier name
#60: FILE: include/linux/swap.h:334:
+extern int swap_readpage(struct page *, bool do_poll);

WARNING: line over 80 characters
#164: FILE: mm/swap_state.c:415:
+			struct vm_area_struct *vma, unsigned long addr, bool do_poll)

total: 0 errors, 2 warnings, 140 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/swap-add-block-io-poll-in-swapin-path.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap_state.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes include/linux/swap.h
--- a/include/linux/swap.h~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
+++ a/include/linux/swap.h
@@ -331,7 +331,7 @@ extern void kswapd_stop(int nid);
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 /* linux/mm/page_io.c */
-extern int swap_readpage(struct page *, bool do_poll);
+extern int swap_readpage(struct page *page, bool do_poll);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_write(struct bio *bio);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
diff -puN mm/swap_state.c~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes mm/swap_state.c
--- a/mm/swap_state.c~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
+++ a/mm/swap_state.c
@@ -412,7 +412,7 @@ struct page *__read_swap_cache_async(swp
  * the swap entry is no longer in use.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr, bool do_poll)
+		struct vm_area_struct *vma, unsigned long addr, bool do_poll)
 {
 	bool page_was_allocated;
 	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

