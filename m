From: akpm@linux-foundation.org
Subject: + memcg-fix-oops-in-mem_cgroup_shrink_usage.patch added to -mm tree
Date: Wed, 06 Aug 2008 09:09:40 -0700
Message-ID: <200808061609.m76G9eQ8002638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbYHFQRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 12:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: fix oops in mem_cgroup_shrink_usage
has been added to the -mm tree.  Its filename is
     memcg-fix-oops-in-mem_cgroup_shrink_usage.patch

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
Subject: memcg: fix oops in mem_cgroup_shrink_usage
From: Hugh Dickins <hugh@veritas.com>

Got an oops in mem_cgroup_shrink_usage() when testing loop over tmpfs:
yes, of course, loop0 has no mm: other entry points check but this didn't.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-fix-oops-in-mem_cgroup_shrink_usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oops-in-mem_cgroup_shrink_usage
+++ a/mm/memcontrol.c
@@ -796,6 +796,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	if (mem_cgroup_subsys.disabled)
 		return 0;
+	if (!mm)
+		return 0;
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-fix-uninitialized-variables-for-find_vma_prepare-callers.patch
memcg-fix-oops-in-mem_cgroup_shrink_usage.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch

