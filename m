From: akpm@linux-foundation.org
Subject: + mlock-mlocked-pages-are-unevictable-fix-99.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:10:55 -0700
Message-ID: <200807010710.m617At0q014306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbYGAHMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mpm@selenic.com, npiggin@suse.de, riel@redhat.com


The patch titled
     unevictable mlocked pages: initialize mm member of munlock mm_walk structure
has been added to the -mm tree.  Its filename is
     mlock-mlocked-pages-are-unevictable-fix-99.patch

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
Subject: unevictable mlocked pages: initialize mm member of munlock mm_walk structure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Incremental fix for: mlock-mlocked-pages-are-unevictable-fix.patch

Initialize the 'mm' member of the mm_walk structure, else the
page table walk doesn't occur, and mlocked pages will not be
munlocked.  This is visible in the vmstats:

	noreclaim_pgs_munlocked - should equal noreclaim_pgs_mlocked
	  less (nr_mlock + noreclaim_pgs_cleared), but is always zero
	  [munlock_vma_page() never called]

	noreclaim_pgs_mlockfreed - should be zero [for debug only],
	  but == noreclaim_pgs_mlocked - (nr_mlock + noreclaim_pgs_cleared)

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mlock.c~mlock-mlocked-pages-are-unevictable-fix-99 mm/mlock.c
--- a/mm/mlock.c~mlock-mlocked-pages-are-unevictable-fix-99
+++ a/mm/mlock.c
@@ -278,6 +278,8 @@ static void __munlock_vma_pages_range(st
 	VM_BUG_ON(start < vma->vm_start);
 	VM_BUG_ON(end > vma->vm_end);
 
+	munlock_page_walk.mm = mm;
+
 	lru_add_drain_all();	/* push cached pages to LRU */
 	walk_page_range(start, end, &munlock_page_walk);
 	lru_add_drain_all();	/* to update stats */
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix-99.patch

