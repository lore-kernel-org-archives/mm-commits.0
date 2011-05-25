From: akpm@linux-foundation.org
Subject: [merged] mmap-add-alignment-for-some-variables.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:11 -0700
Message-ID: <201105252025.p4PKPYLq014402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab1EYU0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, andi@firstfloor.org, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mmap: add alignment for some variables
has been removed from the -mm tree.  Its filename was
     mmap-add-alignment-for-some-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: add alignment for some variables
From: Shaohua Li <shaohua.li@intel.com>

Make some variables have correct alignment/section to avoid cache issue. 
In a workload which heavily does mmap/munmap, the variables will be used
frequently.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mmap-add-alignment-for-some-variables mm/mmap.c
--- a/mm/mmap.c~mmap-add-alignment-for-some-variables
+++ a/mm/mmap.c
@@ -84,10 +84,14 @@ pgprot_t vm_get_page_prot(unsigned long 
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 
-int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
-int sysctl_overcommit_ratio = 50;	/* default is 50% */
+int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
+int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-struct percpu_counter vm_committed_as;
+/*
+ * Make sure vm_committed_as in one cacheline and not cacheline shared with
+ * other variables. It can be updated by several CPUs frequently.
+ */
+struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
 /*
  * Check that a process has enough memory to allocate a new virtual
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

