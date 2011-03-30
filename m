From: akpm@linux-foundation.org
Subject: + mmap-add-alignment-for-some-variables.patch added to -mm tree
Date: Tue, 29 Mar 2011 23:15:46 -0700
Message-ID: <201103300614.p2U6EtQn028528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812Ab1C3GPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 02:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, andi@firstfloor.org, hughd@google.com, riel@redhat.com


The patch titled
     mmap: add alignment for some variables
has been added to the -mm tree.  Its filename is
     mmap-add-alignment-for-some-variables.patch

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
mmap-add-alignment-for-some-variables.patch
mmap-avoid-unnecessary-anon_vma-lock.patch
mmap-avoid-merging-cloned-vmas.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

