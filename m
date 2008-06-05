From: akpm@linux-foundation.org
Subject: + mm-readahead-scan-lockless.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:34:58 -0700
Message-ID: <200806052034.m55KYwwn028487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbYFEUfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     mm: readahead scan lockless
has been added to the -mm tree.  Its filename is
     mm-readahead-scan-lockless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: readahead scan lockless
From: Nick Piggin <npiggin@suse.de>

radix_tree_next_hole() is implemented as a series of radix_tree_lookup()s.
 So it can be called locklessly, under rcu_read_lock().

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~mm-readahead-scan-lockless mm/readahead.c
--- a/mm/readahead.c~mm-readahead-scan-lockless
+++ a/mm/readahead.c
@@ -382,9 +382,9 @@ ondemand_readahead(struct address_space 
 	if (hit_readahead_marker) {
 		pgoff_t start;
 
-		read_lock_irq(&mapping->tree_lock);
-		start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);
-		read_unlock_irq(&mapping->tree_lock);
+		rcu_read_lock();
+		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		rcu_read_unlock();
 
 		if (!start || start - offset > max)
 			return 0;
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
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

