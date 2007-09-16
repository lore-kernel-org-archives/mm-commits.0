From: akpm@linux-foundation.org
Subject: + taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:41:23 -0700
Message-ID: <200709160541.l8G5fNiL002211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbXIPFlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@yahoo.fr, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, oleg@tv-sign.ru


The patch titled
     taskstats: add all thread stats for TASKSTATS_CMD_ATTR_TGID (v4)
has been added to the -mm tree.  Its filename is
     taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: taskstats: add all thread stats for TASKSTATS_CMD_ATTR_TGID (v4)
From: Guillaume Chazarain <guichaz@yahoo.fr>

Changelog since V3 (http://lkml.org/lkml/2007/8/31/121):
- Removed userspace example, either it gets accepted in util-linux-ng or I'll
maintain it elsewhere.
- Added kerneldoc for fill_threadgroup() and add_tsk().
- Removed useless {get,put}_task_struct(leader) as spotted by Andrew Morton
and Oleg Nesterov.
- Use lock_task_sighand() instead of spin_lock_irqsave(&tsk->sighand->siglock)
for consistency with the locking of task->signal->stats in fill_tgid().
- Removed useless check for a NULL taskstats in fill_tgid_exit(). Thanks Oleg.
- Documented double accounting race seen by Oleg.
- Rephrased the fill_tgid_exit() comment as per Oleg's recommendation.
- Documented the special case for the AFORK ac_flag.
- Use the exit status (code >> 8) instead of the exit code as documented in
Documentation/accounting/taskstats-struct.txt.
- Use signal->group_exit_code if set for stats->ac_exitcode on a TGID as
suggested by Oleg.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/dump-test.c |  314 -------------------------
 include/linux/tsacct_kern.h          |   12 
 kernel/taskstats.c                   |   38 +--
 kernel/tsacct.c                      |   23 -
 4 files changed, 46 insertions(+), 341 deletions(-)

diff -puN Documentation/accounting/dump-test.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4 /dev/null
--- a/Documentation/accounting/dump-test.c
+++ /dev/null
@@ -1,314 +0,0 @@
-/*
- * Create some threads with specific behaviours and dump all of their stats.
- * This needs a libnl recent enough to support Generic Netlink, made with
- * svn r102 of libnl.
- *
- * Compile with:
- *	cc -Wall -I../../include -lnl -lpthread dump-test.c -o dump-test
- */
-
-#define _GNU_SOURCE		/* for strndup() */
-#include <sys/syscall.h>
-#include <sys/socket.h>
-#include <unistd.h>
-#include <pthread.h>
-#include <stdio.h>
-#include <fcntl.h>
-#include <sched.h>
-#include <stdlib.h>
-#include <string.h>
-#include <linux/types.h>
-#include <linux/taskstats.h>
-#include <linux/genetlink.h>
-#include <netlink/genl/genl.h>
-#include <netlink/genl/ctrl.h>
-
-/* Utility functions for the created threads */
-
-static void loop_reading(const char *filename)
-{
-	int fd = open(filename, O_RDONLY);
-	char buffer[4096];
-
-	if (fd < 0) {
-		perror(filename);
-		return;
-	}
-
-	for (;;) {
-		lseek(fd, 0, SEEK_SET);
-		while (read(fd, buffer, sizeof(buffer)) > 0) ;
-	}
-}
-
-/*
- * We want to know the TID of the threads we launch, not to complicate the code
- * with a real synchronization.
- */
-static volatile pid_t tid;
-static void set_tid(void)
-{
-	if (tid) {
-		fputs("Unexpected non null tid\n", stderr);
-		exit(1);
-	}
-
-	tid = syscall(SYS_gettid);
-}
-
-static pid_t start_thread(void (*fun) (void), int wait)
-{
-	pthread_t thread;
-
-	tid = 0;
-	if (pthread_create(&thread, NULL, (void *(*)(void *))fun, NULL) < 0) {
-		perror("pthread_create");
-		exit(1);
-	}
-
-	/* Busy wait for the thread to update its tid. */
-	while (!tid)
-		sched_yield();
-
-	if (wait && pthread_join(thread, NULL) < 0) {
-		perror("pthread_join");
-		exit(1);
-	}
-
-	/* Space the starting time of the threads */
-	sleep(1);
-
-	return tid;
-}
-
-/* The created threads */
-
-/*
- * Should loop in kernel mode
- */
-static void niced_sys_thread(void)
-{
-	set_tid();
-	nice(5);
-	loop_reading("/proc/self/maps");
-}
-
-/*
- * Should loop in user mode
- */
-static void niced_user_thread(void)
-{
-	set_tid();
-	nice(10);
-	for (;;) ;
-}
-
-/*
- * Should show some I/O syscalls
- */
-static void cached_io_thread(void)
-{
-	set_tid();
-	nice(15);
-	loop_reading("/bin/ls");
-}
-
-/*
- * This thread terminates after doing some real I/O so it should be visible in
- * the thread group stats.
- */
-#define TMP_PATH "/tmp/taskstats.test.tmp"
-static void dead_thread_having_written(void)
-{
-	int fd, i;
-	char buffer[1024];
-
-	set_tid();
-	fd = creat(TMP_PATH, 0600);
-	if (fd < 0) {
-		perror(TMP_PATH);
-		return;
-	}
-
-	/* Write 32M */
-	for (i = 0; i < 32 * 1024; i++) {
-		int remaining = sizeof(buffer);
-		while (remaining) {
-			int written = write(fd, buffer, remaining);
-			if (written > 0)
-				remaining -= written;
-			else {
-				perror("write");
-				close(fd);
-				return;
-			}
-		}
-	}
-
-	if (fsync(fd) < 0)
-		perror("fsync");
-
-	if (close(fd) < 0)
-		perror("close");
-
-	if (unlink(TMP_PATH))
-		perror("unlink");
-}
-
-/* taskstats reading using libnl */
-
-static int taskstats_netlink_family;
-static struct nl_handle *netlink_handle;
-
-static void init_taskstats(void)
-{
-	netlink_handle = nl_handle_alloc();
-	if (!netlink_handle) {
-		nl_perror("nl_handle_alloc");
-		exit(1);
-	}
-
-	if (genl_connect(netlink_handle) < 0) {
-		nl_perror("genl_connect");
-		exit(1);
-	}
-
-	taskstats_netlink_family = genl_ctrl_resolve(netlink_handle,
-						     TASKSTATS_GENL_NAME);
-	if (taskstats_netlink_family < 0) {
-		nl_perror("genl_ctrl_resolve(TASKSTATS_GENL_NAME)");
-		exit(1);
-	}
-}
-
-static struct taskstats get_taskstats(int attr, int pid)
-{
-	struct taskstats stats;
-	int len;
-	struct nl_msg *request;
-	void *request_header;
-	unsigned char *buf;
-	struct nlattr *nlattr, *reply;
-
-	request = nlmsg_alloc();
-	if (request == NULL) {
-		nl_perror("nlmsg_alloc");
-		exit(1);
-	}
-
-	request_header = genlmsg_put(request, 0, 0, taskstats_netlink_family,
-				     0, NLM_F_REQUEST, TASKSTATS_CMD_GET,
-				     TASKSTATS_GENL_VERSION);
-	if (request_header == NULL) {
-		nl_perror("genlmsg_put");
-		exit(1);
-	}
-
-	if (nla_put_u32(request, attr, pid) < 0) {
-		nl_perror("nla_put_u32");
-		exit(1);
-	}
-
-	len = nl_send_auto_complete(netlink_handle, request);
-	if (len < 0) {
-		nl_perror("nl_send_auto_complete");
-		exit(1);
-	}
-	nlmsg_free(request);
-
-	len = nl_recv(netlink_handle, NULL, &buf, NULL);
-	if (len < 0) {
-		nl_perror("nl_recv");
-		exit(1);
-	}
-	if (nl_wait_for_ack(netlink_handle) < 0) {
-		nl_perror("nl_wait_for_ack");
-		exit(1);
-	}
-
-	len = 0;
-	reply = (struct nlattr *)buf;
-	nla_for_each_nested(nlattr, reply, len)
-	    if (nlattr->nla_type == TASKSTATS_TYPE_STATS) {
-		memcpy(&stats, nla_data(nlattr), sizeof(stats));
-		free(buf);
-		return stats;
-	}
-
-	fputs("TASKSTATS_TYPE_STATS not found\n", stderr);
-	free(buf);
-	exit(1);
-}
-
-/* Output formatting */
-
-#define LINE(fo, f) do {						    \
-	char *stripped = strndup(#f, 14);				    \
-	printf("%-14s|" fo "|" fo "|" fo "|" fo "|" fo "|\n", stripped,	    \
-	       stats[0].f, stats[1].f, stats[2].f, stats[3].f, stats[4].f); \
-	free(stripped);							    \
-} while (0)
-
-static void show_table(struct taskstats stats[])
-{
-	puts("Name          |      System|        User|  Cached I/O"
-	     "|        Self|       Group|");
-	puts("--------------+------------+------------+------------"
-	     "+------------+------------+");
-	LINE("%12hu", version);
-	LINE("%12u", ac_exitcode);
-	LINE("%12x", ac_flag);
-	LINE("%12u", ac_nice);
-	LINE("%12llu", cpu_count);
-	LINE("%12llu", cpu_delay_total);
-	LINE("%12llu", blkio_delay_total);
-	LINE("%12llu", swapin_count);
-	LINE("%12llu", swapin_delay_total);
-	LINE("%12llu", cpu_run_real_total);
-	LINE("%12llu", cpu_run_virtual_total);
-	LINE("%12s", ac_comm);
-	LINE("%12u", ac_uid);
-	LINE("%12u", ac_gid);
-	LINE("%12u", ac_pid);
-	LINE("%12u", ac_ppid);
-	LINE("%12u", ac_btime);
-	LINE("%12llu", ac_etime);
-	LINE("%12llu", ac_utime);
-	LINE("%12llu", ac_stime);
-	LINE("%12llu", ac_minflt);
-	LINE("%12llu", ac_majflt);
-	LINE("%12llu", coremem);
-	LINE("%12llu", virtmem);
-	LINE("%12llu", hiwater_rss);
-	LINE("%12llu", hiwater_vm);
-	LINE("%12llu", read_char);
-	LINE("%12llu", write_char);
-	LINE("%12llu", read_syscalls);
-	LINE("%12llu", write_syscalls);
-	LINE("%12llu", read_bytes);
-	LINE("%12llu", write_bytes);
-	LINE("%12llu", cancelled_write_bytes);
-	LINE("%12llu", nvcsw);
-	LINE("%12llu", nivcsw);
-}
-
-int main(int argc, char *argv[])
-{
-	struct taskstats stats[5];
-	pid_t niced_sys = start_thread(niced_sys_thread, 0);
-	pid_t niced_user = start_thread(niced_user_thread, 0);
-	pid_t cached_io = start_thread(cached_io_thread, 0);
-	start_thread(dead_thread_having_written, 1);
-
-	init_taskstats();
-
-	stats[0] = get_taskstats(TASKSTATS_CMD_ATTR_PID, niced_sys);
-	stats[1] = get_taskstats(TASKSTATS_CMD_ATTR_PID, niced_user);
-	stats[2] = get_taskstats(TASKSTATS_CMD_ATTR_PID, cached_io);
-	stats[3] = get_taskstats(TASKSTATS_CMD_ATTR_PID, getpid());
-	stats[4] = get_taskstats(TASKSTATS_CMD_ATTR_TGID, cached_io);
-
-	show_table(stats);
-
-	return 0;
-}
diff -puN include/linux/tsacct_kern.h~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4 include/linux/tsacct_kern.h
--- a/include/linux/tsacct_kern.h~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4
+++ a/include/linux/tsacct_kern.h
@@ -10,17 +10,23 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
+static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
 {}
 #endif /* CONFIG_TASKSTATS */
 
 #ifdef CONFIG_TASK_XACCT
-extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
 extern void acct_update_integrals(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
+static inline void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
 static inline void acct_update_integrals(struct task_struct *tsk)
diff -puN kernel/taskstats.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4 kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4
+++ a/kernel/taskstats.c
@@ -167,7 +167,11 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
-/*
+/**
+ * fill_threadgroup - initialize some common stats for the thread group
+ * @stats: the taskstats to write into
+ * @task: the thread representing the whole group
+ *
  * There are two types of taskstats fields when considering a thread group:
  *	- those that can be aggregated from each thread in the group (like CPU
  *	times),
@@ -194,7 +198,11 @@ static void fill_threadgroup(struct task
 	xacct_fill_threadgroup(stats, task);
 }
 
-/*
+/**
+ * add_tsk - combine some thread specific stats in a taskstats
+ * @stats: the taskstats to write into
+ * @task: the thread to combine
+ *
  * Stats specific to each thread in the thread group. Stats of @task should be
  * combined with those already present in @stats. add_tsk() works in
  * conjunction with fill_threadgroup(), taskstats fields should not be touched
@@ -251,7 +259,6 @@ static int fill_tgid(pid_t tgid, struct 
 		struct taskstats *stats)
 {
 	struct task_struct *tsk;
-	struct task_struct *leader;
 	unsigned long flags;
 	int rc = -ESRCH;
 
@@ -271,15 +278,21 @@ static int fill_tgid(pid_t tgid, struct 
 	else
 		memset(stats, 0, sizeof(*stats));
 
-	leader = first->group_leader;
-	fill_threadgroup(stats, leader);
+	fill_threadgroup(stats, first->group_leader);
 
 	tsk = first;
 	do
 		if (!tsk->exit_state)
+			/*
+			 * This check is racy as a thread could exit just right
+			 * now and have its statistics accounted twice.
+			 */
 			add_tsk(stats, tsk);
 	while_each_thread(first, tsk);
 
+	if (first->signal->group_exit_code >> 8)
+		stats->ac_exitcode = first->signal->group_exit_code >> 8;
+
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
@@ -291,19 +304,18 @@ out:
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
-	struct taskstats *tg_stats;
 
-	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	tg_stats = tsk->signal->stats;
+	rcu_read_lock();
+	lock_task_sighand(tsk, &flags);
 
 	/*
-	 * fill_threadgroup() will be called by the stats requester,
-	 * i.e. fill_tgid()
+	 * The fill_threadgroup() part of the statistics will be added by the
+	 * stats requester, i.e. fill_tgid()
 	 */
-	if (tg_stats)
-		add_tsk(tg_stats, tsk);
+	add_tsk(tsk->signal->stats, tsk);
 
-	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	unlock_task_sighand(tsk, &flags);
+	rcu_read_unlock();
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
diff -puN kernel/tsacct.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4 kernel/tsacct.c
--- a/kernel/tsacct.c~taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4
+++ a/kernel/tsacct.c
@@ -50,19 +50,14 @@ void bacct_fill_threadgroup(struct tasks
 				rcu_dereference(task->real_parent)->tgid : 0;
 	rcu_read_unlock();
 
-	if (thread_group_leader(task)) {
-		stats->ac_exitcode = task->exit_code;
-		if (task->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
-
 	fill_wall_times(stats, task);
 
-	stats->ac_nice	= task_nice(task);
-	stats->ac_sched	= task->policy;
-	stats->ac_uid	= task->uid;
-	stats->ac_gid	= task->gid;
-	stats->ac_pid	= task->pid;
+	stats->ac_exitcode	= task->exit_code >> 8;
+	stats->ac_nice		= task_nice(task);
+	stats->ac_sched		= task->policy;
+	stats->ac_uid		= task->uid;
+	stats->ac_gid		= task->gid;
+	stats->ac_pid		= task->pid;
 
 	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
 }
@@ -75,6 +70,12 @@ void bacct_add_tsk(struct taskstats *sta
 		stats->ac_flag |= ACORE;
 	if (task->flags & PF_SIGNALED)
 		stats->ac_flag |= AXSIG;
+	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
+		/*
+		 * Threads are created by do_fork() and don't exec but not in
+		 * the AFORK sense, as the latter involves fork(2).
+		 */
+		stats->ac_flag |= AFORK;
 
 	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
 	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid-v4.patch
sync_sb_inodes-propagate-errors.patch
