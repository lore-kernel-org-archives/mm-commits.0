From: akpm@linux-foundation.org
Subject: [merged] kgdb-timeout-if-secondary-cpus-ignore-the-roundup.patch
 removed from -mm tree
Date: Wed, 12 Nov 2014 12:56:02 -0800
Message-ID: <5463c962.eOMzQJKjcyeCXVir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaKLU4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 15:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kgdb: timeout if secondary CPUs ignore the roundup
has been removed from the -mm tree.  Its filename was
     kgdb-timeout-if-secondary-cpus-ignore-the-roundup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: kgdb: timeout if secondary CPUs ignore the roundup

Currently if an active CPU fails to respond to a roundup request the CPU
that requested the roundup will become stuck.  This needlessly reduces the
robustness of the debugger.

This patch introduces a timeout allowing the system state to be examined
even when the system contains unresponsive processors.  It also modifies
kdb's cpu command to make it censor attempts to switch to unresponsive
processors and to report their state as (D)ead.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/debug_core.c       |    9 +++++++--
 kernel/debug/kdb/kdb_debugger.c |    4 ++++
 kernel/debug/kdb/kdb_main.c     |    4 +++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff -puN kernel/debug/debug_core.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup
+++ a/kernel/debug/debug_core.c
@@ -471,6 +471,7 @@ static int kgdb_cpu_enter(struct kgdb_st
 	int cpu;
 	int trace_on = 0;
 	int online_cpus = num_online_cpus();
+	u64 time_left;
 
 	kgdb_info[ks->cpu].enter_kgdb++;
 	kgdb_info[ks->cpu].exception_state |= exception_state;
@@ -595,9 +596,13 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
-				atomic_read(&slaves_in_kgdb)) != online_cpus)
+	time_left = loops_per_jiffy * HZ;
+	while (kgdb_do_roundup && --time_left &&
+	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
+		   online_cpus)
 		cpu_relax();
+	if (!time_left)
+		pr_crit("KGDB: Timed out waiting for secondary CPUs.\n");
 
 	/*
 	 * At this point the primary processor is completely
diff -puN kernel/debug/kdb/kdb_debugger.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup kernel/debug/kdb/kdb_debugger.c
--- a/kernel/debug/kdb/kdb_debugger.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup
+++ a/kernel/debug/kdb/kdb_debugger.c
@@ -129,6 +129,10 @@ int kdb_stub(struct kgdb_state *ks)
 		ks->pass_exception = 1;
 		KDB_FLAG_SET(CATASTROPHIC);
 	}
+	/* set CATASTROPHIC if the system contains unresponsive processors */
+	for_each_online_cpu(i)
+		if (!kgdb_info[i].enter_kgdb)
+			KDB_FLAG_SET(CATASTROPHIC);
 	if (KDB_STATE(SSBPT) && reason == KDB_REASON_SSTEP) {
 		KDB_STATE_CLEAR(SSBPT);
 		KDB_STATE_CLEAR(DOING_SS);
diff -puN kernel/debug/kdb/kdb_main.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup kernel/debug/kdb/kdb_main.c
--- a/kernel/debug/kdb/kdb_main.c~kgdb-timeout-if-secondary-cpus-ignore-the-roundup
+++ a/kernel/debug/kdb/kdb_main.c
@@ -2157,6 +2157,8 @@ static void kdb_cpu_status(void)
 	for (start_cpu = -1, i = 0; i < NR_CPUS; i++) {
 		if (!cpu_online(i)) {
 			state = 'F';	/* cpu is offline */
+		} else if (!kgdb_info[i].enter_kgdb) {
+			state = 'D';	/* cpu is online but unresponsive */
 		} else {
 			state = ' ';	/* cpu is responding to kdb */
 			if (kdb_task_state_char(KDB_TSK(i)) == 'I')
@@ -2210,7 +2212,7 @@ static int kdb_cpu(int argc, const char
 	/*
 	 * Validate cpunum
 	 */
-	if ((cpunum > NR_CPUS) || !cpu_online(cpunum))
+	if ((cpunum > NR_CPUS) || !kgdb_info[cpunum].enter_kgdb)
 		return KDB_BADCPUNUM;
 
 	dbg_switch_cpu = cpunum;
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are

linux-next.patch

