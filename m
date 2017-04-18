From: akpm@linux-foundation.org
Subject: + slab-avoid-ipis-when-creating-kmem-caches.patch added to -mm
 tree
Date: Tue, 18 Apr 2017 15:06:18 -0700
Message-ID: <58f68dda.agWKIjB33JVUbBDo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752695AbdDRWGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 18:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: avoid IPIs when creating kmem caches
has been added to the -mm tree.  Its filename is
     slab-avoid-ipis-when-creating-kmem-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-avoid-ipis-when-creating-kmem-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-avoid-ipis-when-creating-kmem-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: slab: avoid IPIs when creating kmem caches

Each slab kmem cache has per cpu array caches.  The array caches are
created when the kmem_cache is created, either via kmem_cache_create()
or lazily when the first object is allocated in context of a kmem
enabled memcg.  Array caches are replaced by writing to /proc/slabinfo.

Array caches are protected by holding slab_mutex or disabling
interrupts.  Array cache allocation and replacement is done by
__do_tune_cpucache() which holds slab_mutex and calls
kick_all_cpus_sync() to interrupt all remote processors which confirms
there are no references to the old array caches.

IPIs are needed when replacing array caches.  But when creating a new
array cache, there's no need to send IPIs because there cannot be any
references to the new cache.  Outside of memcg kmem accounting these
IPIs occur at boot time, so they're not a problem.  But with memcg kmem
accounting each container can create kmem caches, so the IPIs are
wasteful.

Avoid unnecessary IPIs when creating array caches.

Test which reports the IPI count of allocating slab in 10000 memcg:
	import os

	def ipi_count():
		with open("/proc/interrupts") as f:
			for l in f:
				if 'Function call interrupts' in l:
					return int(l.split()[1])

	def echo(val, path):
		with open(path, "w") as f:
			f.write(val)

	n = 10000
	os.chdir("/mnt/cgroup/memory")
	pid = str(os.getpid())
	a = ipi_count()
	for i in range(n):
		os.mkdir(str(i))
		echo("1G\n", "%d/memory.limit_in_bytes" % i)
		echo("1G\n", "%d/memory.kmem.limit_in_bytes" % i)
		echo(pid, "%d/cgroup.procs" % i)
		open("/tmp/x", "w").close()
		os.unlink("/tmp/x")
	b = ipi_count()
	print "%d loops: %d => %d (+%d ipis)" % (n, a, b, b-a)
	echo(pid, "cgroup.procs")
	for i in range(n):
		os.rmdir(str(i))

patched:   10000 loops: 1069 => 1170 (+101 ipis)
unpatched: 10000 loops: 1192 => 48933 (+47741 ipis)

Link: http://lkml.kernel.org/r/20170416214544.109476-1-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-avoid-ipis-when-creating-kmem-caches mm/slab.c
--- a/mm/slab.c~slab-avoid-ipis-when-creating-kmem-caches
+++ a/mm/slab.c
@@ -3879,7 +3879,12 @@ static int __do_tune_cpucache(struct kme
 
 	prev = cachep->cpu_cache;
 	cachep->cpu_cache = cpu_cache;
-	kick_all_cpus_sync();
+	/*
+	 * Without a previous cpu_cache there's no need to synchronize remote
+	 * cpus, so skip the IPIs.
+	 */
+	if (prev)
+		kick_all_cpus_sync();
 
 	check_irq_on();
 	cachep->batchcount = batchcount;
_

Patches currently in -mm which might be from gthelen@google.com are

slab-avoid-ipis-when-creating-kmem-caches.patch

