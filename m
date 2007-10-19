From: akpm@linux-foundation.org
Subject: - add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:56 -0700
Message-ID: <200710190344.l9J3iubA013181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966067AbXJSD4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mneuling@au1.ibm.com, balbir@in.ibm.com, benh@kernel.crashing.org, jlan@engr.sgi.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     add-scaled-time-to-taskstats-based-process-accounting fix
has been removed from the -mm tree.  Its filename was
     add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add-scaled-time-to-taskstats-based-process-accounting fix
From: Michael Neuling <mneuling@au1.ibm.com>

This moves the new items to the end of the taskstats struct as
requested by Balbir and yourself.

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/taskstats.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN include/linux/taskstats.h~add-missing-newlines-to-some-uses-of-dev_level-messages-fix include/linux/taskstats.h
--- a/include/linux/taskstats.h~add-missing-newlines-to-some-uses-of-dev_level-messages-fix
+++ a/include/linux/taskstats.h
@@ -85,12 +85,9 @@ struct taskstats {
 	 * On some architectures, value will adjust for cpu time stolen
 	 * from the kernel in involuntary waits due to virtualization.
 	 * Value is cumulative, in nanoseconds, without a corresponding count
-	 * and wraps around to zero silently on overflow.  The
-	 * _scaled_ version accounts for cpus which can scale the
-	 * number of instructions executed each cycle.
+	 * and wraps around to zero silently on overflow
 	 */
 	__u64	cpu_run_real_total;
-	__u64	cpu_scaled_run_real_total;
 
 	/* cpu "virtual" running time
 	 * Uses time intervals seen by the kernel i.e. no adjustment
@@ -145,10 +142,6 @@ struct taskstats {
 	__u64	write_char;		/* bytes written */
 	__u64	read_syscalls;		/* read syscalls */
 	__u64	write_syscalls;		/* write syscalls */
-
-	/* time accounting for SMT machines */
-	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
-	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
 	/* Extended accounting fields end */
 
 #define TASKSTATS_HAS_IO_ACCOUNTING
@@ -159,6 +152,11 @@ struct taskstats {
 
 	__u64  nvcsw;			/* voluntary_ctxt_switches */
 	__u64  nivcsw;			/* nonvoluntary_ctxt_switches */
+
+	/* time accounting for SMT machines */
+	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
+	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
+	__u64	cpu_scaled_run_real_total; /* scaled cpu_run_real_total */
 };
 
 
_

Patches currently in -mm which might be from mneuling@au1.ibm.com are

origin.patch
