From: akpm@linux-foundation.org
Subject: + mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch added to -mm tree
Date: Thu, 10 Sep 2009 16:57:52 -0700
Message-ID: <200909102357.n8ANvqGR024120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbZIJX6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 19:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, eric.whitney@hp.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, npiggin@suse.de


The patch titled
     mmap: avoid unnecessary anon_vma lock acquisition in vma_adjust()
has been added to the -mm tree.  Its filename is
     mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: avoid unnecessary anon_vma lock acquisition in vma_adjust()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

We noticed very erratic behavior [throughput] with the AIM7 shared
workload running on recent distro [SLES11] and mainline kernels on an
8-socket, 32-core, 256GB x86_64 platform.  On the SLES11 kernel
[2.6.27.19+] with Barcelona processors, as we increased the load [10s of
thousands of tasks], the throughput would vary between two "plateaus"--one
at ~65K jobs per minute and one at ~130K jpm.  The simple patch below
causes the results to smooth out at the ~130k plateau.

But wait, there's more:

We do not see this behavior on smaller platforms--e.g., 4 socket/8 core. 
This could be the result of the larger number of cpus on the larger
platform--a scalability issue--or it could be the result of the larger
number of interconnect "hops" between some nodes in this platform and how
the tasks for a given load end up distributed over the nodes' cpus and
memories--a stochastic NUMA effect.

The variability in the results are less pronounced [on the same platform]
with Shanghai processors and with mainline kernels.  With 31-rc6 on
Shanghai processors and 288 file systems on 288 fibre attached storage
volumes, the curves [jpm vs load] are both quite flat with the patched
kernel consistently producing ~3.9% better throughput [~80K jpm vs ~77K
jpm] than the unpatched kernel.

Profiling indicated that the "slow" runs were incurring high[er]
contention on an anon_vma lock in vma_adjust(), apparently called from the
sbrk() system call.

The patch:

A comment in mm/mmap.c:vma_adjust() suggests that we don't really need the
anon_vma lock when we're only adjusting the end of a vma, as is the case
for brk().  The comment questions whether it's worth while to optimize for
this case.  Apparently, on the newer, larger x86_64 platforms, with
interesting NUMA topologies, it is worth while--especially considering
that the patch [if correct!] is quite simple.

We can detect this condition--no overlap with next vma--by noting a NULL
"importer".  The anon_vma pointer will also be NULL in this case, so
simply avoid loading vma->anon_vma to avoid the lock.  However, we
apparently DO need to take the anon_vma lock when we're inserting a vma
['insert' non-NULL] even when we have no overlap [NULL "importer"], so we
need to check for 'insert', as well.

I have tested with and without the 'file || ' test in the patch.  This
does not seem to matter for stability nor performance.  I left this
check/filter in, so we only optimize away the anon_vma lock acquisition
when adjusting the end of a non- importing, non-inserting, anon vma.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust mm/mmap.c
--- a/mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust
+++ a/mm/mmap.c
@@ -571,9 +571,9 @@ again:			remove_next = 1 + (end > next->
 
 	/*
 	 * When changing only vma->vm_end, we don't really need
-	 * anon_vma lock: but is that case worth optimizing out?
+	 * anon_vma lock.
 	 */
-	if (vma->anon_vma)
+	if ((file || insert || importer) && vma->anon_vma)
 		anon_vma = vma->anon_vma;
 	if (anon_vma) {
 		spin_lock(&anon_vma->lock);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
linux-next.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
hugetlb-promote-numa_no_node-to-generic-constant.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

