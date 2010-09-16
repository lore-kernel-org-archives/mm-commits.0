From: akpm@linux-foundation.org
Subject: + mm-smaps-export-mlock-information.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:38:01 -0700
Message-ID: <201009161938.o8GJc1LG009620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab0IPTiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, mpm@selenic.com


The patch titled
     mm: smaps: export mlock information
has been added to the -mm tree.  Its filename is
     mm-smaps-export-mlock-information.patch

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
Subject: mm: smaps: export mlock information
From: Nikanth Karthikesan <knikanth@suse.de>

Currently there is no way to find whether a process has locked its pages
in memory or not.  And which of the memory regions are locked in memory.

Add a new field "Locked" to export this information via the smaps file.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/task_mmu.c                 |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-smaps-export-mlock-information Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-smaps-export-mlock-information
+++ a/Documentation/filesystems/proc.txt
@@ -373,6 +373,7 @@ Referenced:          892 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
+Locked:              374 kB
 
 The first of these lines shows the same information as is displayed
 for the mapping in /proc/PID/maps. The remaining lines show the size
@@ -398,6 +399,8 @@ To clear the bits for the file mapped pa
     > echo 3 > /proc/PID/clear_refs
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The "Locked" indicates whether the mapping is locked in memory or not.
+
 
 1.2 Kernel data
 ---------------
diff -puN fs/proc/task_mmu.c~mm-smaps-export-mlock-information fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-smaps-export-mlock-information
+++ a/fs/proc/task_mmu.c
@@ -416,7 +416,8 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
-		   "MMUPageSize:    %8lu kB\n",
+		   "MMUPageSize:    %8lu kB\n"
+		   "Locked:         %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -427,7 +428,9 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
-		   vma_mmu_pagesize(vma) >> 10);
+		   vma_mmu_pagesize(vma) >> 10,
+		   (vma->vm_flags & VM_LOCKED) ?
+			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
proc-pid-smaps-after-swapout-swapin-private-dirty-mappings-are-reported-clean.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch

