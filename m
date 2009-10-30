From: akpm@linux-foundation.org
Subject: [merged] hwpoison-fix-proc-meminfo-alignment.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:53:24 -0700
Message-ID: <200910302053.n9UKrOm1017674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806AbZJ3Ux4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     hwpoison: fix/proc/meminfo alignment
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-proc-meminfo-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwpoison: fix/proc/meminfo alignment
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Given such a long name, the kB count in /proc/meminfo's HardwareCorrupted
line is being shown too far right (it does align with x86_64's VmallocChunk
above, but I hope nobody will ever have that much corrupted!).  Align it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/meminfo.c~hwpoison-fix-proc-meminfo-alignment fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~hwpoison-fix-proc-meminfo-alignment
+++ a/fs/proc/meminfo.c
@@ -99,7 +99,7 @@ static int meminfo_proc_show(struct seq_
 		"VmallocUsed:    %8lu kB\n"
 		"VmallocChunk:   %8lu kB\n"
 #ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %8lu kB\n"
+		"HardwareCorrupted: %5lu kB\n"
 #endif
 		,
 		K(i.totalram),
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

