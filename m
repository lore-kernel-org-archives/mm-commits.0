From: akpm@linux-foundation.org
Subject: + time-smp-friendly-alignment-of-struct-clocksource.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:13:17 -0700
Message-ID: <200703212213.l2LMDHXl005122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXCUWOC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:14:02 -0400
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

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clocksource.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/clocksource.h~time-smp-friendly-alignment-of-struct-clocksource include/linux/clocksource.h
--- a/include/linux/clocksource.h~time-smp-friendly-alignment-of-struct-clocksource
+++ a/include/linux/clocksource.h
@@ -52,6 +52,9 @@ struct clocksource;
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
 struct clocksource {
+	/*
+	 * First part of structure is read mostly
+	 */
 	char *name;
 	struct list_head list;
 	int rating;
@@ -63,8 +66,15 @@ struct clocksource {
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

optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
