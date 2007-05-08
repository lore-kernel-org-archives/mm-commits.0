From: akpm@linux-foundation.org
Subject: - slub-user-documentation.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:55 -0700
Message-ID: <200705080008.l4808toB009410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967448AbXEHAJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: user documentation
has been removed from the -mm tree.  Its filename was
     slub-user-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: user documentation
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.txt |  113 ++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+)

diff -puN /dev/null Documentation/vm/slub.txt
--- /dev/null
+++ a/Documentation/vm/slub.txt
@@ -0,0 +1,113 @@
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
+running the command. slabinfo can be compiled with
+
+gcc -o slabinfo Documentation/vm/slabinfo.c
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
+Red zoning and tracking may realign the slab.  We can just apply sanity checks
+to the dentry cache with
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
+To some degree SLUB's performance is limited by the need to take the
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

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
