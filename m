From: akpm@linux-foundation.org
Subject: + time-smp-friendly-alignment-of-struct-clocksource.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:23:33 -0700
Message-ID: <200703282323.l2SNNXN9022557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933815AbXC1Xdv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, johnstul@us.ibm.com


The patch titled
     time: SMP friendly alignment of struct clocksource
has been added to the -mm tree.  Its filename is
     time-smp-friendly-alignment-of-struct-clocksource.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: SMP friendly alignment of struct clocksource
From: Eric Dumazet <dada1@cosmosbay.com>

struct clocksource is a critical data structure.

Most of its fields are read only, some of them are heavily modified at each
timer interrupt.

It makes sense to separate those fields and make sure they all share one
cache line, or at least the minimum for machines with small cache lines.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/clocksource.h~time-smp-friendly-alignment-of-struct-clocksource include/linux/clocksource.h
--- a/include/linux/clocksource.h~time-smp-friendly-alignment-of-struct-clocksource
+++ a/include/linux/clocksource.h
@@ -12,6 +12,7 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/list.h>
+#include <linux/cache.h>
 #include <linux/timer.h>
 #include <asm/div64.h>
 #include <asm/io.h>
@@ -52,6 +53,9 @@ struct clocksource;
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
 struct clocksource {
+	/*
+	 * First part of structure is read mostly
+	 */
 	char *name;
 	struct list_head list;
 	int rating;
@@ -63,8 +67,15 @@ struct clocksource {
 	cycle_t (*vread)(void);
 
 	/* timekeeping specific data, ignore */
-	cycle_t cycle_last, cycle_interval;
-	u64 xtime_nsec, xtime_interval;
+	cycle_t cycle_interval;
+	u64	xtime_interval;
+	/*
+	 * Second part is written at each timer interrupt
+	 * Keep it in a different cache line to dirty no
+	 * more than one cache line.
+	 */
+	cycle_t cycle_last ____cacheline_aligned_in_smp;
+	u64 xtime_nsec;
 	s64 error;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
