From: akpm@linux-foundation.org
Subject: + slub-user-documentation.patch added to -mm tree
Date: Tue, 10 Apr 2007 18:32:19 -0700
Message-ID: <200704110132.l3B1WJfs025263@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965927AbXDKBcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 21:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: user documentation
has been added to the -mm tree.  Its filename is
     slub-user-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: user documentation
From: Christoph Lameter <clameter@sgi.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.txt |  114 ++++++++++++++++++++++++++++++++++++
 1 files changed, 114 insertions(+)

diff -puN /dev/null Documentation/vm/slub.txt
--- /dev/null
+++ a/Documentation/vm/slub.txt
@@ -0,0 +1,114 @@
+Short users guide for SLUB
+--------------------------
+
+First of all slub should transparently replace SLAB. If you enable
+SLUB then everything should work the same (Note the word "should".
+There is likely not much value in that word at this point).
+
+The basic philosophy of SLUB is very different from SLAB. SLAB
+requires rebuilding the kernel to activate debug options for all
+SLABS. SLUB always includes full debugging but its off by default.
+SLUB can enable debugging only for selected slabs in order to avoid
+an impact on overall system performance which may make a bug more
+difficult to find.
+
+In order to switch debugging on one can add a option "slub_debug"
+to the kernel command line. That will enable full debugging for
+all slabs.
+
+Typically one would then use the "slabinfo" command to get statistical
+data and perform operation on the slabs. By default slabinfo only lists
+slabs that have data in them. See "slabinfo -h" for more options when
+running the command. slabinfo is included in this directory and can
+be compiled with
+
+gcc -o slabinfo slabinfo.c
+
+Some of the modes of operation of slabinfo require that slub debugging
+be enabled on the command line. F.e. no tracking information will be
+available without debugging on and validation can only partially
+be performed if debugging was not switched on.
+
+Some more sophisticated uses of slub_debug:
+-------------------------------------------
+
+Parameters may be given to slub_debug. If none is specified then full
+debugging is enabled. Format:
+
+slub_debug=<Debug-Options>       Enable options for all slabs
+slub_debug=<Debug-Options>,<slab name>
+				Enable options only for select slabs
+
+Possible debug options are
+	F		Sanity checks on (enables SLAB_DEBUG_FREE. Sorry
+			SLAB legacy issues)
+	Z		Red zoning
+	P		Poisoning (object and padding)
+	U		User tracking (free and alloc)
+	T		Trace (please only use on single slabs)
+
+F.e. in order to boot just with sanity checks and red zoning one would specify:
+
+	slub_debug=FZ
+
+Trying to find an issue in the dentry cache? Try
+
+	slub_debug=,dentry_cache
+
+to only enable debugging on the dentry cache.
+
+Red zoning and tracking may realign the slab. We can just apply sanity checks to
+the dentry cache with
+
+	slub_debug=F,dentry_cache
+
+In case you forgot to enable debugging on the kernel command line: It is
+possible to enable debugging manually when the kernel is up. Look at the
+contents of:
+
+/sys/slab/<slab name>/
+
+Look at the writable files. Writing 1 to them will enable the
+corresponding debug option. All options can be set on a slab that does
+not contain objects. If the slab already contains objects then sanity checks
+and tracing may only be enabled. The other options may cause the realignment
+of objects.
+
+Careful with tracing: It may spew out lots of information and never stop if
+used on the wrong slab.
+
+SLAB Merging
+------------
+
+If no debugging is specified then SLUB may merge similar slabs together
+in order to reduce overhead and increase cache hotness of objects.
+slabinfo -a displays which slabs were merged together.
+
+Getting more performance
+------------------------
+
+To some degree SLUBs performance is limited by the need to take the
+list_lock once in a while to deal with partial slabs. That overhead is
+governed by the order of the allocation for each slab. The allocations
+can be influenced by kernel parameters:
+
+slub_min_objects=x		(default 8)
+slub_min_order=x		(default 0)
+slub_max_order=x		(default 4)
+
+slub_min_objects allows to specify how many objects must at least fit
+into one slab in order for the allocation order to be acceptable.
+In general slub will be able to perform this number of allocations
+on a slab without consulting centralized resources (list_lock) where
+contention may occur.
+
+slub_min_order specifies a minim order of slabs. A similar effect like
+slub_min_objects.
+
+slub_max_order specified the order at which slub_min_objects should no
+longer be checked. This is useful to avoid SLUB trying to generate
+super large order pages to fit slub_min_objects of a slab cache with
+large object sizes into one high order page.
+
+
+Christoph Lameter, <clameter@sgi.com>, April 10, 2007
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
