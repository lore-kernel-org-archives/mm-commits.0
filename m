From: akpm@linux-foundation.org
Subject: - cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:15 -0700
Message-ID: <200807070305.m6735F2K004806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258AbYGGDF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mtk.manpages@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: document proc status cpus and mems allowed lists
has been removed from the -mm tree.  Its filename was
     cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: document proc status cpus and mems allowed lists
From: Paul Jackson <pj@sgi.com>

Provide a little documentation for the two new fields, Cpus_allowed_list
and Mems_allowed_list, that were added to each /proc/<pid>/status file a
while back.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/cpusets.txt~cpusets-document-proc-status-cpus-and-mems-allowed-lists Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpusets-document-proc-status-cpus-and-mems-allowed-lists
+++ a/Documentation/cpusets.txt
@@ -154,13 +154,15 @@ browsing and modifying the cpusets prese
 new system calls are added for cpusets - all support for querying and
 modifying cpusets is via this cpuset file system.
 
-The /proc/<pid>/status file for each task has two added lines,
+The /proc/<pid>/status file for each task has four added lines,
 displaying the tasks cpus_allowed (on which CPUs it may be scheduled)
 and mems_allowed (on which Memory Nodes it may obtain memory),
-in the format seen in the following example:
+in the two formats seen in the following example:
 
   Cpus_allowed:   ffffffff,ffffffff,ffffffff,ffffffff
+  Cpus_allowed_list:      0-127
   Mems_allowed:   ffffffff,ffffffff
+  Mems_allowed_list:      0-63
 
 Each cpuset is represented by a directory in the cgroup file system
 containing (on top of the standard cgroup files) the following
_

Patches currently in -mm which might be from pj@sgi.com are

linux-next.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch

