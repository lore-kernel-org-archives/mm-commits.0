From: akpm@linux-foundation.org
Subject: + mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch added to -mm tree
Date: Fri, 18 Dec 2009 16:12:35 -0800
Message-ID: <200912190012.nBJ0CZnR026827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbZLSANK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 19:13:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mel@csn.ul.ie


The patch titled
     mm tracing: cleanup Documentation/trace/events-kmem.txt
has been added to the -mm tree.  Its filename is
     mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch

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
Subject: mm tracing: cleanup Documentation/trace/events-kmem.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Clean up typos/grammos/spellos in events-kmem.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/events-kmem.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN Documentation/trace/events-kmem.txt~mm-tracing-cleanup-documentation-trace-events-kmemtxt Documentation/trace/events-kmem.txt
--- a/Documentation/trace/events-kmem.txt~mm-tracing-cleanup-documentation-trace-events-kmemtxt
+++ a/Documentation/trace/events-kmem.txt
@@ -1,7 +1,7 @@
 			Subsystem Trace Points: kmem
 
-The tracing system kmem captures events related to object and page allocation
-within the kernel. Broadly speaking there are four major subheadings.
+The kmem tracing system captures events related to object and page allocation
+within the kernel. Broadly speaking there are five major subheadings.
 
   o Slab allocation of small objects of unknown type (kmalloc)
   o Slab allocation of small objects of known type
@@ -9,7 +9,7 @@ within the kernel. Broadly speaking ther
   o Per-CPU Allocator Activity
   o External Fragmentation
 
-This document will describe what each of the tracepoints are and why they
+This document describes what each of the tracepoints is and why they
 might be useful.
 
 1. Slab allocation of small objects of unknown type
@@ -34,7 +34,7 @@ kmem_cache_free		call_site=%lx ptr=%p
 These events are similar in usage to the kmalloc-related events except that
 it is likely easier to pin the event down to a specific cache. At the time
 of writing, no information is available on what slab is being allocated from,
-but the call_site can usually be used to extrapolate that information
+but the call_site can usually be used to extrapolate that information.
 
 3. Page allocation
 ==================
@@ -80,9 +80,9 @@ event indicating whether it is for a per
 When the per-CPU list is too full, a number of pages are freed, each one
 which triggers a mm_page_pcpu_drain event.
 
-The individual nature of the events are so that pages can be tracked
+The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone->lock being taken once. Large amounts of PCP
+consecutively imply the zone->lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
@@ -102,6 +102,6 @@ is important.
 
 Large numbers of this event implies that memory is fragmenting and
 high-order allocations will start failing at some time in the future. One
-means of reducing the occurange of this event is to increase the size of
+means of reducing the occurrence of this event is to increase the size of
 min_free_kbytes in increments of 3*pageblock_size*nr_online_nodes where
 pageblock_size is usually the size of the default hugepage size.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

lib-stringc-fix-kernel-doc-warnings.patch
mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch
linux-next.patch
docs-large-update-to-ioctl-numbertxt.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

