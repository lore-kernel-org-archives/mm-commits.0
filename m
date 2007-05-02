From: akpm@linux-foundation.org
Subject: - ia64-sn-xpc-convert-to-use-kthread-api-fix.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:33 -0700
Message-ID: <200705021933.l42JXX63028270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766703AbXEBTeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dcn@sgi.com, ebiederm@xmission.com, holt@sgi.com, jes@sgi.com, rja@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64-sn-xpc-convert-to-use-kthread-api fix
has been removed from the -mm tree.  Its filename was
     ia64-sn-xpc-convert-to-use-kthread-api-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ia64-sn-xpc-convert-to-use-kthread-api fix
From: Christoph Lameter <clameter@sgi.com>

On Mon, 23 Apr 2007, Robin Holt wrote:

> On Fri, Apr 20, 2007 at 11:32:48PM -0700, Christoph Lameter wrote:
> > Well xpmem is broke and readahead is failing all over the place. Some
> > patches missing?
>
> Which xpmem are you compiling?  Did you let Dean Nelson know about this?
> Has anything been submitted to the community yet?

I think this was just a an artifact of an inconsistent ia64 mix of
patches in a temporary tree by Andrew.

Here is the hack that I used to compile more of the temp tree.

Cc: Jes Sorensen <jes@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <rja@sgi.com>
Cc: <holt@sgi.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpc_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api-fix arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api-fix
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -811,6 +811,8 @@ xpc_create_kthreads(struct xpc_channel *
 	pid_t pid;
 	u64 args = XPC_PACK_ARGS(ch->partid, ch->number);
 	struct xpc_partition *part = &xpc_partitions[ch->partid];
+	struct task_struct *task;
+
 
 
 	while (needed-- > 0) {
@@ -839,7 +841,7 @@ xpc_create_kthreads(struct xpc_channel *
 		xpc_msgqueue_ref(ch);
 
 		task = kthread_run(xpc_daemonize_kthread, args,
-				   "xpc%02dc%d", partid, ch_number);
+				   "xpc%02dc%d", ch->partid, ch->number);
 		if (IS_ERR(task)) {
 			/* the fork failed */
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-multiple-alignment-specifications.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-allocators-remove-useless-__gfp_no_grow-flag.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
