From: akpm@linux-foundation.org
Subject: + tmpfs-change-final-i_blocks-bug-to-warning.patch added to -mm tree
Date: Tue, 06 Nov 2012 12:24:58 -0800
Message-ID: <20121106202459.135065C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57014 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFUZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 15:25:01 -0500
Received: by mail-ea0-f202.google.com with SMTP id q10so61530eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 12:25:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, stable@vger.kernel.org


The patch titled
     Subject: tmpfs: change final i_blocks BUG to WARNING
has been added to the -mm tree.  Its filename is
     tmpfs-change-final-i_blocks-bug-to-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: change final i_blocks BUG to WARNING

Under a particular load on one machine, I have hit shmem_evict_inode()'s
BUG_ON(inode->i_blocks), enough times to narrow it down to a particular
race between swapout and eviction.

It comes from the "if (freed > 0)" asymmetry in shmem_recalc_inode(), and
the lack of coherent locking between mapping's nrpages and shmem's swapped
count.  There's a window in shmem_writepage(), between lowering nrpages in
shmem_delete_from_page_cache() and then raising swapped count, when the
freed count appears to be +1 when it should be 0, and then the asymmetry
stops it from being corrected with -1 before hitting the BUG.

One answer is coherent locking: using tree_lock throughout, without
info->lock; reasonable, but the raw_spin_lock in percpu_counter_add() on
used_blocks makes that messier than expected.  Another answer may be a
further effort to eliminate the weird shmem_recalc_inode() altogether, but
previous attempts at that failed.

So far undecided, but for now change the BUG_ON to WARN_ON: in usual
circumstances it remains a useful consistency check.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-change-final-i_blocks-bug-to-warning mm/shmem.c
--- a/mm/shmem.c~tmpfs-change-final-i_blocks-bug-to-warning
+++ a/mm/shmem.c
@@ -643,7 +643,7 @@ static void shmem_evict_inode(struct ino
 		kfree(info->symlink);
 
 	simple_xattrs_free(&info->xattrs);
-	BUG_ON(inode->i_blocks);
+	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	clear_inode(inode);
 }
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
tmpfs-fix-shmem_getpage_gfp-vm_bug_on.patch
tmpfs-change-final-i_blocks-bug-to-warning.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

