From: akpm@linux-foundation.org
Subject: + cpuset-hotplug-documentation-fix.patch added to -mm tree
Date: Mon, 08 Sep 2008 13:59:50 -0700
Message-ID: <200809082059.m88KxocS010105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYIHVA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 17:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: hotplug documentation fix
has been added to the -mm tree.  Its filename is
     cpuset-hotplug-documentation-fix.patch

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
cpuset-avoid-changing-cpusets-cpus-when-errno-returned.patch
cpuset-hotplug-documentation-fix.patch
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

