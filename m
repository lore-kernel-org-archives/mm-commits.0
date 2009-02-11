From: akpm@linux-foundation.org
Subject: + mm-dont-call-mark_page_accessed-in-do_swap_page.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:12:18 -0800
Message-ID: <200902112312.n1BNCISe015975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbZBKXNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:13:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: don't call mark_page_accessed() in do_swap_page()
has been added to the -mm tree.  Its filename is
     mm-dont-call-mark_page_accessed-in-do_swap_page.patch

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
Subject: mm: don't call mark_page_accessed() in do_swap_page()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit bf3f3bc5e734706730c12a323f9b2068052aa1f0 (mm: don't
mark_page_accessed in fault path) only remove the mark_page_accessed() in
filemap_fault().

Therefore, swap-backed pages and file-backed pages have inconsistent
behavior.  mark_page_accessed() should be removed from do_swap_page().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory.c~mm-dont-call-mark_page_accessed-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-dont-call-mark_page_accessed-in-do_swap_page
+++ a/mm/memory.c
@@ -2433,8 +2433,6 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
-	mark_page_accessed(page);
-
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-fix-mlocked-page-counter-mismatch.patch
cgroups-add-li-zefan-as-a-maintainer.patch
vmalloc-add-__get_vm_area_caller.patch
vmalloc-add-__get_vm_area_caller-checkpatch-fixes.patch
linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-form-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

