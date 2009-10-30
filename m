From: akpm@linux-foundation.org
Subject: [merged] hwpoison-fix-oops-on-ksm-pages.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:53:19 -0700
Message-ID: <200910302053.n9UKrJnw017422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932792AbZJ3Uxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     hwpoison: fix oops on ksm pages
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-oops-on-ksm-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwpoison: fix oops on ksm pages
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Memory failure on a KSM page currently oopses on its NULL anon_vma in
page_lock_anon_vma(): that may not be much worse than the consequence of
ignoring it, but it is better to be consistent with how ZERO_PAGE and
hugetlb pages and other awkward cases are treated.  Just skip it.

We could fix it for 2.6.32 at the KSM end, by putting a dummy anon_vma
pointer in there; but that would get harder next time, when KSM will put a
pointer to something else there (and I'm not currently planning to do any
work to open that up to memory_failure).  So I would prefer this simple
PageKsm test, until the other exceptions are handled.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memory-failure.c~hwpoison-fix-oops-on-ksm-pages mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-oops-on-ksm-pages
+++ a/mm/memory-failure.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/sched.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
@@ -661,7 +662,7 @@ static void hwpoison_user_mappings(struc
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p))
+	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
 		return;
 
 	if (!PageLRU(p))
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

