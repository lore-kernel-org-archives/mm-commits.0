From: akpm@linux-foundation.org
Subject: [merged] mm-smaps-export-mlock-information.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:47 -0800
Message-ID: <201101142247.p0EMlbOr005018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     mm: smaps: export mlock information
has been removed from the -mm tree.  Its filename was
     mm-smaps-export-mlock-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -375,6 +375,7 @@ Anonymous:             0 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
+Locked:              374 kB
 
 The first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
@@ -670,6 +671,8 @@ varies by architecture and compile optio
 
 > cat /proc/meminfo
 
+The "Locked" indicates whether the mapping is locked in memory or not.
+
 
 MemTotal:     16344972 kB
 MemFree:      13634064 kB
diff -puN fs/proc/task_mmu.c~mm-smaps-export-mlock-information fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-smaps-export-mlock-information
+++ a/fs/proc/task_mmu.c
@@ -418,7 +418,8 @@ static int show_smap(struct seq_file *m,
 		   "Anonymous:      %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
-		   "MMUPageSize:    %8lu kB\n",
+		   "MMUPageSize:    %8lu kB\n"
+		   "Locked:         %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -430,7 +431,9 @@ static int show_smap(struct seq_file *m,
 		   mss.anonymous >> 10,
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

origin.patch
linux-next.patch

