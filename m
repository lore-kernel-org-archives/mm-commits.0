From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-remove-exit-routine.patch added to -mm tree
Date: Wed, 20 May 2020 16:31:16 -0700
Message-ID: <20200520233116.ahMy5DKfL%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgETXbS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 19:31:18 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: padata: remove exit routine
has been added to the -mm tree.  Its filename is
     padata-remove-exit-routine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/padata-remove-exit-routine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/padata-remove-exit-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: padata: remove exit routine

Patch series "padata: parallelize deferred page init", v2.

Deferred struct page init is a bottleneck in kernel boot--the biggest for
us and probably others.  Optimizing it maximizes availability for
large-memory systems and allows spinning up short-lived VMs as needed
without having to leave them running.  It also benefits bare metal
machines hosting VMs that are sensitive to downtime.  In projects such as
VMM Fast Restart[1], where guest state is preserved across kexec reboot,
it helps prevent application and network timeouts in the guests.

So, multithread deferred init to take full advantage of system memory
bandwidth.

Extend padata, a framework that handles many parallel singlethreaded jobs,
to handle multithreaded jobs as well by adding support for splitting up
the work evenly, specifying a minimum amount of work that's appropriate
for one helper thread to do, load balancing between helpers, and
coordinating them.  More documentation in patches 4 and 7.

This series is the first step in a project to address other memory
proportional bottlenecks in the kernel such as pmem struct page init, vfio
page pinning, hugetlb fallocate, and munmap.  Deferred page init doesn't
require concurrency limits, resource control, or priority adjustments like
these other users will because it happens during boot when the system is
otherwise idle and waiting for page init to finish.

This has been run on a variety of x86 systems and speeds up kernel boot by
3% to 49%, saving up to 1.6 out of 4 seconds.  Patch 5 has more numbers.


This patch (of 7):

padata_driver_exit() is unnecessary because padata isn't built as a module
and doesn't exit.

padata's init routine will soon allocate memory, so getting rid of the
exit function now avoids pointless code to free it.

Link: http://lkml.kernel.org/r/20200520182645.1658949-1-daniel.m.jordan@oracle.com
Link: http://lkml.kernel.org/r/20200520182645.1658949-2-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/padata.c~padata-remove-exit-routine
+++ a/kernel/padata.c
@@ -1072,10 +1072,4 @@ static __init int padata_driver_init(voi
 }
 module_init(padata_driver_init);
 
-static __exit void padata_driver_exit(void)
-{
-	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
-	cpuhp_remove_multi_state(hp_online);
-}
-module_exit(padata_driver_exit);
 #endif
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
padata-remove-exit-routine.patch
padata-initialize-earlier.patch
padata-allocate-work-structures-for-parallel-jobs-from-a-pool.patch
padata-add-basic-support-for-multithreaded-jobs.patch
mm-parallelize-deferred_init_memmap.patch
mm-make-deferred-inits-max-threads-arch-specific.patch
padata-document-multithreaded-jobs.patch
