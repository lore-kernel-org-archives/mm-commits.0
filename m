From: akpm@linux-foundation.org
Subject: + slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:48 -0800
Message-ID: <20120128001548.4AC1CA043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43754 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2A1APv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:51 -0500
Received: by eaaf1 with SMTP id f1so108545eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, andi@firstfloor.org, avi@redhat.com, cl@linux.com, cmetcalf@tilera.com, fweisbec@gmail.com, kosaki.motohiro@gmail.com, levinsasha928@gmail.com, linux@arm.linux.org.uk, mel@csn.ul.ie, miltonm@bga.com, mina86@mina86.org, mpm@selenic.com, penberg@kernel.org, riel@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: slub: only IPI CPUs that have per cpu obj to flush
has been added to the -mm tree.  Its filename is
     slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2023,9 +2023,17 @@ static void flush_cpu_slab(void *d)
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
Subject: Subject: slub: only IPI CPUs that have per cpu obj to flush

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

