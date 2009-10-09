From: akpm@linux-foundation.org
Subject: [merged] cgroups-update-documentation-of-cgroups-tasks-and-procs-files.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:59 -0700
Message-ID: <200910092204.n99M4x8e020470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934510AbZJIWFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: update documentation of cgroups tasks and procs files
has been removed from the -mm tree.  Its filename was
     cgroups-update-documentation-of-cgroups-tasks-and-procs-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: update documentation of cgroups tasks and procs files
From: Paul Menage <menage@google.com>

Update documentation of cgroups tasks and procs files

Document the cgroup.procs file.

Clarify the semantics of the cgroup.procs and tasks files.  Although the
current cgroup.procs interface returns a sorted and uniqified list of
pids, potential future performance enhancements could result in those
properties being removed - explicitly document this aspect of the API.

There are no existing users of cgroup.procs, so compatibility isn't an
issue.  There are users of the "tasks" file, but none that would appear to
break in the event of the sorted property being broken.  The standard
"libcpuset" explicitly sorts the results of reading from the tasks file,
and "libcg" and other users don't appear to care about ordering.

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/cgroups/cgroups.txt~cgroups-update-documentation-of-cgroups-tasks-and-procs-files Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-update-documentation-of-cgroups-tasks-and-procs-files
+++ a/Documentation/cgroups/cgroups.txt
@@ -227,7 +227,14 @@ as the path relative to the root of the 
 Each cgroup is represented by a directory in the cgroup file system
 containing the following files describing that cgroup:
 
- - tasks: list of tasks (by pid) attached to that cgroup
+ - tasks: list of tasks (by pid) attached to that cgroup.  This list
+   is not guaranteed to be sorted.  Writing a thread id into this file
+   moves the thread into this cgroup.
+ - cgroup.procs: list of tgids in the cgroup.  This list is not
+   guaranteed to be sorted or free of duplicate tgids, and userspace
+   should sort/uniquify the list if this property is required.
+   Writing a tgid into this file moves all threads with that tgid into
+   this cgroup.
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)
@@ -374,7 +381,7 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-notify_on_release tasks
+cgroup.procs notify_on_release tasks
 (plus whatever files added by the attached subsystems)
 
 Now attach your shell to this cgroup:
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
linux-next.patch
cgroup-fix-strstrip-misuse.patch
add-a-refcount-check-in-dput.patch

