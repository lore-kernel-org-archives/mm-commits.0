From: akpm@linux-foundation.org
Subject: + slub-disable-tracing-and-failslab-for-merged-slabs.patch added
 to -mm tree
Date: Fri, 29 Aug 2014 12:56:05 -0700
Message-ID: <5400dad5.rIy2xs4Zuxb8xsi0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2T4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, chaowang@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: disable tracing and failslab for merged slabs
has been added to the -mm tree.  Its filename is
     slub-disable-tracing-and-failslab-for-merged-slabs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-disable-tracing-and-failslab-for-merged-slabs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-disable-tracing-and-failslab-for-merged-slabs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slub: disable tracing and failslab for merged slabs

Tracing of mergeable slabs as well as uses of failslab are confusing since
the objects of multiple slab caches will be affected.  Moreover this
creates a situation where a mergeable slab will become unmergeable.

If tracing or failslab testing is desired then it may be best to switch
merging off for starters.

Signed-off-by: Christoph Lameter <cl@linux.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/slub.c~slub-disable-tracing-and-failslab-for-merged-slabs mm/slub.c
--- a/mm/slub.c~slub-disable-tracing-and-failslab-for-merged-slabs
+++ a/mm/slub.c
@@ -4604,6 +4604,14 @@ static ssize_t trace_show(struct kmem_ca
 static ssize_t trace_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	/*
+	 * Tracing a merged cache is going to give confusing results
+	 * as well as cause other issues like converting a mergeable
+	 * cache into an umergeable one.
+	 */
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_TRACE;
 	if (buf[0] == '1') {
 		s->flags &= ~__CMPXCHG_DOUBLE;
@@ -4721,6 +4729,9 @@ static ssize_t failslab_show(struct kmem
 static ssize_t failslab_store(struct kmem_cache *s, const char *buf,
 							size_t length)
 {
+	if (s->refcount > 1)
+		return -EINVAL;
+
 	s->flags &= ~SLAB_FAILSLAB;
 	if (buf[0] == '1')
 		s->flags |= SLAB_FAILSLAB;
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
linux-next.patch

