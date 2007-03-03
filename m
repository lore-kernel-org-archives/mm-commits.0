From: akpm@linux-foundation.org
Subject: + rcu-preemptible-rcu-fix.patch added to -mm tree
Date: Fri, 02 Mar 2007 17:00:56 -0800
Message-ID: <200703030100.l2310uW5024440@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992828AbXCCBBE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 20:01:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, paulmck@linux.vnet.ibm.com


The patch titled
     PREEMPT_RCU has stricter needs: updated comment on SLAB_DESTROY_BY_RCU
has been added to the -mm tree.  Its filename is
     rcu-preemptible-rcu-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PREEMPT_RCU has stricter needs: updated comment on SLAB_DESTROY_BY_RCU
From: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~rcu-preemptible-rcu-fix mm/slab.c
--- a/mm/slab.c~rcu-preemptible-rcu-fix
+++ a/mm/slab.c
@@ -238,7 +238,7 @@ struct slab {
  * other kind of object (which our subsystem's lock might corrupt).
  *
  * rcu_read_lock before reading the address, then rcu_read_unlock after
- * taking the spinlock within the structure expected at that address.
+ * releasing the spinlock within the structure expected at that address.
  *
  * We assume struct slab_rcu can overlay struct slab when destroying.
  */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
shmem-and-simple-const-super_operations.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
