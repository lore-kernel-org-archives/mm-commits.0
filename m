From: akpm@linux-foundation.org
Subject: + slab-use-num_possible_cpus-in-enable_cpucache.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:34:14 -0700
Message-ID: <200703212234.l2LMYEbP005595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907AbXCUWew (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLAB: use num_possible_cpus() in enable_cpucache()
has been added to the -mm tree.  Its filename is
     slab-use-num_possible_cpus-in-enable_cpucache.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLAB: use num_possible_cpus() in enable_cpucache()
From: Eric Dumazet <dada1@cosmosbay.com>

The existing comment in mm/slab.c is *perfect*, so I reproduce it :

         /*
          * CPU bound tasks (e.g. network routing) can exhibit cpu bound
          * allocation behaviour: Most allocs on one cpu, most free operations
          * on another cpu. For these cases, an efficient object passing between
          * cpus is necessary. This is provided by a shared array. The array
          * replaces Bonwick's magazine layer.
          * On uniprocessor, it's functionally equivalent (but less efficient)
          * to a larger limit. Thus disabled by default.
          */

As most shiped linux kernels are now compiled with CONFIG_SMP, there is no way
a preprocessor #if can detect if the machine is UP or SMP. Better to use
num_possible_cpus().

This means on UP we allocate a 'size=0 shared array', to be more efficient.

Another patch can later avoid the allocations of 'empty shared arrays', to
save some memory.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slab.c~slab-use-num_possible_cpus-in-enable_cpucache mm/slab.c
--- a/mm/slab.c~slab-use-num_possible_cpus-in-enable_cpucache
+++ a/mm/slab.c
@@ -4030,10 +4030,8 @@ static int enable_cpucache(struct kmem_c
 	 * to a larger limit. Thus disabled by default.
 	 */
 	shared = 0;
-#ifdef CONFIG_SMP
-	if (cachep->buffer_size <= PAGE_SIZE)
+	if (cachep->buffer_size <= PAGE_SIZE && num_possible_cpus() > 1)
 		shared = 8;
-#endif
 
 #if DEBUG
 	/*
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
