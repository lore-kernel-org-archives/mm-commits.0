From: akpm@linux-foundation.org
Subject: [merged] cpuset-hold-callback_mutex-in-cpuset_clone.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:33 -0700
Message-ID: <201103250725.p2P7PRkq026021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933822Ab1CYHZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: hold callback_mutex in cpuset_post_clone()
has been removed from the -mm tree.  Its filename was
     cpuset-hold-callback_mutex-in-cpuset_clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: hold callback_mutex in cpuset_post_clone()
From: Li Zefan <lizf@cn.fujitsu.com>

Chaning cpuset->mems/cpuset->cpus should be protected under
callback_mutex.

cpuset_clone() doesn't follow this rule. It's ok because it's
called when creating and initializing a cgroup, but we'd better
hold the lock to avoid subtil break in the future.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cpuset.c~cpuset-hold-callback_mutex-in-cpuset_clone kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-hold-callback_mutex-in-cpuset_clone
+++ a/kernel/cpuset.c
@@ -1840,8 +1840,10 @@ static void cpuset_post_clone(struct cgr
 	cs = cgroup_cs(cgroup);
 	parent_cs = cgroup_cs(parent);
 
+	mutex_lock(&callback_mutex);
 	cs->mems_allowed = parent_cs->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
+	mutex_unlock(&callback_mutex);
 	return;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroup-remove-the-ns_cgroup.patch

