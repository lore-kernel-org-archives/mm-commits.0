From: akpm@linux-foundation.org
Subject: + cpusets-update_cpumask-documentation-fix.patch added to -mm tree
Date: Mon, 04 Feb 2008 13:57:20 -0800
Message-ID: <200802042157.m14LvK2i019562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbYBDV52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 16:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, cpw@sgi.com, menage@google.com, rientjes@google.com


The patch titled
     cpusets: update_cpumask documentation fix
has been added to the -mm tree.  Its filename is
     cpusets-update_cpumask-documentation-fix.patch

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
Subject: cpusets: update_cpumask documentation fix
From: Paul Jackson <pj@sgi.com>

Update cpuset documentation to match the October 2007 "Fix cpusets
update_cpumask" changes that now apply changes to a cpusets 'cpus' allowed
mask immediately to the cpus_allowed of the tasks in that cpuset.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Cliff Wickman <cpw@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN Documentation/cpusets.txt~cpusets-update_cpumask-documentation-fix Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpusets-update_cpumask-documentation-fix
+++ a/Documentation/cpusets.txt
@@ -523,21 +523,14 @@ from one cpuset to another, then the ker
 memory placement, as above, the next time that the kernel attempts
 to allocate a page of memory for that task.
 
-If a cpuset has its CPUs modified, then each task using that
-cpuset does _not_ change its behavior automatically.  In order to
-minimize the impact on the critical scheduling code in the kernel,
-tasks will continue to use their prior CPU placement until they
-are rebound to their cpuset, by rewriting their pid to the 'tasks'
-file of their cpuset.  If a task had been bound to some subset of its
-cpuset using the sched_setaffinity() call, and if any of that subset
-is still allowed in its new cpuset settings, then the task will be
-restricted to the intersection of the CPUs it was allowed on before,
-and its new cpuset CPU placement.  If, on the other hand, there is
-no overlap between a tasks prior placement and its new cpuset CPU
-placement, then the task will be allowed to run on any CPU allowed
-in its new cpuset.  If a task is moved from one cpuset to another,
-its CPU placement is updated in the same way as if the tasks pid is
-rewritten to the 'tasks' file of its current cpuset.
+If a cpuset has its 'cpus' modified, then each task in that cpuset
+will have its allowed CPU placement changed immediately.  Similarly,
+if a tasks pid is written to a cpusets 'tasks' file, in either its
+current cpuset or another cpuset, then its allowed CPU placement is
+changed immediately.  If such a task had been bound to some subset
+of its cpuset using the sched_setaffinity() call, the task will be
+allowed to run on any CPU allowed in its new cpuset, negating the
+affect of the prior sched_setaffinity() call.
 
 In summary, the memory placement of a task whose cpuset is changed is
 updated by the kernel, on the next allocation of a page for that task,
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
kernel-cgroupc-remove-dead-code.patch
cgroup-brace-coding-style-fix.patch
cgroup-simplify-space-stripping.patch
cgroup-simplify-space-stripping-fix.patch
cgroups-move-cgroups-destroy-callbacks-to-cgroup_diput.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-node_online_map-fix.patch
cpusets-update_cpumask-revision.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
cgroups-update-comments-in-cpusetc.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-various-other-fixes.patch
cpusets-update_cpumask-documentation-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
