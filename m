From: akpm@linux-foundation.org
Subject: + mm-ifdef-quicklists-in-proc-meminfo.patch added to -mm tree
Date: Mon, 08 Sep 2008 17:05:58 -0700
Message-ID: <200809090005.m8905wqp017037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbYIIAGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 20:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: ifdef Quicklists in /proc/meminfo
has been added to the -mm tree.  Its filename is
     mm-ifdef-quicklists-in-proc-meminfo.patch

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
Subject: mm: ifdef Quicklists in /proc/meminfo
From: Hugh Dickins <hugh@veritas.com>

A "Quicklists:          0 kB" line has just started appearing in
/proc/meminfo, but most architectures (including x86) don't have
them configured: may we please #ifdef it, like the highmem lines?

And those architectures which do have quicklists configured are
using them for page tables: so let's place it next to PageTables.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-ifdef-quicklists-in-proc-meminfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-ifdef-quicklists-in-proc-meminfo
+++ a/fs/proc/proc_misc.c
@@ -183,6 +183,9 @@ static int meminfo_read_proc(char *page,
 		"SReclaimable: %8lu kB\n"
 		"SUnreclaim:   %8lu kB\n"
 		"PageTables:   %8lu kB\n"
+#ifdef CONFIG_QUICKLIST
+		"Quicklists:   %8lu kB\n"
+#endif
 		"NFS_Unstable: %8lu kB\n"
 		"Bounce:       %8lu kB\n"
 		"WritebackTmp: %8lu kB\n"
@@ -190,8 +193,7 @@ static int meminfo_read_proc(char *page,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n"
-		"Quicklists:   %8lu kB\n",
+		"VmallocChunk: %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
@@ -216,6 +218,9 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_QUICKLIST
+		K(quicklist_total_size()),
+#endif
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
 		K(global_page_state(NR_WRITEBACK_TEMP)),
@@ -223,8 +228,7 @@ static int meminfo_read_proc(char *page,
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
-		vmi.largest_chunk >> 10,
-		K(quicklist_total_size())
+		vmi.largest_chunk >> 10
 		);
 
 		len += hugetlb_report_meminfo(page + len);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-ifdef-quicklists-in-proc-meminfo.patch
git-powerpc-merge.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
mm-owner-fix-race-between-swap-and-exit-fix-fix.patch
hugetlb-handle-updating-of-accessed-and-dirty-in-hugetlb_fault.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-mm-rmapc-anon_vma_cachep-static.patch
prio_tree-debugging-patch.patch

