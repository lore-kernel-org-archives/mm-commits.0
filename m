From: akpm@linux-foundation.org
Subject: [folded-merged]
 fix-mpage_writepage-for-pages-with-buffers-fix.patch removed from -mm tree
Date: Fri, 13 Oct 2017 15:52:20 -0700
Message-ID: <59e143a4.5rQvc81wgtNKP8fv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdJMWwV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, jthumshirn@suse.de, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-mpage_writepage-for-pages-with-buffers-fix
has been removed from the -mm tree.  Its filename was
     fix-mpage_writepage-for-pages-with-buffers-fix.patch

This patch was dropped because it was folded into fix-mpage_writepage-for-pages-with-buffers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fix-mpage_writepage-for-pages-with-buffers-fix

s/PAGE_SIZE/~0U/ per Linus and Matthew

Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/mpage.c~fix-mpage_writepage-for-pages-with-buffers-fix fs/mpage.c
--- a/fs/mpage.c~fix-mpage_writepage-for-pages-with-buffers-fix
+++ a/fs/mpage.c
@@ -475,7 +475,7 @@ static void clean_buffers(struct page *p
  */
 void clean_page_buffers(struct page *page)
 {
-	clean_buffers(page, PAGE_SIZE);
+	clean_buffers(page, ~0U);
 }
 
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
fix-mpage_writepage-for-pages-with-buffers.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

