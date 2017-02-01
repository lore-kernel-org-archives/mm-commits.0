From: akpm@linux-foundation.org
Subject: + mm-fs-check-for-fatal-signals-in-do_generic_file_read.patch
 added to -mm tree
Date: Wed, 01 Feb 2017 14:21:30 -0800
Message-ID: <58925f6a.xGNVybNgLlSooXWr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbdBAWVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 17:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fs: check for fatal signals in do_generic_file_read()
has been added to the -mm tree.  Its filename is
     mm-fs-check-for-fatal-signals-in-do_generic_file_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-check-for-fatal-signals-in-do_generic_file_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-check-for-fatal-signals-in-do_generic_file_read.patch

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
Subject: mm, fs: check for fatal signals in do_generic_file_read()

do_generic_file_read() can be told to perform a large request from
userspace.  If the system is under OOM and the reading task is the OOM
victim then it has an access to memory reserves and finishing the full
request can lead to the full memory depletion which is dangerous.  Make
sure we rather go with a short read and allow the killed task to
terminate.

Link: http://lkml.kernel.org/r/20170201092706.9966-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/filemap.c~mm-fs-check-for-fatal-signals-in-do_generic_file_read mm/filemap.c
--- a/mm/filemap.c~mm-fs-check-for-fatal-signals-in-do_generic_file_read
+++ a/mm/filemap.c
@@ -1791,6 +1791,11 @@ static ssize_t do_generic_file_read(stru
 
 		cond_resched();
 find_page:
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			goto out;
+		}
+
 		page = find_get_page(mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(mapping,
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

