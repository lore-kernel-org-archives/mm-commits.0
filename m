From: akpm@linux-foundation.org
Subject: - mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:51:33 -0700
Message-ID: <200804282151.m3SLpX5Y017583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964964AbYD1Vv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, ak@suse.de, clameter@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, ray-lk@madrabbit.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy: add bitmap_onto() and bitmap_fold() operations
has been removed from the -mm tree.  Its filename was
     mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy: add bitmap_onto() and bitmap_fold() operations
From: Paul Jackson <pj@sgi.com>

The following adds two more bitmap operators, bitmap_onto() and bitmap_fold(),
with the usual cpumask and nodemask wrappers.

The bitmap_onto() operator computes one bitmap relative to another.  If the
n-th bit in the origin mask is set, then the m-th bit of the destination mask
will be set, where m is the position of the n-th set bit in the relative mask.

The bitmap_fold() operator folds a bitmap into a second that has bit m set iff
the input bitmap has some bit n set, where m == n mod sz, for the specified sz
value.

There are two substantive changes between this patch and its
predecessor bitmap_relative:
 1) Renamed bitmap_relative() to be bitmap_onto().
 2) Added bitmap_fold().

The essential motivation for bitmap_onto() is to provide a mechanism for
converting a cpuset-relative CPU or Node mask to an absolute mask.  Cpuset
relative masks are written as if the current task were in a cpuset whose CPUs
or Nodes were just the consecutive ones numbered 0..N-1, for some N.  The
bitmap_onto() operator is provided in anticipation of adding support for the
first such cpuset relative mask, by the mbind() and set_mempolicy() system
calls, using a planned flag of MPOL_F_RELATIVE_NODES.  These bitmap operators
(and their nodemask wrappers, in particular) will be used in code that
converts the user specified cpuset relative memory policy to a specific system
node numbered policy, given the current mems_allowed of the tasks cpuset.

Such cpuset relative mempolicies will address two deficiencies
of the existing interface between cpusets and mempolicies:
 1) A task cannot at present reliably establish a cpuset
    relative mempolicy because there is an essential race
    condition, in that the tasks cpuset may be changed in
    between the time the task can query its cpuset placement,
    and the time the task can issue the applicable mbind or
    set_memplicy system call.
 2) A task cannot at present establish what cpuset relative
    mempolicy it would like to have, if it is in a smaller
    cpuset than it might have mempolicy preferences for,
    because the existing interface only allows specifying
    mempolicies for nodes currently allowed by the cpuset.

Cpuset relative mempolicies are useful for tasks that don't distinguish
particularly between one CPU or Node and another, but only between how many of
each are allowed, and the proper placement of threads and memory pages on the
various CPUs and Nodes available.

The motivation for the added bitmap_fold() can be seen in the following
example.

Let's say an application has specified some mempolicies that presume 16 memory
nodes, including say a mempolicy that specified MPOL_F_RELATIVE_NODES (cpuset
relative) nodes 12-15.  Then lets say that application is crammed into a
cpuset that only has 8 memory nodes, 0-7.  If one just uses bitmap_onto(),
this mempolicy, mapped to that cpuset, would ignore the requested relative
nodes above 7, leaving it empty of nodes.  That's not good; better to fold the
higher nodes down, so that some nodes are included in the resulting mapped
mempolicy.  In this case, the mempolicy nodes 12-15 are taken modulo 8 (the
weight of the mems_allowed of the confining cpuset), resulting in a mempolicy
specifying nodes 4-7.

Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: <kosaki.motohiro@jp.fujitsu.com>
Cc: <ray-lk@madrabbit.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h   |    6 +
 include/linux/cpumask.h  |   22 ++++-
 include/linux/nodemask.h |   22 ++++-
 lib/bitmap.c             |  158 +++++++++++++++++++++++++++++++++++++
 4 files changed, 206 insertions(+), 2 deletions(-)

diff -puN include/linux/bitmap.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations include/linux/bitmap.h
--- a/include/linux/bitmap.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations
+++ a/include/linux/bitmap.h
@@ -46,6 +46,8 @@
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
  * bitmap_bitremap(oldbit, old, new, nbits)	newbit = map(old, new)(oldbit)
+ * bitmap_onto(dst, orig, relmap, nbits)	*dst = orig relative to relmap
+ * bitmap_fold(dst, orig, sz, nbits)		dst bits = orig bits mod sz
  * bitmap_scnprintf(buf, len, src, nbits)	Print bitmap src to buf
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
@@ -121,6 +123,10 @@ extern void bitmap_remap(unsigned long *
 		const unsigned long *old, const unsigned long *new, int bits);
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
+extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
+		const unsigned long *relmap, int bits);
+extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
+		int sz, int bits);
 extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
diff -puN include/linux/cpumask.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations include/linux/cpumask.h
--- a/include/linux/cpumask.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations
+++ a/include/linux/cpumask.h
@@ -14,6 +14,8 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of cpu_remap(), see bitmap_bitremap in lib/bitmap.c
  * For details of cpus_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of cpus_onto(), see bitmap_onto in lib/bitmap.c.
+ * For details of cpus_fold(), see bitmap_fold in lib/bitmap.c.
  *
  * The available cpumask operations are:
  *
@@ -53,7 +55,9 @@
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
  * int cpulist_parse(buf, map)		Parse ascii string as cpulist
  * int cpu_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
- * int cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void cpus_onto(dst, orig, relmap)	*dst = orig relative to relmap
+ * void cpus_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
  * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask
  *
@@ -330,6 +334,22 @@ static inline void __cpus_remap(cpumask_
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
+#define cpus_onto(dst, orig, relmap) \
+		__cpus_onto(&(dst), &(orig), &(relmap), NR_CPUS)
+static inline void __cpus_onto(cpumask_t *dstp, const cpumask_t *origp,
+		const cpumask_t *relmapp, int nbits)
+{
+	bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
+}
+
+#define cpus_fold(dst, orig, sz) \
+		__cpus_fold(&(dst), &(orig), sz, NR_CPUS)
+static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
+		int sz, int nbits)
+{
+	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
+}
+
 #if NR_CPUS > 1
 #define for_each_cpu_mask(cpu, mask)		\
 	for ((cpu) = first_cpu(mask);		\
diff -puN include/linux/nodemask.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations include/linux/nodemask.h
--- a/include/linux/nodemask.h~mempolicy-add-bitmap_onto-and-bitmap_fold-operations
+++ a/include/linux/nodemask.h
@@ -14,6 +14,8 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of node_remap(), see bitmap_bitremap in lib/bitmap.c.
  * For details of nodes_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of nodes_onto(), see bitmap_onto in lib/bitmap.c.
+ * For details of nodes_fold(), see bitmap_fold in lib/bitmap.c.
  *
  * The available nodemask operations are:
  *
@@ -55,7 +57,9 @@
  * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
- * int nodes_remap(dst, src, old, new)	*dst = map(old, new)(dst)
+ * void nodes_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void nodes_onto(dst, orig, relmap)	*dst = orig relative to relmap
+ * void nodes_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
  * for_each_node_mask(node, mask)	for-loop node over mask
  *
@@ -326,6 +330,22 @@ static inline void __nodes_remap(nodemas
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
+#define nodes_onto(dst, orig, relmap) \
+		__nodes_onto(&(dst), &(orig), &(relmap), MAX_NUMNODES)
+static inline void __nodes_onto(nodemask_t *dstp, const nodemask_t *origp,
+		const nodemask_t *relmapp, int nbits)
+{
+	bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
+}
+
+#define nodes_fold(dst, orig, sz) \
+		__nodes_fold(&(dst), &(orig), sz, MAX_NUMNODES)
+static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
+		int sz, int nbits)
+{
+	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
+}
+
 #if MAX_NUMNODES > 1
 #define for_each_node_mask(node, mask)			\
 	for ((node) = first_node(mask);			\
diff -puN lib/bitmap.c~mempolicy-add-bitmap_onto-and-bitmap_fold-operations lib/bitmap.c
--- a/lib/bitmap.c~mempolicy-add-bitmap_onto-and-bitmap_fold-operations
+++ a/lib/bitmap.c
@@ -714,6 +714,164 @@ int bitmap_bitremap(int oldbit, const un
 }
 EXPORT_SYMBOL(bitmap_bitremap);
 
+/**
+ * bitmap_onto - translate one bitmap relative to another
+ *	@dst: resulting translated bitmap
+ * 	@orig: original untranslated bitmap
+ * 	@relmap: bitmap relative to which translated
+ *	@bits: number of bits in each of these bitmaps
+ *
+ * Set the n-th bit of @dst iff there exists some m such that the
+ * n-th bit of @relmap is set, the m-th bit of @orig is set, and
+ * the n-th bit of @relmap is also the m-th _set_ bit of @relmap.
+ * (If you understood the previous sentence the first time your
+ * read it, you're overqualified for your current job.)
+ *
+ * In other words, @orig is mapped onto (surjectively) @dst,
+ * using the the map { <n, m> | the n-th bit of @relmap is the
+ * m-th set bit of @relmap }.
+ *
+ * Any set bits in @orig above bit number W, where W is the
+ * weight of (number of set bits in) @relmap are mapped nowhere.
+ * In particular, if for all bits m set in @orig, m >= W, then
+ * @dst will end up empty.  In situations where the possibility
+ * of such an empty result is not desired, one way to avoid it is
+ * to use the bitmap_fold() operator, below, to first fold the
+ * @orig bitmap over itself so that all its set bits x are in the
+ * range 0 <= x < W.  The bitmap_fold() operator does this by
+ * setting the bit (m % W) in @dst, for each bit (m) set in @orig.
+ *
+ * Example [1] for bitmap_onto():
+ *  Let's say @relmap has bits 30-39 set, and @orig has bits
+ *  1, 3, 5, 7, 9 and 11 set.  Then on return from this routine,
+ *  @dst will have bits 31, 33, 35, 37 and 39 set.
+ *
+ *  When bit 0 is set in @orig, it means turn on the bit in
+ *  @dst corresponding to whatever is the first bit (if any)
+ *  that is turned on in @relmap.  Since bit 0 was off in the
+ *  above example, we leave off that bit (bit 30) in @dst.
+ *
+ *  When bit 1 is set in @orig (as in the above example), it
+ *  means turn on the bit in @dst corresponding to whatever
+ *  is the second bit that is turned on in @relmap.  The second
+ *  bit in @relmap that was turned on in the above example was
+ *  bit 31, so we turned on bit 31 in @dst.
+ *
+ *  Similarly, we turned on bits 33, 35, 37 and 39 in @dst,
+ *  because they were the 4th, 6th, 8th and 10th set bits
+ *  set in @relmap, and the 4th, 6th, 8th and 10th bits of
+ *  @orig (i.e. bits 3, 5, 7 and 9) were also set.
+ *
+ *  When bit 11 is set in @orig, it means turn on the bit in
+ *  @dst corresponding to whatever is the twelth bit that is
+ *  turned on in @relmap.  In the above example, there were
+ *  only ten bits turned on in @relmap (30..39), so that bit
+ *  11 was set in @orig had no affect on @dst.
+ *
+ * Example [2] for bitmap_fold() + bitmap_onto():
+ *  Let's say @relmap has these ten bits set:
+ *		40 41 42 43 45 48 53 61 74 95
+ *  (for the curious, that's 40 plus the first ten terms of the
+ *  Fibonacci sequence.)
+ *
+ *  Further lets say we use the following code, invoking
+ *  bitmap_fold() then bitmap_onto, as suggested above to
+ *  avoid the possitility of an empty @dst result:
+ *
+ *	unsigned long *tmp;	// a temporary bitmap's bits
+ *
+ *	bitmap_fold(tmp, orig, bitmap_weight(relmap, bits), bits);
+ *	bitmap_onto(dst, tmp, relmap, bits);
+ *
+ *  Then this table shows what various values of @dst would be, for
+ *  various @orig's.  I list the zero-based positions of each set bit.
+ *  The tmp column shows the intermediate result, as computed by
+ *  using bitmap_fold() to fold the @orig bitmap modulo ten
+ *  (the weight of @relmap).
+ *
+ *      @orig           tmp            @dst
+ *      0                0             40
+ *      1                1             41
+ *      9                9             95
+ *      10               0             40 (*)
+ *      1 3 5 7          1 3 5 7       41 43 48 61
+ *      0 1 2 3 4        0 1 2 3 4     40 41 42 43 45
+ *      0 9 18 27        0 9 8 7       40 61 74 95
+ *      0 10 20 30       0             40
+ *      0 11 22 33       0 1 2 3       40 41 42 43
+ *      0 12 24 36       0 2 4 6       40 42 45 53
+ *      78 102 211       1 2 8         41 42 74 (*)
+ *
+ * (*) For these marked lines, if we hadn't first done bitmap_fold()
+ *     into tmp, then the @dst result would have been empty.
+ *
+ * If either of @orig or @relmap is empty (no set bits), then @dst
+ * will be returned empty.
+ *
+ * If (as explained above) the only set bits in @orig are in positions
+ * m where m >= W, (where W is the weight of @relmap) then @dst will
+ * once again be returned empty.
+ *
+ * All bits in @dst not set by the above rule are cleared.
+ */
+void bitmap_onto(unsigned long *dst, const unsigned long *orig,
+			const unsigned long *relmap, int bits)
+{
+	int n, m;       	/* same meaning as in above comment */
+
+	if (dst == orig)	/* following doesn't handle inplace mappings */
+		return;
+	bitmap_zero(dst, bits);
+
+	/*
+	 * The following code is a more efficient, but less
+	 * obvious, equivalent to the loop:
+	 *	for (m = 0; m < bitmap_weight(relmap, bits); m++) {
+	 *		n = bitmap_ord_to_pos(orig, m, bits);
+	 *		if (test_bit(m, orig))
+	 *			set_bit(n, dst);
+	 *	}
+	 */
+
+	m = 0;
+	for (n = find_first_bit(relmap, bits);
+	     n < bits;
+	     n = find_next_bit(relmap, bits, n + 1)) {
+		/* m == bitmap_pos_to_ord(relmap, n, bits) */
+		if (test_bit(m, orig))
+			set_bit(n, dst);
+		m++;
+	}
+}
+EXPORT_SYMBOL(bitmap_onto);
+
+/**
+ * bitmap_fold - fold larger bitmap into smaller, modulo specified size
+ *	@dst: resulting smaller bitmap
+ *	@orig: original larger bitmap
+ *	@sz: specified size
+ *	@bits: number of bits in each of these bitmaps
+ *
+ * For each bit oldbit in @orig, set bit oldbit mod @sz in @dst.
+ * Clear all other bits in @dst.  See further the comment and
+ * Example [2] for bitmap_onto() for why and how to use this.
+ */
+void bitmap_fold(unsigned long *dst, const unsigned long *orig,
+			int sz, int bits)
+{
+	int oldbit;
+
+	if (dst == orig)	/* following doesn't handle inplace mappings */
+		return;
+	bitmap_zero(dst, bits);
+
+	for (oldbit = find_first_bit(orig, bits);
+	     oldbit < bits;
+	     oldbit = find_next_bit(orig, bits, oldbit + 1))
+		set_bit(oldbit % sz, dst);
+}
+EXPORT_SYMBOL(bitmap_fold);
+
 /*
  * Common code for bitmap_*_region() routines.
  *	bitmap: array of unsigned longs corresponding to the bitmap
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
reapply-sched-cpuset-customize-sched-domains-core-bits-fix.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
kernel-cpusetc-make-3-functions-static.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch

