From: akpm@linux-foundation.org
Subject: - taskstats-add-context-switch-counters.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:04 -0700
Message-ID: <200707162056.l6GKu4NI002064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761543AbXGPV3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muvarov@ru.mvista.com, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: add context-switch counters
has been removed from the -mm tree.  Its filename was
     taskstats-add-context-switch-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: add context-switch counters
From: Maxim Uvarov <muvarov@ru.mvista.com>

Make available to the user the following task and process performance
statistics:

	* Involuntary Context Switches (task_struct->nivcsw)
	* Voluntary Context Switches (task_struct->nvcsw)

Statistics information is available from:
	1. taskstats interface (Documentation/accounting/)
	2. /proc/PID/status (task only).

This data is useful for detecting hyperactivity patterns between processes.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c          |   19 ++++++++++++++--
 Documentation/accounting/taskstats-struct.txt |    6 +++++
 fs/proc/array.c                               |   10 ++++++++
 include/linux/taskstats.h                     |    5 +++-
 kernel/taskstats.c                            |    4 +++
 5 files changed, 41 insertions(+), 3 deletions(-)

diff -puN Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters
+++ a/Documentation/accounting/getdelays.c
@@ -49,6 +49,7 @@ char name[100];
 int dbg;
 int print_delays;
 int print_io_accounting;
+int print_task_context_switch_counts;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -195,7 +196,7 @@ void print_delayacct(struct taskstats *t
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n\n",
+	       "      %15llu%15llu\n"
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -204,6 +205,14 @@ void print_delayacct(struct taskstats *t
 	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
 }
 
+void task_context_switch_counts(struct taskstats *t)
+{
+	printf("\n\nTask   %15s%15s\n"
+	       "       %15lu%15lu\n",
+	       "voluntary", "nonvoluntary",
+	       t->nvcsw, t->nivcsw);
+}
+
 void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
@@ -235,7 +244,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:vl");
+		c = getopt(argc, argv, "qdiw:r:m:t:p:vl");
 		if (c < 0)
 			break;
 
@@ -248,6 +257,10 @@ int main(int argc, char *argv[])
 			printf("printing IO accounting\n");
 			print_io_accounting = 1;
 			break;
+		case 'q':
+			printf("printing task/process context switch rates\n");
+			print_task_context_switch_counts = 1;
+			break;
 		case 'w':
 			logfile = strdup(optarg);
 			printf("write to file %s\n", logfile);
@@ -389,6 +402,8 @@ int main(int argc, char *argv[])
 							print_delayacct((struct taskstats *) NLA_DATA(na));
 						if (print_io_accounting)
 							print_ioacct((struct taskstats *) NLA_DATA(na));
+						if (print_task_context_switch_counts)
+							task_context_switch_counts((struct taskstats *) NLA_DATA(na));
 						if (fd) {
 							if (write(fd, NLA_DATA(na), na->nla_len) < 0) {
 								err(1,"write error\n");
diff -puN Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters Documentation/accounting/taskstats-struct.txt
--- a/Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters
+++ a/Documentation/accounting/taskstats-struct.txt
@@ -22,6 +22,8 @@ There are three different groups of fiel
     /* Extended accounting fields end */
     Their values are collected if CONFIG_TASK_XACCT is set.
 
+4) Per-task and per-thread context switch count statistics
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -158,4 +160,8 @@ struct taskstats {
 
 	/* Extended accounting fields end */
 
+4) Per-task and per-thread statistics
+	__u64	nvcsw;			/* Context voluntary switch counter */
+	__u64	nivcsw;			/* Context involuntary switch counter */
+
 }
diff -puN fs/proc/array.c~taskstats-add-context-switch-counters fs/proc/array.c
--- a/fs/proc/array.c~taskstats-add-context-switch-counters
+++ a/fs/proc/array.c
@@ -289,6 +289,15 @@ static inline char *task_cap(struct task
 			    cap_t(p->cap_effective));
 }
 
+static inline char *task_context_switch_counts(struct task_struct *p,
+						char *buffer)
+{
+	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
+			    "nonvoluntary_ctxt_switches:\t%lu\n",
+			    p->nvcsw,
+			    p->nivcsw);
+}
+
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
 	char * orig = buffer;
@@ -307,6 +316,7 @@ int proc_pid_status(struct task_struct *
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+	buffer = task_context_switch_counts(task, buffer);
 	return buffer - orig;
 }
 
diff -puN include/linux/taskstats.h~taskstats-add-context-switch-counters include/linux/taskstats.h
--- a/include/linux/taskstats.h~taskstats-add-context-switch-counters
+++ a/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	4
+#define TASKSTATS_VERSION	5
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -149,6 +149,9 @@ struct taskstats {
 	__u64	read_bytes;		/* bytes of read I/O */
 	__u64	write_bytes;		/* bytes of write I/O */
 	__u64	cancelled_write_bytes;	/* bytes of cancelled write I/O */
+
+	__u64  nvcsw;			/* voluntary_ctxt_switches */
+	__u64  nivcsw;			/* nonvoluntary_ctxt_switches */
 };
 
 
diff -puN kernel/taskstats.c~taskstats-add-context-switch-counters kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-context-switch-counters
+++ a/kernel/taskstats.c
@@ -196,6 +196,8 @@ static int fill_pid(pid_t pid, struct ta
 
 	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
+	stats->nvcsw = tsk->nvcsw;
+	stats->nivcsw = tsk->nivcsw;
 	bacct_add_tsk(stats, tsk);
 
 	/* fill in extended acct fields */
@@ -242,6 +244,8 @@ static int fill_tgid(pid_t tgid, struct 
 		 */
 		delayacct_add_tsk(stats, tsk);
 
+		stats->nvcsw += tsk->nvcsw;
+		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
_

Patches currently in -mm which might be from muvarov@ru.mvista.com are

origin.patch
