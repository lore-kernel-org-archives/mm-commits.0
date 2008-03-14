From: akpm@linux-foundation.org
Subject: + memcgroup-implement-failcounter-reset.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:56:31 -0700
Message-ID: <200803141956.m2EJuVac016678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYCNT5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     memcgroup: implement failcounter reset
has been added to the -mm tree.  Its filename is
     memcgroup-implement-failcounter-reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: implement failcounter reset
From: Pavel Emelyanov <xemul@openvz.org>

This is a very common requirement from people using the resource accounting
facilities (not only memcgroup but also OpenVZ beancounters).  They want to
put the cgroup in an initial state without re-creating it.

For example after re-configuring a group people want to observe how this new
configuration fits the group needs without saving the previous failcnt value.

Merge two resets into one mem_cgroup_reset() function to demonstrate how
multiplexing work.

Besides, I have plans to move the files, that correspond to res_counter to the
res_counter.c file and somehow "import" them into controller.  I don't know
how to make it gracefully yet, but merging resets of max_usage and failcnt in
one function will be there for sure.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    8 ++++++++
 mm/memcontrol.c             |   14 +++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN include/linux/res_counter.h~memcgroup-implement-failcounter-reset include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcgroup-implement-failcounter-reset
+++ a/include/linux/res_counter.h
@@ -143,4 +143,12 @@ static inline void res_counter_reset_max
 	spin_unlock_irqrestore(&cnt->lock, flags);
 }
 
+static inline void res_counter_reset_failcnt(struct res_counter *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->failcnt = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+}
 #endif
diff -puN mm/memcontrol.c~memcgroup-implement-failcounter-reset mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-implement-failcounter-reset
+++ a/mm/memcontrol.c
@@ -870,12 +870,19 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
-static int mem_cgroup_max_reset(struct cgroup *cont, unsigned int event)
+static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
 
 	mem = mem_cgroup_from_cont(cont);
-	res_counter_reset_max(&mem->res);
+	switch (event) {
+		case RES_MAX_USAGE:
+			res_counter_reset_max(&mem->res);
+			break;
+		case RES_FAILCNT:
+			res_counter_reset_failcnt(&mem->res);
+			break;
+	}
 	return 0;
 }
 
@@ -929,7 +936,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "max_usage_in_bytes",
 		.private = RES_MAX_USAGE,
-		.trigger = mem_cgroup_max_reset,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
@@ -941,6 +948,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
git-udf.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
binfmt_miscc-avoid-potential-kernel-stack-overflow.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

