From: akpm@linux-foundation.org
Subject: + swap_info-include-first_swap_extent-fix-fix.patch added to -mm tree
Date: Tue, 03 Nov 2009 14:34:50 -0800
Message-ID: <200911032234.nA3MYoct006952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbZKCWfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 17:35:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     fix to swap_info-include-first_swap_extent-fix.patch
has been added to the -mm tree.  Its filename is
     swap_info-include-first_swap_extent-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix to swap_info-include-first_swap_extent-fix.patch
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Sorry, just noticed what the diff contexts don't show: Jiri's patch is
initializing p->first_swap_extent.list at a point before p has been
decided - we may kfree that newly allocated p and go on to reuse an
existing free entry for p.

Now, the patch is not actually wrong: an existing free entry will have a
good empty first_swap_extent.list; but it looks suspicious, it seems
strange to initialize a field in something we're about to kfree, and I'd
rather we put that initialization back to where it was in 2.6.32.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/swapfile.c~swap_info-include-first_swap_extent-fix-fix mm/swapfile.c
--- a/mm/swapfile.c~swap_info-include-first_swap_extent-fix-fix
+++ a/mm/swapfile.c
@@ -1817,7 +1817,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		kfree(p);
 		goto out;
 	}
-	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
@@ -1836,6 +1835,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * would be relying on p->type to remain valid.
 		 */
 	}
+	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
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

