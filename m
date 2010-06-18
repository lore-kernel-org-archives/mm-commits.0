From: akpm@linux-foundation.org
Subject: + sched-fix-over-scheduling-performance-regression.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:59:22 -0700
Message-ID: <201006182259.o5IMxMHO028167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab0FRW7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu, stable@kernel.org, suresh.b.siddha@intel.com, tim.c.chen@linux.intel.com, yanmin.zhang@intel.com, yanmin_zhang@linux.intel.com


The patch titled
     sched: fix over-scheduling performance regression
has been added to the -mm tree.  Its filename is
     sched-fix-over-scheduling-performance-regression.patch

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
Subject: sched: fix over-scheduling performance regression
From: "Alex,Shi" <alex.shi@intel.com>

commit e709715915d6 ("sched: Optimize unused cgroup configuration")
introduced an imbalance schedule issue.  If we do not use CGROUP, function
update_h_load won't want to update h_load.  When the system has a large
number of tasks far more than logical CPU number, the incorrect
cfs_rq[cpu]->h_load value will cause load_balance() to pull too many tasks
to local CPU from the busiest CPU.  So the busiest CPU keeps being in a
round robin.  That will hurt performance.

The issue was found originally by a scientific calculation workload that
developed by Yanmin.  with the commit, the workload performance drops
about 40% from this commit.  We can be reproduced by a short program as
following.

# gcc -o sl sched-loop.c -lpthread
# ./sl -n 100 -t 100 &
# cat /proc/sched_debug &> sd1
# grep -A 1 cpu# sd1
sd1:cpu#0, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#1, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#2, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#3, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#4, 2533.008 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#5, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#6, 2533.008 MHz
sd1-  .nr_running                    : 10
--
sd1:cpu#7, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#8, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#9, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#10, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#11, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#12, 2533.008 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#13, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#14, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#15, 2533.008 MHz
sd1-  .nr_running                    : 1

After apply the fixing patch, cfs_rq get balance.

sd1:cpu#0, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#1, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#2, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#3, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#4, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#5, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#6, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#7, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#8, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#9, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#10, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#11, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#12, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#13, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#14, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#15, 2533.479 MHz
sd1-  .nr_running                    : 6

---
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

volatile int * exiting;

void *idle_loop(){
        volatile int calc01 = 100;
        while(*exiting !=1)
                calc01++;
}
int main(int argc, char *argv[]){
        int                     i, t, c, er=0, num=8;
        static  char            optstr[] = "n:t:";
        pthread_t                       ptid[1024];

        while ((c = getopt(argc, argv, optstr)) != EOF)
                switch (c) {
                case 'n':
                        num = atoi(optarg);
                        break;
                case 't':
                        t = atoi(optarg);
                        break;
                case '?':
                        er = 1;
                        break;
                }

        if (er) {
                printf("usage: %s %s\n", argv[0], optstr);
                exit(1);
        }
        exiting = malloc(sizeof(int));

        *exiting = 0;
        for(i=0; i<num ; i++)
                pthread_create(&ptid[i], NULL, idle_loop, NULL);

        sleep(t);
        *exiting = 1;

        for (i=0; i<num; i++)
                pthread_join(ptid[i], NULL);
        exit(0);

}

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Yanmin zhang <yanmin.zhang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sched.c~sched-fix-over-scheduling-performance-regression kernel/sched.c
--- a/kernel/sched.c~sched-fix-over-scheduling-performance-regression
+++ a/kernel/sched.c
@@ -1666,9 +1666,6 @@ static void update_shares(struct sched_d
 
 static void update_h_load(long cpu)
 {
-	if (root_task_group_empty())
-		return;
