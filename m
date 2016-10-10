From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:43 -0700
Message-ID: <57fc1a17.Q82/hsLLswlNAQq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcJJWpo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@fb.com, davem@davemloft.net, hughd@google.com, joe@perches.com, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, santosh.shilimkar@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: replace some BUG_ON()s with VM_BUG_ON_PAGE()
has been removed from the -mm tree.  Its filename was
     mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

