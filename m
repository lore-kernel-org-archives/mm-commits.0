From: akpm@linux-foundation.org
Subject: - vt-fix-vc_resize-locking.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:42 -0700
Message-ID: <200806081948.m58JmgVM017528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbYFHTtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, alan@redhat.com, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     vt: fix vc_resize locking
has been removed from the -mm tree.  Its filename was
     vt-fix-vc_resize-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix vc_resize locking
From: Nick Piggin <npiggin@suse.de>

Lockdep says we can't take tasklist lock or sighand lock inside ctrl_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/char/vt.c~vt-fix-vc_resize-locking drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-vc_resize-locking
+++ a/drivers/char/vt.c
@@ -909,7 +909,7 @@ int vc_resize(struct vc_data *vc, unsign
 
 	if (vc->vc_tty) {
 		struct winsize ws, *cws = &vc->vc_tty->winsize;
-		unsigned long flags;
+		struct pid *pgrp = NULL;
 
 		memset(&ws, 0, sizeof(ws));
 		ws.ws_row = vc->vc_rows;
@@ -917,11 +917,14 @@ int vc_resize(struct vc_data *vc, unsign
 		ws.ws_ypixel = vc->vc_scan_lines;
 
 		mutex_lock(&vc->vc_tty->termios_mutex);
-		spin_lock_irqsave(&vc->vc_tty->ctrl_lock, flags);
-		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col) &&
-		    vc->vc_tty->pgrp)
+		spin_lock_irq(&vc->vc_tty->ctrl_lock);
+		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col))
+			pgrp = get_pid(vc->vc_tty->pgrp);
+		spin_unlock_irq(&vc->vc_tty->ctrl_lock);
+		if (pgrp) {
 			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
-		spin_unlock_irqrestore(&vc->vc_tty->ctrl_lock, flags);
+			put_pid(pgrp);
+		}
 		*cws = ws;
 		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

