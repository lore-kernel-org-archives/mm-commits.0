From: akpm@linux-foundation.org
Subject: + sysctl-fix-neighbour-table-sysctls.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:41:56 -0700
Message-ID: <200708100141.l7A1fu7W029568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbXHJBml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru, davem@davemloft.net


The patch titled
     sysctl: fix neighbour table sysctls.
has been added to the -mm tree.  Its filename is
     sysctl-fix-neighbour-table-sysctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: fix neighbour table sysctls.
From: Eric W. Biederman <ebiederm@xmission.com>

- In ipv6 ndisc_ifinfo_syctl_change so it doesn't depend on binary
  sysctl names for a function that works with proc.

- In neighbour.c reorder the table to put the possibly unused entries
  at the end so we can remove them by terminating the table early.

- In neighbour.c kill the entries with questionable binary sysctl
  handling behavior.

- In neighbour.c if we don't have a strategy routine remove the
  binary path.  So we don't the default sysctl strategy routine
  on data that is not ready for it.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/neighbour.c |   75 +++++++++++++++++++++--------------------
 net/ipv6/ndisc.c     |   24 +++++--------
 2 files changed, 49 insertions(+), 50 deletions(-)

diff -puN net/core/neighbour.c~sysctl-fix-neighbour-table-sysctls net/core/neighbour.c
--- a/net/core/neighbour.c~sysctl-fix-neighbour-table-sysctls
+++ a/net/core/neighbour.c
@@ -2498,7 +2498,6 @@ static struct neigh_sysctl_table {
 			.proc_handler	= &proc_dointvec,
 		},
 		{
-			.ctl_name	= NET_NEIGH_RETRANS_TIME,
 			.procname	= "retrans_time",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
@@ -2543,27 +2542,40 @@ static struct neigh_sysctl_table {
 			.proc_handler	= &proc_dointvec,
 		},
 		{
-			.ctl_name	= NET_NEIGH_ANYCAST_DELAY,
 			.procname	= "anycast_delay",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.proc_handler	= &proc_dointvec_userhz_jiffies,
 		},
 		{
-			.ctl_name	= NET_NEIGH_PROXY_DELAY,
 			.procname	= "proxy_delay",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.proc_handler	= &proc_dointvec_userhz_jiffies,
 		},
 		{
-			.ctl_name	= NET_NEIGH_LOCKTIME,
 			.procname	= "locktime",
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
 			.proc_handler	= &proc_dointvec_userhz_jiffies,
 		},
 		{
+			.ctl_name	= NET_NEIGH_RETRANS_TIME_MS,
+			.procname	= "retrans_time_ms",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_ms_jiffies,
+			.strategy	= &sysctl_ms_jiffies,
+		},
+		{
+			.ctl_name	= NET_NEIGH_REACHABLE_TIME_MS,
+			.procname	= "base_reachable_time_ms",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec_ms_jiffies,
+			.strategy	= &sysctl_ms_jiffies,
+		},
+		{
 			.ctl_name	= NET_NEIGH_GC_INTERVAL,
 			.procname	= "gc_interval",
 			.maxlen		= sizeof(int),
@@ -2592,22 +2604,7 @@ static struct neigh_sysctl_table {
 			.mode		= 0644,
 			.proc_handler	= &proc_dointvec,
 		},
-		{
-			.ctl_name	= NET_NEIGH_RETRANS_TIME_MS,
-			.procname	= "retrans_time_ms",
-			.maxlen		= sizeof(int),
-			.mode		= 0644,
-			.proc_handler	= &proc_dointvec_ms_jiffies,
-			.strategy	= &sysctl_ms_jiffies,
-		},
-		{
-			.ctl_name	= NET_NEIGH_REACHABLE_TIME_MS,
-			.procname	= "base_reachable_time_ms",
-			.maxlen		= sizeof(int),
-			.mode		= 0644,
-			.proc_handler	= &proc_dointvec_ms_jiffies,
-			.strategy	= &sysctl_ms_jiffies,
-		},
+		{}
 	},
 	.neigh_dev = {
 		{
@@ -2660,42 +2657,48 @@ int neigh_sysctl_register(struct net_dev
 	t->neigh_vars[9].data  = &p->anycast_delay;
 	t->neigh_vars[10].data = &p->proxy_delay;
 	t->neigh_vars[11].data = &p->locktime;
+	t->neigh_vars[12].data  = &p->retrans_time;
+	t->neigh_vars[13].data  = &p->base_reachable_time;
 
 	if (dev) {
 		dev_name_source = dev->name;
 		t->neigh_dev[0].ctl_name = dev->ifindex;
-		t->neigh_vars[12].procname = NULL;
-		t->neigh_vars[13].procname = NULL;
-		t->neigh_vars[14].procname = NULL;
-		t->neigh_vars[15].procname = NULL;
+		/* Terminate the table early */
+		memset(&t->neigh_vars[14], 0, sizeof(t->neigh_vars[14]));
 	} else {
 		dev_name_source = t->neigh_dev[0].procname;
-		t->neigh_vars[12].data = (int *)(p + 1);
-		t->neigh_vars[13].data = (int *)(p + 1) + 1;
-		t->neigh_vars[14].data = (int *)(p + 1) + 2;
-		t->neigh_vars[15].data = (int *)(p + 1) + 3;
+		t->neigh_vars[14].data = (int *)(p + 1);
+		t->neigh_vars[15].data = (int *)(p + 1) + 1;
+		t->neigh_vars[16].data = (int *)(p + 1) + 2;
+		t->neigh_vars[17].data = (int *)(p + 1) + 3;
 	}
 
-	t->neigh_vars[16].data  = &p->retrans_time;
-	t->neigh_vars[17].data  = &p->base_reachable_time;
 
 	if (handler || strategy) {
 		/* RetransTime */
 		t->neigh_vars[3].proc_handler = handler;
 		t->neigh_vars[3].strategy = strategy;
 		t->neigh_vars[3].extra1 = dev;
+		if (!strategy)
+			t->neigh_vars[3].ctl_name = CTL_UNNUMBERED;
 		/* ReachableTime */
 		t->neigh_vars[4].proc_handler = handler;
 		t->neigh_vars[4].strategy = strategy;
 		t->neigh_vars[4].extra1 = dev;
+		if (!strategy)
+			t->neigh_vars[4].ctl_name = CTL_UNNUMBERED;
 		/* RetransTime (in milliseconds)*/
-		t->neigh_vars[16].proc_handler = handler;
-		t->neigh_vars[16].strategy = strategy;
-		t->neigh_vars[16].extra1 = dev;
+		t->neigh_vars[12].proc_handler = handler;
+		t->neigh_vars[12].strategy = strategy;
+		t->neigh_vars[12].extra1 = dev;
+		if (!strategy)
+			t->neigh_vars[12].ctl_name = CTL_UNNUMBERED;
 		/* ReachableTime (in milliseconds) */
-		t->neigh_vars[17].proc_handler = handler;
-		t->neigh_vars[17].strategy = strategy;
-		t->neigh_vars[17].extra1 = dev;
+		t->neigh_vars[13].proc_handler = handler;
+		t->neigh_vars[13].strategy = strategy;
+		t->neigh_vars[13].extra1 = dev;
+		if (!strategy)
+			t->neigh_vars[13].ctl_name = CTL_UNNUMBERED;
 	}
 
 	dev_name = kstrdup(dev_name_source, GFP_KERNEL);
diff -puN net/ipv6/ndisc.c~sysctl-fix-neighbour-table-sysctls net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c~sysctl-fix-neighbour-table-sysctls
+++ a/net/ipv6/ndisc.c
@@ -1570,30 +1570,26 @@ int ndisc_ifinfo_sysctl_change(struct ct
 	struct inet6_dev *idev;
 	int ret;
 
-	if (ctl->ctl_name == NET_NEIGH_RETRANS_TIME ||
-	    ctl->ctl_name == NET_NEIGH_REACHABLE_TIME)
+	if ((strcmp(ctl->procname, "retrans_time") == 0) ||
+	    (strcmp(ctl->procname, "base_reachable_time") == 0))
 		ndisc_warn_deprecated_sysctl(ctl, "syscall", dev ? dev->name : "default");
 
-	switch (ctl->ctl_name) {
-	case NET_NEIGH_RETRANS_TIME:
+	if (strcmp(ctl->procname, "retrans_time") == 0)
 		ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
-		break;
-	case NET_NEIGH_REACHABLE_TIME:
+
+	else if (strcmp(ctl->procname, "base_reachable_time") == 0)
 		ret = proc_dointvec_jiffies(ctl, write,
 					    filp, buffer, lenp, ppos);
-		break;
-	case NET_NEIGH_RETRANS_TIME_MS:
-	case NET_NEIGH_REACHABLE_TIME_MS:
+
+	else if ((strcmp(ctl->procname, "retrans_time_ms") == 0) ||
+		 (strcmp(ctl->procname, "base_reacable_time_ms") == 0))
 		ret = proc_dointvec_ms_jiffies(ctl, write,
 					       filp, buffer, lenp, ppos);
-		break;
-	default:
+	else
 		ret = -1;
-	}
 
 	if (write && ret == 0 && dev && (idev = in6_dev_get(dev)) != NULL) {
-		if (ctl->ctl_name == NET_NEIGH_REACHABLE_TIME ||
-		    ctl->ctl_name == NET_NEIGH_REACHABLE_TIME_MS)
+		if (ctl->data == &idev->nd_parms->base_reachable_time)
 			idev->nd_parms->reachable_time = neigh_rand_reach_time(idev->nd_parms->base_reachable_time);
 		idev->tstamp = jiffies;
 		inet6_ifinfo_notify(RTM_NEWLINK, idev);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

remove-unused-struct-proc_dir_entryset.patch
dvb_en_50221-convert-to-kthread-api.patch
x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
