From: akpm@linux-foundation.org
Subject: + fix-mpage_writepage-for-pages-with-buffers-fix.patch added to
 -mm tree
Date: Wed, 11 Oct 2017 16:00:30 -0700
Message-ID: <59dea28e.o+C0E50x6A+83kE/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdJKXAb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 19:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, jthumshirn@suse.de, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-mpage_writepage-for-pages-with-buffers-fix
has been added to the -mm tree.  Its filename is
     fix-mpage_writepage-for-pages-with-buffers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-mpage_writepage-for-pages-with-buffers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-mpage_writepage-for-pages-with-buffers-fix.patch

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
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
fix-mpage_writepage-for-pages-with-buffers-fix.patch
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
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

