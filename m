From: akpm@linux-foundation.org
Subject: + cpuset-hold-callback_mutex-in-cpuset_clone.patch added to -mm tree
Date: Thu, 17 Feb 2011 14:47:53 -0800
Message-ID: <201102172247.p1HMlr8c020481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab1BQWsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset: hold callback_mutex in cpuset_clone()
has been added to the -mm tree.  Its filename is
     cpuset-hold-callback_mutex-in-cpuset_clone.patch

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
Subject: cpuset: hold callback_mutex in cpuset_clone()
From: Li Zefan <lizf@cn.fujitsu.com>

Chaning cpuset->mems/cpuset->cpus should be protected under
callback_mutex.

cpuset_clone() doesn't follow this rule. It's ok because it's
called when creating and initializing a cgroup, but we'd better
hold the lock to avoid subtil break in the future.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
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

mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

