From: akpm@linux-foundation.org
Subject: - cgroups-documentation-updates.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:19 -0800
Message-ID: <200901082247.n08MlJFP026791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763541AbZAHWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: documentation updates
has been removed from the -mm tree.  Its filename was
     cgroups-documentation-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: documentation updates
From: Li Zefan <lizf@cn.fujitsu.com>

- remove 'releasable' since it has been moved to the debug subsys.
- update lock requirements of subsys callbacks.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-documentation-updates Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-documentation-updates
+++ a/Documentation/cgroups/cgroups.txt
@@ -227,7 +227,6 @@ Each cgroup is represented by a director
 containing the following files describing that cgroup:
 
  - tasks: list of tasks (by pid) attached to that cgroup
- - releasable flag: cgroup currently removeable?
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)
@@ -360,7 +359,7 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-notify_on_release releasable tasks
+notify_on_release tasks
 (plus whatever files added by the attached subsystems)
 
 Now attach your shell to this cgroup:
@@ -479,7 +478,6 @@ newly-created cgroup if an error occurs 
 create() method has been called for the new cgroup).
 
 void pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
-(cgroup_mutex held by caller)
 
 Called before checking the reference count on each subsystem. This may
 be useful for subsystems which have some extra references even if
@@ -498,6 +496,7 @@ remain valid while the caller holds cgro
 
 void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	    struct cgroup *old_cgrp, struct task_struct *task)
+(cgroup_mutex held by caller)
 
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
@@ -511,6 +510,7 @@ void exit(struct cgroup_subsys *ss, stru
 Called during task exit.
 
 int populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
+(cgroup_mutex held by caller)
 
 Called after creation of a cgroup to allow a subsystem to populate
 the cgroup directory with file entries.  The subsystem should make
@@ -520,6 +520,7 @@ method can return an error code, the err
 always handled well.
 
 void post_clone(struct cgroup_subsys *ss, struct cgroup *cgrp)
+(cgroup_mutex held by caller)
 
 Called at the end of cgroup_clone() to do any paramater
 initialization which might be required before a task could attach.  For
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

