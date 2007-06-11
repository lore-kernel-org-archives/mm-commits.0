From: akpm@linux-foundation.org
Subject: + containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:47:31 -0700
Message-ID: <200706111847.l5BIlVPZ026296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbXFKSrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, balbir@in.ibm.com, clameter@sgi.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     cpuset: zero malloc - fix for new containers
has been added to the -mm tree.  Its filename is
     containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuset: zero malloc - fix for new containers
From: Paul Jackson <pj@sgi.com>

The container code to present a list of tasks using a container to user space
could write to an array that it had kmalloc'd, after a kmalloc request of zero
size.

The problem was that the code didn't check for writes past the allocated end
of the array until -after- the first write.

This is a race condition that is likely rare -- it would only show up if a
container went from being empty to having a task in it, during the brief time
between the allocation and the first write.

Prior to roughly 2.6.22 kernels, this was also a benign problem, because a
zero kmalloc returned a few usable bytes anyway, and no harm was done with the
bogus write.

With the 2.6.22 kernel changes to make issue a warning if code tries to write
to the location returned from a zero size allocation, this problem is no
longer benign.  This container code would occassionally trigger that warning.

The fix is trivial -- check before storing into the array, not after, whether
the array is big enough to hold the store.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/container.c~containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers kernel/container.c
--- a/kernel/container.c~containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers
+++ a/kernel/container.c
@@ -1451,9 +1451,9 @@ static int pid_array_load(pid_t *pidarra
 	struct task_struct *tsk;
 	container_iter_start(cont, &it);
 	while ((tsk = container_iter_next(cont, &it))) {
-		pidarray[n++] = pid_nr(task_pid(tsk));
 		if (unlikely(n == npids))
 			break;
+		pidarray[n++] = pid_nr(task_pid(tsk));
 	}
 	container_iter_end(cont, &it);
 	return n;
_

Patches currently in -mm which might be from pj@sgi.com are

cpuset-zero-malloc-fix-for-old-cpusets.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
reduce-cpusetc-write_lock_irq-to-read_lock.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
