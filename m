From: akpm@linux-foundation.org
Subject: [merged] forkc-fix-null-pointer-dereference-when-nr_threads-==-threads-max.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:06 -0800
Message-ID: <200902092005.n19K56ri023945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbZBIUGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     fork.c: fix NULL pointer dereference when nr_threads == threads-max
has been removed from the -mm tree.  Its filename was
     forkc-fix-null-pointer-dereference-when-nr_threads-==-threads-max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fork.c: fix NULL pointer dereference when nr_threads == threads-max
From: Li Zefan <lizf@cn.fujitsu.com>

I happened to forked lots of processes, and hit NULL pointer dereference. 
It is because in copy_process() after checking max_threads, 0 is returned
but not -EAGAIN.

The bug is introduced by this patch:

| commit f1752eec6145c97163dbce62d17cf5d928e28a27
| Author: David Howells <dhowells@redhat.com>
| Date:   Fri Nov 14 10:39:17 2008 +1100
|
|    CRED: Detach the credentials from task_struct

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~forkc-fix-null-pointer-dereference-when-nr_threads-==-threads-max kernel/fork.c
--- a/kernel/fork.c~forkc-fix-null-pointer-dereference-when-nr_threads-==-threads-max
+++ a/kernel/fork.c
@@ -1010,6 +1010,7 @@ static struct task_struct *copy_process(
 	 * triggers too late. This doesn't hurt, the check is only there
 	 * to stop root fork bombs.
 	 */
+	retval = -EAGAIN;
 	if (nr_threads >= max_threads)
 		goto bad_fork_cleanup_count;
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cgroups-fix-lockdep-subclasses-overflow.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

