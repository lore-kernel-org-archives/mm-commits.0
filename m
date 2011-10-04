From: akpm@google.com
Subject: [obsolete] cgroups-create-a-workqueue-for-cgroup.patch removed from -mm tree
Date: Tue, 04 Oct 2011 14:10:31 -0700
Message-ID: <201110042110.p94LAVvo011910@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801Ab1JDVKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, miaox@cn.fujitsu.com, mingo@redhat.com, paul@paulmenage.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: create a workqueue for cgroup
has been removed from the -mm tree.  Its filename was
     cgroups-create-a-workqueue-for-cgroup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: cgroups: create a workqueue for cgroup

In f90d4118 ("cpuset: fix possible deadlock in
async_rebuild_sched_domains"), cpuset_wq, a separate workqueue for cpuset,
was introduced to avoid a deadlock against cgroup_mutex between
async_rebuild_sched_domains() and cgroup_tasks_write().

But check_for_release() has a similar problem:

  check_for_release()
    schedule_work(release_agent_work)
      cgroup_release_agent()
        mutex_lock(&cgroup_mutex)

And I actually see a lockup which seems to be caused by this problem
on 2.6.32-131.0.15.el6.x86_64.

    [59161.355412] INFO: task events/2:37 blocked for more than 120 seconds.
    [59161.358404] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [59161.361472] events/2      D 0000000000000002     0    37      2 0x00000000
    [59161.364460]  ffff88007db51d10 0000000000000046 0000000000000086 0000000000000003
    [59161.377729]  0000000000000001 000000004da0228a ffff88007db51cc0 7fffffffffffffff
    [59161.390090]  ffff88007db4a6b8 ffff88007db51fd8 000000000000f598 ffff88007db4a6b8
    [59161.413749] Call Trace:
    [59161.415084]  [<ffffffff814dc84e>] __mutex_lock_slowpath+0x13e/0x180
    [59161.417861]  [<ffffffff814dc6eb>] mutex_lock+0x2b/0x50
    [59161.420013]  [<ffffffff810bcfb1>] cgroup_release_agent+0x101/0x240
    [59161.422701]  [<ffffffff8108e44e>] ? prepare_to_wait+0x4e/0x80
    [59161.425164]  [<ffffffff810bceb0>] ? cgroup_release_agent+0x0/0x240
    [59161.427878]  [<ffffffff81088830>] worker_thread+0x170/0x2a0
    [59161.430428]  [<ffffffff8108e160>] ? autoremove_wake_function+0x0/0x40
    [59161.435173]  [<ffffffff810886c0>] ? worker_thread+0x0/0x2a0
    [59161.439267]  [<ffffffff8108ddf6>] kthread+0x96/0xa0
    [59161.441864]  [<ffffffff8100c1ca>] child_rip+0xa/0x20
    [59161.444076]  [<ffffffff8108dd60>] ? kthread+0x0/0xa0
    [59161.448333]  [<ffffffff8100c1c0>] ? child_rip+0x0/0x20
    ...
    [59161.728561] INFO: task move_task:14311 blocked for more than 120 seconds.
    [59161.733614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [59161.740374] move_task     D 0000000000000000     0 14311   7337 0x00000080
    [59161.749131]  ffff8800c8bbf968 0000000000000082 0000000000000000 ffff8800c8bbf92c
    [59161.758975]  ffff8800c8bbf8e8 ffff88007fc24100 ffff880028315f80 00000001037f9572
    [59161.764257]  ffff8800c8868678 ffff8800c8bbffd8 000000000000f598 ffff8800c8868678
    [59161.773686] Call Trace:
    [59161.775375]  [<ffffffff814dc065>] schedule_timeout+0x215/0x2e0
    [59161.781194]  [<ffffffff814dbce3>] wait_for_common+0x123/0x180
    [59161.786500]  [<ffffffff8105dc60>] ? default_wake_function+0x0/0x20
    [59161.791399]  [<ffffffff81124180>] ? lru_add_drain_per_cpu+0x0/0x10
    [59161.798017]  [<ffffffff814dbdfd>] wait_for_completion+0x1d/0x20
    [59161.801644]  [<ffffffff81089227>] flush_work+0x77/0xc0
    [59161.816983]  [<ffffffff81088cb0>] ? wq_barrier_func+0x0/0x20
    [59161.819407]  [<ffffffff810893a3>] schedule_on_each_cpu+0x133/0x180
    [59161.822816]  [<ffffffff81123855>] lru_add_drain_all+0x15/0x20
    [59161.825066]  [<ffffffff8115f6fe>] migrate_prep+0xe/0x20
    [59161.827263]  [<ffffffff8115252b>] do_migrate_pages+0x2b/0x210
    [59161.829802]  [<ffffffff81151f45>] ? mpol_rebind_task+0x15/0x20
    [59161.832249]  [<ffffffff810bfcab>] ? cpuset_change_task_nodemask+0xdb/0x160
    [59161.835240]  [<ffffffff810c1198>] cpuset_migrate_mm+0x78/0xa0
    [59161.838663]  [<ffffffff810c25e7>] cpuset_attach+0x197/0x1d0
    [59161.844383]  [<ffffffff810be87e>] cgroup_attach_task+0x21e/0x660
    [59161.849009]  [<ffffffff810be520>] ? cgroup_file_open+0x0/0x140
    [59161.854371]  [<ffffffff8116fbcf>] ? __dentry_open+0x23f/0x360
    [59161.857754]  [<ffffffff814dc6de>] ? mutex_lock+0x1e/0x50
    [59161.863157]  [<ffffffff810bf00c>] cgroup_tasks_write+0x5c/0xf0
    [59161.868148]  [<ffffffff810bc01a>] cgroup_file_write+0x2ba/0x320
    [59161.873288]  [<ffffffff811910b0>] ? mntput_no_expire+0x30/0x110
    [59161.876954]  [<ffffffff81172718>] vfs_write+0xb8/0x1a0
    [59161.881499]  [<ffffffff810d1b62>] ? audit_syscall_entry+0x272/0x2a0
    [59161.890183]  [<ffffffff81173151>] sys_write+0x51/0x90
    [59161.893340]  [<ffffffff8100b172>] system_call_fastpath+0x16/0x1b

Fix this problem by creating cgroup_wq, and make both
async_rebuild_domains() and check_for_release() use it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: <stable@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/cgroup.h |    3 +++
 init/main.c            |    1 +
 kernel/cgroup.c        |   21 ++++++++++++++++++++-
 kernel/cpuset.c        |   13 +------------
 4 files changed, 25 insertions(+), 13 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-create-a-workqueue-for-cgroup include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-create-a-workqueue-for-cgroup
+++ a/include/linux/cgroup.h
@@ -27,6 +27,8 @@ struct css_id;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
+extern void cgroup_wq_init(void);
+extern void queue_cgroup_work(struct work_struct *work);
 extern void cgroup_lock(void);
 extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
@@ -631,6 +633,7 @@ struct cgroup_subsys_state *cgroup_css_f
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
+static inline void cgroup_wq_init(void) {}
 static inline void cgroup_fork(struct task_struct *p) {}
 static inline void cgroup_fork_callbacks(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
diff -puN init/main.c~cgroups-create-a-workqueue-for-cgroup init/main.c
--- a/init/main.c~cgroups-create-a-workqueue-for-cgroup
+++ a/init/main.c
@@ -724,6 +724,7 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
+	cgroup_wq_init();
 	cpuset_init_smp();
 	usermodehelper_init();
 	shmem_init();
diff -puN kernel/cgroup.c~cgroups-create-a-workqueue-for-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-create-a-workqueue-for-cgroup
+++ a/kernel/cgroup.c
@@ -4374,6 +4374,25 @@ out:
 	return err;
 }
 
+/**
+ * cgroup_wq_init - initialize cgroup_wq
+ *
+ * cgroup_wq is a workqueue for cgroup related tasks.
+ * Using kevent workqueue may cause deadlock when memory_migrate of cpuset
+ * is set. So we create a separate workqueue thread for cgroup.
+ */
+static struct workqueue_struct *cgroup_wq;
+void __init cgroup_wq_init(void)
+{
+	cgroup_wq = create_singlethread_workqueue("cgroup");
+	BUG_ON(!cgroup_wq);
+}
+
+void queue_cgroup_work(struct work_struct *work)
+{
+	queue_work(cgroup_wq, work);
+}
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
@@ -4682,7 +4701,7 @@ static void check_for_release(struct cgr
 		}
 		raw_spin_unlock(&release_list_lock);
 		if (need_schedule_work)
-			schedule_work(&release_agent_work);
+			queue_cgroup_work(&release_agent_work);
 	}
 }
 
diff -puN kernel/cpuset.c~cgroups-create-a-workqueue-for-cgroup kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-create-a-workqueue-for-cgroup
+++ a/kernel/cpuset.c
@@ -61,14 +61,6 @@
 #include <linux/cgroup.h>
 
 /*
- * Workqueue for cpuset related tasks.
- *
- * Using kevent workqueue may cause deadlock when memory_migrate
- * is set. So we create a separate workqueue thread for cpuset.
- */
-static struct workqueue_struct *cpuset_wq;
-
-/*
  * Tracks how many cpusets are currently defined in system.
  * When there is only one cpuset (the root cpuset) we can
  * short circuit some hooks.
@@ -767,7 +759,7 @@ static DECLARE_WORK(rebuild_sched_domain
  */
 static void async_rebuild_sched_domains(void)
 {
-	queue_work(cpuset_wq, &rebuild_sched_domains_work);
+	queue_cgroup_work(&rebuild_sched_domains_work);
 }
 
 /*
@@ -2157,9 +2149,6 @@ void __init cpuset_init_smp(void)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
