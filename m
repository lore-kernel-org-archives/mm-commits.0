From: akpm@linux-foundation.org
Subject: [merged] procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch removed from -mm tree
Date: Fri, 29 May 2009 11:42:54 -0700
Message-ID: <200905291842.n4TIgs5q011184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbZE2Sn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     procfs: make errno values consistent when open pident vs exit(2) race occurs
has been removed from the -mm tree.  Its filename was
     procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: make errno values consistent when open pident vs exit(2) race occurs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

proc_pident_instantiate() has following call flow.

proc_pident_lookup()
  proc_pident_instantiate()
    proc_pid_make_inode()

And, proc_pident_lookup() has following error handling.

	const struct pid_entry *p, *last;
	error = ERR_PTR(-ENOENT);
	if (!task)
		goto out_no_task;

Then, proc_pident_instantiate should return ENOENT too when racing against
exit(2) occur.

EINAL has two bad reason.
  - it implies caller is wrong. bad the race isn't caller's mistake.
  - man 2 open don't explain EINVAL. user often don't handle it.

Note: Other proc_pid_make_inode() caller already use ENOENT properly.

Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs fs/proc/base.c
--- a/fs/proc/base.c~procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs
+++ a/fs/proc/base.c
@@ -1956,7 +1956,7 @@ static struct dentry *proc_pident_instan
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error = ERR_PTR(-ENOENT);
 
 	inode = proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
vmscan-evict-use-once-pages-first-v3.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
vmscan-drop-pf_swapwrite-from-zone_reclaim.patch
vmscan-zone_reclaim-use-may_swap.patch
migration-only-migrate_prep-once-per-move_pages.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
mm-remove-config_unevictable_lru-config-option.patch
use-printk_once-in-several-places.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

