From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch added to
 -mm tree
Date: Thu, 02 Feb 2017 15:05:59 -0800
Message-ID: <5893bb57.DPJb3ES6ANOkMfvC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58090 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdBBXGS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 18:06:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix

This breaks compilation on nommu configs.
mm/nommu.c:1201:15: error: conflicting types for 'do_mmap'
 unsigned long do_mmap(struct file *file,
               ^
In file included from mm/nommu.c:19:0:
./include/linux/mm.h:2089:22: note: previous declaration of 'do_mmap' was here
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
                      ^
mm/nommu.c:1580:5: error: conflicting types for 'do_munmap'
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
     ^
In file included from mm/nommu.c:19:0:
./include/linux/mm.h:2093:12: note: previous declaration of 'do_munmap' was here
 extern int do_munmap(struct mm_struct *, unsigned long, size_t,
            ^
make[1]: *** [mm/nommu.o] Error 1

CONFIG_USERFAULTFD depends on CONFIG_MMU so I guess we are OK to just ignore the
argument.

Link: http://lkml.kernel.org/r/20170202091503.GA22823@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix mm/nommu.c
--- a/mm/nommu.c~userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix
+++ a/mm/nommu.c
@@ -1205,7 +1205,8 @@ unsigned long do_mmap(struct file *file,
 			unsigned long flags,
 			vm_flags_t vm_flags,
 			unsigned long pgoff,
-			unsigned long *populate)
+			unsigned long *populate,
+			struct list_head *uf_unused)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
@@ -1577,7 +1578,7 @@ static int shrink_vma(struct mm_struct *
  * - under NOMMU conditions the chunk to be unmapped must be backed by a single
  *   VMA, though it need not cover the whole VMA
  */
-int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
+int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list_head *uf)
 {
 	struct vm_area_struct *vma;
 	unsigned long end;
@@ -1643,7 +1644,7 @@ int vm_munmap(unsigned long addr, size_t
 	int ret;
 
 	down_write(&mm->mmap_sem);
-	ret = do_munmap(mm, addr, len);
+	ret = do_munmap(mm, addr, len, NULL);
 	up_write(&mm->mmap_sem);
 	return ret;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-break-out-of-iomap_file_buffered_write-on-fatal-signals.patch
mm-fs-check-for-fatal-signals-in-do_generic_file_read.patch
mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

