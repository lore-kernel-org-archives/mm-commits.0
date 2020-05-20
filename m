From: Andrew Morton <akpm@linux-foundation.org>
Subject: + padata-document-multithreaded-jobs.patch added to -mm
 tree
Date: Wed, 20 May 2020 16:31:37 -0700
Message-ID: <20200520233137.uurquAPOn%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbgETXbj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 19:31:39 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: padata: document multithreaded jobs
has been added to the -mm tree.  Its filename is
     padata-document-multithreaded-jobs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/padata-document-multithreaded-jobs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/padata-document-multithreaded-jobs.patch

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
Subject: padata: document multithreaded jobs

Add Documentation for multithreaded jobs.

Link: http://lkml.kernel.org/r/20200520182645.1658949-8-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
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
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/padata.rst |   41 +++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/Documentation/core-api/padata.rst~padata-document-multithreaded-jobs
+++ a/Documentation/core-api/padata.rst
@@ -4,23 +4,26 @@
 The padata parallel execution mechanism
 =======================================
 
-:Date: December 2019
+:Date: April 2020
 
 Padata is a mechanism by which the kernel can farm jobs out to be done in
-parallel on multiple CPUs while retaining their ordering.  It was developed for
-use with the IPsec code, which needs to be able to perform encryption and
-decryption on large numbers of packets without reordering those packets.  The
-crypto developers made a point of writing padata in a sufficiently general
-fashion that it could be put to other uses as well.
+parallel on multiple CPUs while optionally retaining their ordering.
 
-Usage
-=====
+It was originally developed for IPsec, which needs to perform encryption and
+decryption on large numbers of packets without reordering those packets.  This
+is currently the sole consumer of padata's serialized job support.
+
+Padata also supports multithreaded jobs, splitting up the job evenly while load
+balancing and coordinating between threads.
+
+Running Serialized Jobs
+=======================
 
 Initializing
 ------------
 
-The first step in using padata is to set up a padata_instance structure for
-overall control of how jobs are to be run::
+The first step in using padata to run parallel jobs is to set up a
+padata_instance structure for overall control of how jobs are to be run::
 
     #include <linux/padata.h>
 
@@ -162,6 +165,24 @@ functions that correspond to the allocat
 It is the user's responsibility to ensure all outstanding jobs are complete
 before any of the above are called.
 
+Running Multithreaded Jobs
+==========================
+
+A multithreaded job has a main thread and zero or more helper threads, with the
+main thread participating in the job and then waiting until all helpers have
+finished.  padata splits the job into units called chunks, where a chunk is a
+piece of the job that one thread completes in one call to the thread function.
+
+A user has to do three things to run a multithreaded job.  First, describe the
+job by defining a padata_mt_job structure, which is explained in the Interface
+section.  This includes a pointer to the thread function, which padata will
+call each time it assigns a job chunk to a thread.  Then, define the thread
+function, which accepts three arguments, ``start``, ``end``, and ``arg``, where
+the first two delimit the range that the thread operates on and the last is a
+pointer to the job's shared state, if any.  Prepare the shared state, which is
+typically a stack-allocated structure that wraps the required data.  Last, call
+padata_do_multithreaded(), which will return once the job is finished.
+
 Interface
 =========
 
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
