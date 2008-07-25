From: akpm@linux-foundation.org
Subject: - per-task-delay-accounting-add-memory-reclaim-delay.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:14 -0700
Message-ID: <200807252303.m6PN3EDR003939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbYGYXHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kobayashi.kk@ncos.nec.co.jp, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujistu.com, mm-commits@vger.kernel.org


The patch titled
     per-task-delay-accounting: add memory reclaim delay
has been removed from the -mm tree.  Its filename was
     per-task-delay-accounting-add-memory-reclaim-delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: per-task-delay-accounting: add memory reclaim delay
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Sometimes, application responses become bad under heavy memory load. 
Applications take a bit time to reclaim memory.  The statistics, how long
memory reclaim takes, will be useful to measure memory usage.

This patch adds accounting memory reclaim to per-task-delay-accounting for
accounting the time of do_try_to_free_pages().

<i.e>

- When System is under low memory load,
  memory reclaim may not occur.

$ free
             total       used       free     shared    buffers     cached
Mem:       8197800    1577300    6620500          0       4808    1516724
-/+ buffers/cache:      55768    8142032
Swap:     16386292          0   16386292

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 5069748  10612 3014060    0    0     0     0    3   26  0  0 100  0
 0  0      0 5069748  10612 3014060    0    0     0     0    4   22  0  0 100  0
 0  0      0 5069748  10612 3014060    0    0     0     0    3   18  0  0 100  0

Measure the time of tar command.

$ ls -s test.dat
1501472 test.dat

$ time tar cvf test.tar test.dat
real    0m13.388s
user    0m0.116s
sys     0m5.304s

$ ./delayget -d -p <pid>
CPU             count     real total  virtual total    delay total
                  428     5528345500     5477116080       62749891
IO              count    delay total
                  338     8078977189
SWAP            count    delay total
                    0              0
RECLAIM         count    delay total
                    0              0

- When system is under heavy memory load
  memory reclaim may occur.

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0 7159032  49724   1812   3012    0    0     0     0    3   24  0  0 100  0
 0  0 7159032  49724   1812   3012    0    0     0     0    4   24  0  0 100  0
 0  0 7159032  49848   1812   3012    0    0     0     0    3   22  0  0 100  0

In this case, one process uses more 8G memory
by execution of malloc() and memset().

$ time tar cvf test.tar test.dat
real    1m38.563s        <-  increased by 85 sec
user    0m0.140s
sys     0m7.060s

$ ./delayget -d -p <pid>
CPU             count     real total  virtual total    delay total
                 9021     7140446250     7315277975      923201824
IO              count    delay total
                 8965    90466349669
SWAP            count    delay total
                    3       21036367
RECLAIM         count    delay total
                  740    61011951153

In the later case, the value of RECLAIM is increasing.
So, taskstats can show how much memory reclaim influences TAT.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujistu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h |   19 +++++++++++++++++++
 include/linux/sched.h     |    4 ++++
 kernel/delayacct.c        |   13 +++++++++++++
 mm/vmscan.c               |    5 +++++
 4 files changed, 41 insertions(+)

diff -puN include/linux/delayacct.h~per-task-delay-accounting-add-memory-reclaim-delay include/linux/delayacct.h
--- a/include/linux/delayacct.h~per-task-delay-accounting-add-memory-reclaim-delay
+++ a/include/linux/delayacct.h
@@ -39,6 +39,8 @@ extern void __delayacct_blkio_start(void
 extern void __delayacct_blkio_end(void);
 extern int __delayacct_add_tsk(struct taskstats *, struct task_struct *);
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
+extern void __delayacct_freepages_start(void);
+extern void __delayacct_freepages_end(void);
 
 static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
 {
@@ -107,6 +109,18 @@ static inline __u64 delayacct_blkio_tick
 	return 0;
 }
 
+static inline void delayacct_freepages_start(void)
+{
+	if (current->delays)
+		__delayacct_freepages_start();
+}
+
+static inline void delayacct_freepages_end(void)
+{
+	if (current->delays)
+		__delayacct_freepages_end();
+}
+
 #else
 static inline void delayacct_set_flag(int flag)
 {}
@@ -129,6 +143,11 @@ static inline __u64 delayacct_blkio_tick
 { return 0; }
 static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
 { return 0; }
+static inline void delayacct_freepages_start(void)
+{}
+static inline void delayacct_freepages_end(void)
+{}
+
 #endif /* CONFIG_TASK_DELAY_ACCT */
 
 #endif
diff -puN include/linux/sched.h~per-task-delay-accounting-add-memory-reclaim-delay include/linux/sched.h
--- a/include/linux/sched.h~per-task-delay-accounting-add-memory-reclaim-delay
+++ a/include/linux/sched.h
@@ -672,6 +672,10 @@ struct task_delay_info {
 				/* io operations performed */
 	u32 swapin_count;	/* total count of the number of swapin block */
 				/* io operations performed */
+
+	struct timespec freepages_start, freepages_end;
+	u64 freepages_delay;	/* wait for memory reclaim */
+	u32 freepages_count;	/* total count of memory reclaim */
 };
 #endif	/* CONFIG_TASK_DELAY_ACCT */
 
diff -puN kernel/delayacct.c~per-task-delay-accounting-add-memory-reclaim-delay kernel/delayacct.c
--- a/kernel/delayacct.c~per-task-delay-accounting-add-memory-reclaim-delay
+++ a/kernel/delayacct.c
@@ -165,3 +165,16 @@ __u64 __delayacct_blkio_ticks(struct tas
 	return ret;
 }
 
+void __delayacct_freepages_start(void)
+{
+	delayacct_start(&current->delays->freepages_start);
+}
+
+void __delayacct_freepages_end(void)
+{
+	delayacct_end(&current->delays->freepages_start,
+			&current->delays->freepages_end,
+			&current->delays->freepages_delay,
+			&current->delays->freepages_count);
+}
+
diff -puN mm/vmscan.c~per-task-delay-accounting-add-memory-reclaim-delay mm/vmscan.c
--- a/mm/vmscan.c~per-task-delay-accounting-add-memory-reclaim-delay
+++ a/mm/vmscan.c
@@ -38,6 +38,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/memcontrol.h>
+#include <linux/delayacct.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1316,6 +1317,8 @@ static unsigned long do_try_to_free_page
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 
+	delayacct_freepages_start();
+
 	if (scan_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
 	/*
@@ -1396,6 +1399,8 @@ out:
 	} else
 		mem_cgroup_record_reclaim_priority(sc->mem_cgroup, priority);
 
+	delayacct_freepages_end();
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from kobayashi.kk@ncos.nec.co.jp are

origin.patch

