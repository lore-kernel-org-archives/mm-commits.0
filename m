From: akpm@linux-foundation.org
Subject: - cpuset-hotplug-documentation-fix.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:41 -0700
Message-ID: <200809182055.m8IKtfu9019122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYIRUzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: hotplug documentation fix
has been removed from the -mm tree.  Its filename was
     cpuset-hotplug-documentation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: hotplug documentation fix
From: Li Zefan <lizf@cn.fujitsu.com>

If all the cpus in a cpuset are offlined, the tasks in it will be moved to
the nearest ancestor with non-empty cpus.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN Documentation/cpusets.txt~cpuset-hotplug-documentation-fix Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-hotplug-documentation-fix
+++ a/Documentation/cpusets.txt
@@ -635,14 +635,16 @@ prior 'mems' setting, will not be moved.
 
 There is an exception to the above.  If hotplug functionality is used
 to remove all the CPUs that are currently assigned to a cpuset,
-then the kernel will automatically update the cpus_allowed of all
-tasks attached to CPUs in that cpuset to allow all CPUs.  When memory
-hotplug functionality for removing Memory Nodes is available, a
-similar exception is expected to apply there as well.  In general,
-the kernel prefers to violate cpuset placement, over starving a task
-that has had all its allowed CPUs or Memory Nodes taken offline.  User
-code should reconfigure cpusets to only refer to online CPUs and Memory
-Nodes when using hotplug to add or remove such resources.
+then all the tasks in that cpuset will be moved to the nearest ancestor
+with non-empty cpus.  But the moving of some (or all) tasks might fail if
+cpuset is bound with another cgroup subsystem which has some restrictions
+on task attaching.  In this failing case, those tasks will stay
+in the original cpuset, and the kernel will automatically update
+their cpus_allowed to allow all online CPUs.  When memory hotplug
+functionality for removing Memory Nodes is available, a similar exception
+is expected to apply there as well.  In general, the kernel prefers to
+violate cpuset placement, over starving a task that has had all
+its allowed CPUs or Memory Nodes taken offline.
 
 There is a second exception to the above.  GFP_ATOMIC requests are
 kernel internal allocations that must be satisfied, immediately.
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

