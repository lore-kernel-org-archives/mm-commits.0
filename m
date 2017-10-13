From: akpm@linux-foundation.org
Subject: + mm-page_alloc-make-sure-__rmqueue-etc-always-inline.patch added to -mm tree
Date: Fri, 13 Oct 2017 14:34:10 -0700
Message-ID: <59e13152.ED1uK7C+RzuY74OA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdJMVeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaron.lu@intel.com, andi@firstfloor.org, dave.hansen@intel.com, kemi.wang@intel.com, khandual@linux.vnet.ibm.com, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: make sure __rmqueue() etc are always inline
has been added to the -mm tree.  Its filename is
     mm-page_alloc-make-sure-__rmqueue-etc-always-inline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-make-sure-__rmqueue-etc-always-inline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-make-sure-__rmqueue-etc-always-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaron Lu <aaron.lu@intel.com>
Subject: mm/page_alloc: make sure __rmqueue() etc are always inline

__rmqueue(), __rmqueue_fallback(), __rmqueue_smallest() and
__rmqueue_cma_fallback() are all in page allocator's hot path and better
be finished as soon as possible.  One way to make them faster is by making
them inline.  But as Andrew Morton and Andi Kleen pointed out:
https://lkml.org/lkml/2017/10/10/1252
https://lkml.org/lkml/2017/10/10/1279
To make sure they are inlined, we should use __always_inline for them.

With the will-it-scale/page_fault1/process benchmark, when using nr_cpu
processes to stress buddy, the results for will-it-scale.processes with
and without the patch are:

On a 2-sockets Intel-Skylake machine:

 compiler          base        head
gcc-4.4.7       6496131     6911823 +6.4%
gcc-4.9.4       7225110     7731072 +7.0%
gcc-5.4.1       7054224     7688146 +9.0%
gcc-6.2.0       7059794     7651675 +8.4%

On a 4-sockets Intel-Skylake machine:

 compiler          base        head
gcc-4.4.7      13162890    13508193 +2.6%
gcc-4.9.4      14997463    15484353 +3.2%
gcc-5.4.1      14708711    15449805 +5.0%
gcc-6.2.0      14574099    15349204 +5.3%

The above 4 compilers are used becuase I've done the tests through Intel's
Linux Kernel Performance(LKP) infrastructure and they are the available
compilers there.

The benefit being less on 4 sockets machine is due to the lock contention
there(perf-profile/native_queued_spin_lock_slowpath=81%) is less severe
than on the 2 sockets machine(85%).

What the benchmark does is: it forks nr_cpu processes and then each
process does the following:
    1 mmap() 128M anonymous space;
    2 writes to each page there to trigger actual page allocation;
    3 munmap() it.
in a loop.
https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault1.c

Binary size wise, I have locally built them with different compilers:

[aaron@aaronlu obj]$ size */*/mm/page_alloc.o
   text    data     bss     dec     hex filename
  37409    9904    8524   55837    da1d gcc-4.9.4/base/mm/page_alloc.o
  38273    9904    8524   56701    dd7d gcc-4.9.4/head/mm/page_alloc.o
  37465    9840    8428   55733    d9b5 gcc-5.5.0/base/mm/page_alloc.o
  38169    9840    8428   56437    dc75 gcc-5.5.0/head/mm/page_alloc.o
  37573    9840    8428   55841    da21 gcc-6.4.0/base/mm/page_alloc.o
  38261    9840    8428   56529    dcd1 gcc-6.4.0/head/mm/page_alloc.o
  36863    9840    8428   55131    d75b gcc-7.2.0/base/mm/page_alloc.o
  37711    9840    8428   55979    daab gcc-7.2.0/head/mm/page_alloc.o

Text size increased about 800 bytes for mm/page_alloc.o.

[aaron@aaronlu obj]$ size */*/vmlinux
   text    data     bss     dec       hex     filename
10342757   5903208 17723392 33969357  20654cd gcc-4.9.4/base/vmlinux
10342757   5903208 17723392 33969357  20654cd gcc-4.9.4/head/vmlinux
10332448   5836608 17715200 33884256  2050860 gcc-5.5.0/base/vmlinux
10332448   5836608 17715200 33884256  2050860 gcc-5.5.0/head/vmlinux
10094546   5836696 17715200 33646442  201676a gcc-6.4.0/base/vmlinux
10094546   5836696 17715200 33646442  201676a gcc-6.4.0/head/vmlinux
10018775   5828732 17715200 33562707  2002053 gcc-7.2.0/base/vmlinux
10018775   5828732 17715200 33562707  2002053 gcc-7.2.0/head/vmlinux

Text size for vmlinux has no change though, probably due to function
alignment.

Link: http://lkml.kernel.org/r/20171013063111.GA26032@intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Kemi Wang <kemi.wang@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-sure-__rmqueue-etc-always-inline mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-sure-__rmqueue-etc-always-inline
+++ a/mm/page_alloc.c
@@ -1795,7 +1795,7 @@ static void prep_new_page(struct page *p
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
  */
-static inline
+static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
@@ -1839,7 +1839,7 @@ static int fallbacks[MIGRATE_TYPES][4] =
 };
 
 #ifdef CONFIG_CMA
-static struct page *__rmqueue_cma_fallback(struct zone *zone,
+static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
 {
 	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
@@ -2220,7 +2220,7 @@ static bool unreserve_highatomic_pageblo
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
  */
-static inline bool
+static __always_inline bool
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 {
 	struct free_area *area;
@@ -2292,8 +2292,8 @@ do_steal:
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
-static struct page *__rmqueue(struct zone *zone, unsigned int order,
-				int migratetype)
+static __always_inline struct page *
+__rmqueue(struct zone *zone, unsigned int order, int migratetype)
 {
 	struct page *page;
 
_

Patches currently in -mm which might be from aaron.lu@intel.com are

mm-page_alloc-make-sure-__rmqueue-etc-always-inline.patch

