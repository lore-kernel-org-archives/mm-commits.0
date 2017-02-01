From: akpm@linux-foundation.org
Subject: + vmalloc-back-of-when-the-current-is-killed.patch added to -mm
 tree
Date: Wed, 01 Feb 2017 14:22:44 -0800
Message-ID: <58925fb4.QeDHyHcbBfL5uQJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdBAWWp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 17:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: back off when the current task is killed
has been added to the -mm tree.  Its filename is
     vmalloc-back-of-when-the-current-is-killed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-back-of-when-the-current-is-killed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-back-of-when-the-current-is-killed.patch

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
Subject: vmalloc: back off when the current task is killed

__vmalloc_area_node() allocates pages to cover the requested vmalloc size.
This can be a lot of memory.  If the current task is killed by the OOM
killer, and thus has an unlimited access to memory reserves, it can
consume all the memory theoretically.  Fix this by checking for
fatal_signal_pending and back off early.

Link: http://lkml.kernel.org/r/20170201092706.9966-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmalloc.c~vmalloc-back-of-when-the-current-is-killed mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-back-of-when-the-current-is-killed
+++ a/mm/vmalloc.c
@@ -1642,6 +1642,11 @@ static void *__vmalloc_area_node(struct
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
+		if (fatal_signal_pending(current)) {
+			area->nr_pages = i;
+			goto fail;
+		}
+
 		if (node == NUMA_NO_NODE)
 			page = alloc_page(alloc_mask);
 		else
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
vmalloc-back-of-when-the-current-is-killed.patch

