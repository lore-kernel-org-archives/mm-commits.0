From: akpm@linux-foundation.org
Subject: + taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch added to -mm tree
Date: Wed, 12 Sep 2007 17:18:42 -0700
Message-ID: <200709130018.l8D0IgHl026136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbXIMATS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 20:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@yahoo.fr, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, oleg@tv-sign.ru


The patch titled
     taskstats: add all thread stats for TASKSTATS_CMD_ATTR_TGID
has been added to the -mm tree.  Its filename is
     taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: taskstats: add all thread stats for TASKSTATS_CMD_ATTR_TGID
From: Guillaume Chazarain <guichaz@yahoo.fr>

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
the basic and extended accounting.  With this patch,
TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
(http://guichaz.free.fr/misc/iotop.py).

Here is the output of the testcase before the patch:

Name          |      System|        User|  Cached I/O|        Self|       Group|
--------------+------------+------------+------------+------------+------------+
version       |           5|           5|           5|           5|           5|
ac_exitcode   |           0|           0|           0|           0|           0|
ac_flag       |           0|           0|           0|           0|           0|
ac_nice       |           5|          10|          15|           0|           0|
cpu_count     |        2020|        1378|         360|       70645|       74428|
cpu_delay_tota|        2327|    14281152|    14225866|       30475|    44505841|
blkio_delay_to|           0|           0|           0|           0|  1146901308|
swapin_count  |           0|           0|           0|           0|           0|
swapin_delay_t|           0|           0|           0|           0|           0|
cpu_run_real_t|  4794271160|  1269806960|   331949536|    44993160|  6562002424|
cpu_run_virtua|  4792937602|  1247020977|   330330065|    43082258|  6530204192|
ac_comm       |      cached|      cached|      cached|      cached|            |
ac_uid        |         500|         500|         500|         500|           0|
ac_gid        |         500|         500|         500|         500|           0|
ac_pid        |        2513|        2514|        2515|        2512|           0|
ac_ppid       |        2445|        2445|        2445|        2445|           0|
ac_btime      |  1188326011|  1188326012|  1188326013|  1188326011|           0|
ac_etime      |     6619382|     5615437|     4600494|     6622066|           0|
ac_utime      |       25000|     1264000|       20000|        2000|           0|
ac_stime      |     4770000|        6000|      312000|       43000|           0|
ac_minflt     |           2|           0|           1|         320|           0|
ac_majflt     |           0|           0|           0|           0|           0|
coremem       |        3436|         286|        2302|        1285|           0|
virtmem       |        4012|         301|         740|        2198|           0|
hiwater_rss   |         756|         756|         756|         756|           0|
hiwater_vm    |       35004|       35004|       35004|       35004|           0|
read_char     |   208877984|           0|   825517700|        2807|           0|
write_char    |           0|           0|           0|           0|           0|
read_syscalls |      244730|           0|      215782|          10|           0|
write_syscalls|           0|           0|           0|           0|           0|
read_bytes    |           0|           0|           0|           0|           0|
write_bytes   |           0|           0|           0|           0|           0|
cancelled_writ|           0|           0|           0|           0|           0|
nvcsw         |           0|           0|           0|           8|           8|
nivcsw        |        2019|        1378|         360|           9|        3766|

and after the patch:

Name          |      System|        User|  Cached I/O|        Self|       Group|
--------------+------------+------------+------------+------------+------------+
version       |           5|           5|           5|           5|           5|
ac_exitcode   |           0|           0|           0|           0|           0|
ac_flag       |           0|           0|           0|           0|           0|
ac_nice       |           5|          10|          15|           0|           0|
cpu_count     |        1716|        1189|         293|       72795|       76036|
cpu_delay_tota|        3635|    15921729|    15269951|      277683|    46143870|
blkio_delay_to|           0|           0|           0|   113237372|   113237372|
swapin_count  |           0|           0|           0|           0|           0|
swapin_delay_t|           0|           0|           0|           0|           0|
cpu_run_real_t|  4338340472|  1117830064|   284956680|    49992400|  5915100768|
cpu_run_virtua|  4333641573|  1099471940|   282075705|    46039754|  5882048860|
ac_comm       |      cached|      cached|      cached|      cached|      cached|
ac_uid        |         500|         500|         500|         500|         500|
ac_gid        |         500|         500|         500|         500|         500|
ac_pid        |        7144|        7145|        7146|        7143|        7143|
ac_ppid       |        2435|        2435|        2435|        2435|        2435|
ac_btime      |  1188563357|  1188563358|  1188563359|  1188563356|  1188563356|
ac_etime      |     5960119|     4954580|     3938620|     6078187|     6078199|
ac_utime      |       33000|     1113000|       35000|        4000|     1193000|
ac_stime      |     4306000|        5000|      250000|       46000|     4723000|
ac_minflt     |           2|           0|           1|         317|         323|
ac_majflt     |           0|           0|           0|           3|           3|
coremem       |         363|        3617|        2127|        2320|       11249|
virtmem       |        1973|        3546|        2144|         151|        8182|
hiwater_rss   |         756|         756|         756|         756|         756|
hiwater_vm    |       35004|       35004|       35004|       35004|       35004|
read_char     |   188200698|           0|   696308768|        2807|   884512273|
write_char    |           0|           0|           0|           0|    33554432|
read_syscalls |      221608|           0|      182008|          10|      403626|
write_syscalls|           0|           0|           0|           0|       32768|
read_bytes    |           0|           0|           0|      323584|      323584|
write_bytes   |           0|           0|           0|           0|    33554432|
cancelled_writ|           0|           0|           0|           0|           0|
nvcsw         |           0|           0|           0|          20|          22|
nivcsw        |        1715|        1189|         293|          12|        3249|

The TGID stats now contain all the fields.

Changelog since V2 (http://lkml.org/lkml/2007/8/19/96):
- Added a testcase
- Added an indirection between the stats producer and consumer:
add_task() & fill_threadgroup()
- TGID stats are either summed from all the threads or taken from the leader

Changelog since V1 (http://lkml.org/lkml/2007/8/2/185):
- Update combined stats of exited threads in fill_tgid_exit() as
suggested by Balbir Singh.
- Very light cleanup of fill_tgid_exit() by the way.
- bacct fields are also combined for all threads.
- Instead of assuming memory stats are identical for all threads, we
take the max of all threads.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/dump-test.c |  314 +++++++++++++++++++++++++
 kernel/taskstats.c                   |  119 +++++----
 kernel/tsacct.c                      |  108 ++++----
 3 files changed, 449 insertions(+), 92 deletions(-)

diff -puN /dev/null Documentation/accounting/dump-test.c
--- /dev/null
+++ a/Documentation/accounting/dump-test.c
@@ -0,0 +1,314 @@
+/*
+ * Create some threads with specific behaviours and dump all of their stats.
+ * This needs a libnl recent enough to support Generic Netlink, made with
+ * svn r102 of libnl.
+ *
+ * Compile with:
+ *	cc -Wall -I../../include -lnl -lpthread dump-test.c -o dump-test
+ */
+
+#define _GNU_SOURCE		/* for strndup() */
+#include <sys/syscall.h>
+#include <sys/socket.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/types.h>
+#include <linux/taskstats.h>
+#include <linux/genetlink.h>
+#include <netlink/genl/genl.h>
+#include <netlink/genl/ctrl.h>
+
+/* Utility functions for the created threads */
+
+static void loop_reading(const char *filename)
+{
+	int fd = open(filename, O_RDONLY);
+	char buffer[4096];
+
+	if (fd < 0) {
+		perror(filename);
+		return;
+	}
+
+	for (;;) {
+		lseek(fd, 0, SEEK_SET);
+		while (read(fd, buffer, sizeof(buffer)) > 0) ;
+	}
+}
+
+/*
+ * We want to know the TID of the threads we launch, not to complicate the code
+ * with a real synchronization.
+ */
+static volatile pid_t tid;
+static void set_tid(void)
+{
+	if (tid) {
+		fputs("Unexpected non null tid\n", stderr);
+		exit(1);
+	}
+
+	tid = syscall(SYS_gettid);
+}
+
+static pid_t start_thread(void (*fun) (void), int wait)
+{
+	pthread_t thread;
+
+	tid = 0;
+	if (pthread_create(&thread, NULL, (void *(*)(void *))fun, NULL) < 0) {
+		perror("pthread_create");
+		exit(1);
+	}
+
+	/* Busy wait for the thread to update its tid. */
+	while (!tid)
+		sched_yield();
+
+	if (wait && pthread_join(thread, NULL) < 0) {
+		perror("pthread_join");
+		exit(1);
+	}
+
+	/* Space the starting time of the threads */
+	sleep(1);
+
+	return tid;
+}
+
+/* The created threads */
+
+/*
+ * Should loop in kernel mode
+ */
+static void niced_sys_thread(void)
+{
+	set_tid();
+	nice(5);
+	loop_reading("/proc/self/maps");
+}
+
+/*
+ * Should loop in user mode
+ */
+static void niced_user_thread(void)
+{
+	set_tid();
+	nice(10);
+	for (;;) ;
+}
+
+/*
+ * Should show some I/O syscalls
+ */
+static void cached_io_thread(void)
+{
+	set_tid();
+	nice(15);
+	loop_reading("/bin/ls");
+}
+
+/*
+ * This thread terminates after doing some real I/O so it should be visible in
+ * the thread group stats.
+ */
+#define TMP_PATH "/tmp/taskstats.test.tmp"
+static void dead_thread_having_written(void)
+{
+	int fd, i;
+	char buffer[1024];
+
+	set_tid();
+	fd = creat(TMP_PATH, 0600);
+	if (fd < 0) {
+		perror(TMP_PATH);
+		return;
+	}
+
+	/* Write 32M */
+	for (i = 0; i < 32 * 1024; i++) {
+		int remaining = sizeof(buffer);
+		while (remaining) {
+			int written = write(fd, buffer, remaining);
+			if (written > 0)
+				remaining -= written;
+			else {
+				perror("write");
+				close(fd);
+				return;
+			}
+		}
+	}
+
+	if (fsync(fd) < 0)
+		perror("fsync");
+
+	if (close(fd) < 0)
+		perror("close");
+
+	if (unlink(TMP_PATH))
+		perror("unlink");
+}
+
+/* taskstats reading using libnl */
+
+static int taskstats_netlink_family;
+static struct nl_handle *netlink_handle;
+
+static void init_taskstats(void)
+{
+	netlink_handle = nl_handle_alloc();
+	if (!netlink_handle) {
+		nl_perror("nl_handle_alloc");
+		exit(1);
+	}
+
+	if (genl_connect(netlink_handle) < 0) {
+		nl_perror("genl_connect");
+		exit(1);
+	}
+
+	taskstats_netlink_family = genl_ctrl_resolve(netlink_handle,
+						     TASKSTATS_GENL_NAME);
+	if (taskstats_netlink_family < 0) {
+		nl_perror("genl_ctrl_resolve(TASKSTATS_GENL_NAME)");
+		exit(1);
+	}
+}
+
+static struct taskstats get_taskstats(int attr, int pid)
+{
+	struct taskstats stats;
+	int len;
+	struct nl_msg *request;
+	void *request_header;
+	unsigned char *buf;
+	struct nlattr *nlattr, *reply;
+
+	request = nlmsg_alloc();
+	if (request == NULL) {
+		nl_perror("nlmsg_alloc");
+		exit(1);
+	}
+
+	request_header = genlmsg_put(request, 0, 0, taskstats_netlink_family,
+				     0, NLM_F_REQUEST, TASKSTATS_CMD_GET,
+				     TASKSTATS_GENL_VERSION);
+	if (request_header == NULL) {
+		nl_perror("genlmsg_put");
+		exit(1);
+	}
+
+	if (nla_put_u32(request, attr, pid) < 0) {
+		nl_perror("nla_put_u32");
+		exit(1);
+	}
+
+	len = nl_send_auto_complete(netlink_handle, request);
+	if (len < 0) {
+		nl_perror("nl_send_auto_complete");
+		exit(1);
+	}
+	nlmsg_free(request);
+
+	len = nl_recv(netlink_handle, NULL, &buf, NULL);
+	if (len < 0) {
+		nl_perror("nl_recv");
+		exit(1);
+	}
+	if (nl_wait_for_ack(netlink_handle) < 0) {
+		nl_perror("nl_wait_for_ack");
+		exit(1);
+	}
+
+	len = 0;
+	reply = (struct nlattr *)buf;
+	nla_for_each_nested(nlattr, reply, len)
+	    if (nlattr->nla_type == TASKSTATS_TYPE_STATS) {
+		memcpy(&stats, nla_data(nlattr), sizeof(stats));
+		free(buf);
+		return stats;
+	}
+
+	fputs("TASKSTATS_TYPE_STATS not found\n", stderr);
+	free(buf);
+	exit(1);
+}
+
+/* Output formatting */
+
+#define LINE(fo, f) do {						    \
+	char *stripped = strndup(#f, 14);				    \
+	printf("%-14s|" fo "|" fo "|" fo "|" fo "|" fo "|\n", stripped,	    \
+	       stats[0].f, stats[1].f, stats[2].f, stats[3].f, stats[4].f); \
+	free(stripped);							    \
+} while (0)
+
+static void show_table(struct taskstats stats[])
+{
+	puts("Name          |      System|        User|  Cached I/O"
+	     "|        Self|       Group|");
+	puts("--------------+------------+------------+------------"
+	     "+------------+------------+");
+	LINE("%12hu", version);
+	LINE("%12u", ac_exitcode);
+	LINE("%12x", ac_flag);
+	LINE("%12u", ac_nice);
+	LINE("%12llu", cpu_count);
+	LINE("%12llu", cpu_delay_total);
+	LINE("%12llu", blkio_delay_total);
+	LINE("%12llu", swapin_count);
+	LINE("%12llu", swapin_delay_total);
+	LINE("%12llu", cpu_run_real_total);
+	LINE("%12llu", cpu_run_virtual_total);
+	LINE("%12s", ac_comm);
+	LINE("%12u", ac_uid);
+	LINE("%12u", ac_gid);
+	LINE("%12u", ac_pid);
+	LINE("%12u", ac_ppid);
+	LINE("%12u", ac_btime);
+	LINE("%12llu", ac_etime);
+	LINE("%12llu", ac_utime);
+	LINE("%12llu", ac_stime);
+	LINE("%12llu", ac_minflt);
+	LINE("%12llu", ac_majflt);
+	LINE("%12llu", coremem);
+	LINE("%12llu", virtmem);
+	LINE("%12llu", hiwater_rss);
+	LINE("%12llu", hiwater_vm);
+	LINE("%12llu", read_char);
+	LINE("%12llu", write_char);
+	LINE("%12llu", read_syscalls);
+	LINE("%12llu", write_syscalls);
+	LINE("%12llu", read_bytes);
+	LINE("%12llu", write_bytes);
+	LINE("%12llu", cancelled_write_bytes);
+	LINE("%12llu", nvcsw);
+	LINE("%12llu", nivcsw);
+}
+
+int main(int argc, char *argv[])
+{
+	struct taskstats stats[5];
+	pid_t niced_sys = start_thread(niced_sys_thread, 0);
+	pid_t niced_user = start_thread(niced_user_thread, 0);
+	pid_t cached_io = start_thread(cached_io_thread, 0);
+	start_thread(dead_thread_having_written, 1);
+
+	init_taskstats();
+
+	stats[0] = get_taskstats(TASKSTATS_CMD_ATTR_PID, niced_sys);
+	stats[1] = get_taskstats(TASKSTATS_CMD_ATTR_PID, niced_user);
+	stats[2] = get_taskstats(TASKSTATS_CMD_ATTR_PID, cached_io);
+	stats[3] = get_taskstats(TASKSTATS_CMD_ATTR_PID, getpid());
+	stats[4] = get_taskstats(TASKSTATS_CMD_ATTR_TGID, cached_io);
+
+	show_table(stats);
+
+	return 0;
+}
diff -puN kernel/taskstats.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid
+++ a/kernel/taskstats.c
@@ -167,6 +167,60 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
+/*
+ * There are two types of taskstats fields when considering a thread group:
+ *	- those that can be aggregated from each thread in the group (like CPU
+ *	times),
+ *	- those that cannot be aggregated (like UID) or are identical (like
+ *	memory usage), so are taken from the group leader.
+ * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
+ * the second.
+ */
+static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to initialize
+	 * relevant parts of struct taskstsats for a single tgid as follows:
+	 *
+	 *	per-task-foo-fill_threadgroup(stats, task);
+	 */
+
+	stats->version = TASKSTATS_VERSION;
+
+	/* fill in basic acct fields */
+	bacct_fill_threadgroup(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_fill_threadgroup(stats, task);
+}
+
+/*
+ * Stats specific to each thread in the thread group. Stats of @task should be
+ * combined with those already present in @stats. add_tsk() works in
+ * conjunction with fill_threadgroup(), taskstats fields should not be touched
+ * by both functions.
+ */
+static void add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to combine
+	 * relevant parts of struct taskstsats for a single pid as follows:
+	 *
+	 *	per-task-foo-add_tsk(stats, task);
+	 */
+	stats->nvcsw  += task->nvcsw;
+	stats->nivcsw += task->nivcsw;
+
+	/* fill in delay acct fields */
+	delayacct_add_tsk(stats, task);
+
+	/* fill in basic acct fields */
+	bacct_add_tsk(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_add_tsk(stats, task);
+}
+
 static int fill_pid(pid_t pid, struct task_struct *tsk,
 		struct taskstats *stats)
 {
@@ -184,23 +238,8 @@ static int fill_pid(pid_t pid, struct ta
 		get_task_struct(tsk);
 
 	memset(stats, 0, sizeof(*stats));
-	/*
-	 * Each accounting subsystem adds calls to its functions to
-	 * fill in relevant parts of struct taskstsats as follows
-	 *
-	 *	per-task-foo(stats, tsk);
-	 */
-
-	delayacct_add_tsk(stats, tsk);
-
-	/* fill in basic acct fields */
-	stats->version = TASKSTATS_VERSION;
-	stats->nvcsw = tsk->nvcsw;
-	stats->nivcsw = tsk->nivcsw;
-	bacct_add_tsk(stats, tsk);
-
-	/* fill in extended acct fields */
-	xacct_add_tsk(stats, tsk);
+	fill_threadgroup(stats, tsk);
+	add_tsk(stats, tsk);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -212,6 +251,7 @@ static int fill_tgid(pid_t tgid, struct 
 		struct taskstats *stats)
 {
 	struct task_struct *tsk;
+	struct task_struct *leader;
 	unsigned long flags;
 	int rc = -ESRCH;
 
@@ -231,32 +271,21 @@ static int fill_tgid(pid_t tgid, struct 
 	else
 		memset(stats, 0, sizeof(*stats));
 
+	leader = first->group_leader;
+	get_task_struct(leader);
+	fill_threadgroup(stats, leader);
+	put_task_struct(leader);
+
 	tsk = first;
-	do {
-		if (tsk->exit_state)
-			continue;
-		/*
-		 * Accounting subsystem can call its functions here to
-		 * fill in relevant parts of struct taskstsats as follows
-		 *
-		 *	per-task-foo(stats, tsk);
-		 */
-		delayacct_add_tsk(stats, tsk);
-
-		stats->nvcsw += tsk->nvcsw;
-		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	do
+		if (!tsk->exit_state)
+			add_tsk(stats, tsk);
+	while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
 	rcu_read_unlock();
-
-	stats->version = TASKSTATS_VERSION;
-	/*
-	 * Accounting subsytems can also add calls here to modify
-	 * fields of taskstats.
-	 */
 	return rc;
 }
 
@@ -264,21 +293,19 @@ out:
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
+	struct taskstats *tg_stats;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
+	tg_stats = tsk->signal->stats;
 
 	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
+	 * fill_threadgroup() will be called by the stats requester,
+	 * i.e. fill_tgid()
 	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
+	if (tg_stats)
+		add_tsk(tg_stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
diff -puN kernel/tsacct.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid kernel/tsacct.c
--- a/kernel/tsacct.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid
+++ a/kernel/tsacct.c
@@ -22,50 +22,64 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-/*
- * fill in basic accounting fields
- */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *task)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
-	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
-
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
+	ts = timespec_sub(uptime, task->start_time);
 	/* rebase elapsed time to usec */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
+	stats->ac_etime	= ac_etime;
+	stats->ac_btime	= get_seconds() - ts.tv_sec;
+}
+
+/*
+ * fill in basic accounting fields
+ */
+
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
+
+	rcu_read_lock();
+	stats->ac_ppid	= pid_alive(task) ?
+				rcu_dereference(task->real_parent)->tgid : 0;
+	rcu_read_unlock();
+
+	if (thread_group_leader(task)) {
+		stats->ac_exitcode = task->exit_code;
+		if (task->flags & PF_FORKNOEXEC)
 			stats->ac_flag |= AFORK;
 	}
-	if (tsk->flags & PF_SUPERPRIV)
+
+	fill_wall_times(stats, task);
+
+	stats->ac_nice	= task_nice(task);
+	stats->ac_sched	= task->policy;
+	stats->ac_uid	= task->uid;
+	stats->ac_gid	= task->gid;
+	stats->ac_pid	= task->pid;
+
+	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
+}
+
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	if (task->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
-	if (tsk->flags & PF_DUMPCORE)
+	if (task->flags & PF_DUMPCORE)
 		stats->ac_flag |= ACORE;
-	if (tsk->flags & PF_SIGNALED)
+	if (task->flags & PF_SIGNALED)
 		stats->ac_flag |= AXSIG;
-	stats->ac_nice	 = task_nice(tsk);
-	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->uid;
-	stats->ac_gid	 = tsk->gid;
-	stats->ac_pid	 = tsk->pid;
-	rcu_read_lock();
-	stats->ac_ppid	 = pid_alive(tsk) ?
-				rcu_dereference(tsk->real_parent)->tgid : 0;
-	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
+	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
+	stats->ac_minflt += task->min_flt;
+	stats->ac_majflt += task->maj_flt;
 }
 
 
@@ -76,32 +90,34 @@ void bacct_add_tsk(struct taskstats *sta
 /*
  * fill in extended accounting fields
  */
-void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
 {
 	struct mm_struct *mm;
 
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
-	mm = get_task_mm(p);
+	mm = get_task_mm(task);
 	if (mm) {
 		/* adjust to KB unit */
 		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_vm    = mm->hiwater_vm  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+}
+
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+{
+	/* convert pages-jiffies to Mbyte-usec */
+	stats->coremem	+= jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem	+= jiffies_to_usecs(p->acct_vm_mem1)  * PAGE_SIZE / MB;
+
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
+
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes		+= p->ioac.read_bytes;
+	stats->write_bytes		+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes	+= p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
sync_sb_inodes-propagate-errors.patch
