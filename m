From: akpm@linux-foundation.org
Subject: + swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch added to -mm tree
Date: Tue, 05 Feb 2013 15:33:42 -0800
Message-ID: <20130205233343.587E731C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:33288 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3BEXdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 18:33:44 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so88845qcr.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 15:33:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, Valdis.Kletnieks@vt.edu, shli@kernel.org


The patch titled
     Subject: mm: Get rid of lockdep whinge on sys_swapon
has been added to the -mm tree.  Its filename is
     swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: Get rid of lockdep whinge on sys_swapon

[1] forgot to initialize spin_lock so lockdep is whingeing
about it. This patch fixes it.

[1] 0f181e0e4, swap: add per-partition lock for swapfile

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/swapfile.c~swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix
+++ a/mm/swapfile.c
@@ -1856,6 +1856,7 @@ static struct swap_info_struct *alloc_sw
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
+	spin_lock_init(&p->lock);
 
 	return p;
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-remove-migrate_isolate-check-in-hotpath.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix-fix.patch
mm-use-up-free-swap-space-before-reaching-oom-kill.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

