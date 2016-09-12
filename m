From: akpm@linux-foundation.org
Subject: + mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
 added to -mm tree
Date: Mon, 12 Sep 2016 14:30:26 -0700
Message-ID: <57d71e72.YjQP2fWl+wNgXHfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50405 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754612AbcILVa1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 17:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@fb.com, davem@davemloft.net, hughd@google.com, joe@perches.com, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, santosh.shilimkar@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: replace some BUG_ON()s with VM_BUG_ON_PAGE()
has been added to the -mm tree.  Its filename is
     mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch

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
Subject: mm/page_io.c: replace some BUG_ON()s with VM_BUG_ON_PAGE()

So they are CONFIG_DEBUG_VM-only and more informative.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_io.c~mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page mm/page_io.c
--- a/mm/page_io.c~mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page
+++ a/mm/page_io.c
@@ -264,7 +264,7 @@ int __swap_writepage(struct page *page,
 	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	if (sis->flags & SWP_FILE) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
@@ -338,7 +338,7 @@ int swap_readpage(struct page *page)
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageUptodate(page), page);
 	if (frontswap_load(page) == 0) {
@@ -388,7 +388,8 @@ int swap_set_page_dirty(struct page *pag
 
 	if (sis->flags & SWP_FILE) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
-		BUG_ON(!PageSwapCache(page));
+
+		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 		return mapping->a_ops->set_page_dirty(page);
 	} else {
 		return __set_page_dirty_no_writeback(page);
diff -puN mm/swapfile.c~mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page mm/swapfile.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rapidio-rio_cmc-avoid-gfp_kernel-in-atomic-context.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

