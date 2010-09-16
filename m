From: akpm@linux-foundation.org
Subject: + proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:39:52 -0700
Message-ID: <201009161939.o8GJdqoh009673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016Ab0IPTkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com


The patch titled
     /proc/pid/smaps: export amount of anonymous memory in a mapping
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch

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
Subject: /proc/pid/smaps: export amount of anonymous memory in a mapping
From: Nikanth Karthikesan <knikanth@suse.de>

Export the number of anonymous pages in a mapping via smaps.

Even the private pages in a mapping backed by a file, would be marked as
anonymous, when they are modified. Export this information to user-space via
smaps.

Exporting this count will help gdb to make a better decision on which
areas need to be dumped in its coredump; and should be useful to others
studying the memory usage of a process.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/task_mmu.c~proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping
+++ a/fs/proc/task_mmu.c
@@ -327,6 +327,7 @@ struct mem_size_stats {
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long anonymous;
 	unsigned long swap;
 	u64 pss;
 };
@@ -357,6 +358,9 @@ static int smaps_pte_range(pmd_t *pmd, u
 		if (!page)
 			continue;
 
+		if (PageAnon(page))
+			mss->anonymous += PAGE_SIZE;
+
 		mss->resident += PAGE_SIZE;
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
@@ -410,6 +414,7 @@ static int show_smap(struct seq_file *m,
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
+		   "Anonymous:      %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n",
@@ -421,6 +426,7 @@ static int show_smap(struct seq_file *m,
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
+		   mss.anonymous >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10);
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch

