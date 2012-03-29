From: akpm@linux-foundation.org
Subject: [merged] slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:34 -0700
Message-ID: <20120329191334.D4AECA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62030 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746Ab2C2TNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:36 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so17792qab.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, avi@redhat.com, cl@linux.com, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, mel@csn.ul.ie, miltonm@bga.com, mina86@mina86.org, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: only IPI CPUs that have per cpu obj to flush
has been removed from the -mm tree.  Its filename was
     slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: slub: only IPI CPUs that have per cpu obj to flush

flush_all() is called for each kmem_cache_destroy().  So every cache being
destroyed dynamically ends up sending an IPI to each CPU in the system,
regardless if the cache has ever been used there.

For example, if you close the Infinband ipath driver char device file, the
close file ops calls kmem_cache_destroy().  So running some infiniband
config tool on one a single CPU dedicated to system tasks might interrupt
the rest of the 127 CPUs dedicated to some CPU intensive or latency
sensitive task.

I suspect there is a good chance that every line in the output of "git
grep kmem_cache_destroy linux/ | grep '\->'" has a similar scenario.

This patch attempts to rectify this issue by sending an IPI to flush the
per cpu objects back to the free lists only to CPUs that seem to have such
objects.

The check which CPU to IPI is racy but we don't care since asking a CPU
without per cpu objects to flush does no damage and as far as I can tell
the flush_all by itself is racy against allocs on remote CPUs anyway, so
if you required the flush_all to be determinstic, you had to arrange for
locking regardless.

Without this patch the following artificial test case:

$ cd /sys/kernel/slab
$ for DIR in *; do cat $DIR/alloc_calls > /dev/null; done

produces 166 IPIs on an cpuset isolated CPU. With it it produces none.

The code path of memory allocation failure for CPUMASK_OFFSTACK=y
config was tested using fault injection framework.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush mm/slub.c
--- a/mm/slub.c~slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush
+++ a/mm/slub.c
@@ -2028,9 +2028,17 @@ static void flush_cpu_slab(void *d)
 	__flush_cpu_slab(s, smp_processor_id());
 }
 
+static bool has_cpu_slab(int cpu, void *info)
+{
+	struct kmem_cache *s = info;
+	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+
+	return !!(c->page);
+}
+
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu(flush_cpu_slab, s, 1);
+	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
 }
 
 /*
_

Patches currently in -mm which might be from gilad@benyossef.com are

origin.patch

