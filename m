From: akpm@linux-foundation.org
Subject: + cgroups-add-documentation-for-task-counter-subsystem.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:30 -0700
Message-ID: <201109062242.p86MgUnm008325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983Ab1IFWm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: add documentation for task counter subsystem
has been added to the -mm tree.  Its filename is
     cgroups-add-documentation-for-task-counter-subsystem.patch

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
Subject: cgroups: add documentation for task counter subsystem
From: Frederic Weisbecker <fweisbec@gmail.com>

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/task_counter.txt |  126 +++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff -puN /dev/null Documentation/cgroups/task_counter.txt
--- /dev/null
+++ a/Documentation/cgroups/task_counter.txt
@@ -0,0 +1,126 @@
+Task counter subsystem
+
+1. Description
+
+The task counter subsystem limits the number of tasks running
+inside a given cgroup. It behaves like the NR_PROC rlimit but in
+the scope of a cgroup instead of a user.
+
+It has two typical usecases, although more can probably be found:
+
+- Protect against forkbombs that explode inside a container when
+that container is implemented using a cgroup. The NR_PROC rlimit
+is not efficient for that because if we have several containers
+running in parallel under the same user, one container could starve
+all the others by spawning a high number of tasks close to the
+rlimit boundary. So in this case we need this limitation to be
+done in a per cgroup granularity.
+
+- Kill all tasks inside a cgroup without races. By setting the limit
+of running tasks to 0, one can prevent from any further fork inside a
+cgroup and then kill all of its tasks without the need to retry an
+unbound amount of time due to races between kills and forks running
+in parallel (more details in "Kill a cgroup safely" paragraph).
+
+
+2. Interface
+
+When a hierarchy is mounted with the task counter subsystem binded, it
+adds two files into the cgroups directories, except the root one:
+
+- tasks.usage contains the number of tasks running inside a cgroup and
+its children in the hierarchy (see paragraph about Inheritance).
+
+- tasks.limit contains the maximum number of tasks that can run inside
+a cgroup. We check this limit when a task forks or when it is migrated
+to a cgroup.
+
+Note that the tasks.limit value can be forced below tasks.usage, in which
+case any new task in the cgroup will be rejected until the tasks.usage
+value goes below tasks.limit.
+
+For optimization reasons, the root directory of a hierarchy doesn't have
+a task counter.
+
+
+3. Inheritance
+
+When a task is added to a cgroup, by way of a cgroup migration or a fork,
+it increases the task counter of that cgroup and of all its ancestors.
+Hence a cgroup is also subject to the limit of its ancestors.
+
+In the following hierarchy:
+
+
+             A
+             |
+             B
+           /   \
+          C     D
+
+
+We have 1 task running in B, one running in C and none running in D.
+It means we have tasks.usage = 1 in C and tasks.usage = 2 in B because
+B counts its task and those of its children.
+
+Now lets set tasks.limit = 2 in B and tasks.limit = 1 in D.
+If we move a new task in D, it will be refused because the limit in B has
+been reached already.
+
+
+4. Kill a cgroup safely
+
+As explained in the description, this subsystem is also helpful to
+kill all tasks in a cgroup safely, after setting tasks.limit to 0,
+so that we don't race against parallel forks in an unbound numbers
+of kill iterations.
+
+But there is a small detail to be aware of to use this feature that
+way.
+
+Some typical way to proceed would be:
+
+	echo 0 > tasks.limit
+	for TASK in $(cat cgroup.procs)
+	do
+		kill -KILL $TASK
+	done
+
+However there is a small race window where a task can be in the way to
+be forked but hasn't enough completed the fork to have the PID of the
+fork appearing in the cgroup.procs file.
+
+The only way to get it right is to run a loop that reads tasks.usage, kill
+all the tasks in cgroup.procs and exit the loop only if the value in
+tasks.usage was the same than the number of tasks that were in cgroup.procs,
+ie: the number of tasks that were killed.
+
+It works because the new child appears in tasks.usage right before we check,
+in the fork path, whether the parent has a pending signal, in which case the
+fork is cancelled anyway. So relying on tasks.usage is fine and non-racy.
+
+This race window is tiny and unlikely to happen, so most of the time a single
+kill iteration should be enough. But it's worth knowing about that corner
+case spotted by Oleg Nesterov.
+
+Example of safe use would be:
+
+	echo 0 > tasks.limit
+	END=false
+
+	while [ $END == false ]
+	do
+		NR_TASKS=$(cat tasks.usage)
+		NR_KILLED=0
+
+		for TASK in $(cat cgroup.procs)
+		do
+			let NR_KILLED=NR_KILLED+1
+			kill -KILL $TASK
+		done
+
+		if [ "$NR_TASKS" = "$NR_KILLED" ]
+		then
+			END=true
+		fi
+	done
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-documentation-for-task-counter-subsystem.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

