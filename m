From: akpm@linux-foundation.org
Subject: [merged] memcg-use-rcu_dereference-to-access-mm-owner.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:16 -0700
Message-ID: <200904221830.n3MIUGxr006086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbZDVSdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: use rcu_dereference to access mm->owner
has been removed from the -mm tree.  Its filename was
     memcg-use-rcu_dereference-to-access-mm-owner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: use rcu_dereference to access mm->owner
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

mm->owner should be accessed with rcu_dereference().

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-use-rcu_dereference-to-access-mm-owner include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-rcu_dereference-to-access-mm-owner
+++ a/include/linux/memcontrol.h
@@ -75,7 +75,7 @@ int mm_match_cgroup(const struct mm_stru
 {
 	struct mem_cgroup *mem;
 	rcu_read_lock();
-	mem = mem_cgroup_from_task((mm)->owner);
+	mem = mem_cgroup_from_task(rcu_dereference((mm)->owner));
 	rcu_read_unlock();
 	return cgroup == mem;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-fix-pageref-leak-in-do_swap_page.patch
memcg-fix-mem_cgroup_shrink_usage.patch
memcg-add-file-based-rss-accounting.patch

