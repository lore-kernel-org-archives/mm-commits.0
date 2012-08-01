From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-bad-behavior-in-use_hierarchy-file.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:02 -0700
Message-ID: <20120801201403.2FF735C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54695 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:05 -0400
Received: by bkcjc3 with SMTP id jc3so345206bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, dhaval.giani@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix bad behavior in use_hierarchy file
has been removed from the -mm tree.  Its filename was
     memcg-fix-bad-behavior-in-use_hierarchy-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fix bad behavior in use_hierarchy file

I have an application that does the following:

* copy the state of all controllers attached to a hierarchy
* replicate it as a child of the current level.

I would expect writes to the files to mostly succeed, since they are
inheriting sane values from parents.

But that is not the case for use_hierarchy.  If it is set to 0, we succeed
ok.  If we're set to 1, the value of the file is automatically set to 1 in
the children, but if userspace tries to write the very same 1, it will
fail.  That same situation happens if we set use_hierarchy, create a
child, and then try to write 1 again.

Now, there is no reason whatsoever for failing to write a value that is
already there.  It doesn't even match the comments, that states:

 /* If parent's use_hierarchy is set, we can't make any modifications
  * in the child subtrees...

since we are not changing anything.

So test the new value against the one we're storing, and automatically
return 0 if we're not proposing a change.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memcontrol.c~memcg-fix-bad-behavior-in-use_hierarchy-file mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-bad-behavior-in-use_hierarchy-file
+++ a/mm/memcontrol.c
@@ -3764,6 +3764,10 @@ static int mem_cgroup_hierarchy_write(st
 		parent_memcg = mem_cgroup_from_cont(parent);
 
 	cgroup_lock();
+
+	if (memcg->use_hierarchy == val)
+		goto out;
+
 	/*
 	 * If parent's use_hierarchy is set, we can't make any modifications
 	 * in the child subtrees. If it is unset, then the change can
@@ -3780,6 +3784,8 @@ static int mem_cgroup_hierarchy_write(st
 			retval = -EBUSY;
 	} else
 		retval = -EINVAL;
+
+out:
 	cgroup_unlock();
 
 	return retval;
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch

