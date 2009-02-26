From: akpm@linux-foundation.org
Subject: + cgroups-add-data-field-to-struct-cgroup_scanner.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:57:23 -0800
Message-ID: <200902262257.n1QMvNNj031426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbZBZW5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: add 'data' field to struct cgroup_scanner
has been added to the -mm tree.  Its filename is
     cgroups-add-data-field-to-struct-cgroup_scanner.patch

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
Subject: cgroups: add 'data' field to struct cgroup_scanner
From: Li Zefan <lizf@cn.fujitsu.com>

We need to pass some data to test_task() or process_task() in some cases. 
Will be used later.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/cgroup.h~cgroups-add-data-field-to-struct-cgroup_scanner include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-data-field-to-struct-cgroup_scanner
+++ a/include/linux/cgroup.h
@@ -334,6 +334,7 @@ struct cgroup_scanner {
 	void (*process_task)(struct task_struct *p,
 			struct cgroup_scanner *scan);
 	struct ptr_heap *heap;
+	void *data;
 };
 
 /*
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
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
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch

