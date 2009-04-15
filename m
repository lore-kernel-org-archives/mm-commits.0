From: akpm@linux-foundation.org
Subject: + memcg-use-rcu_dereference-to-access-mm-owner.patch added to -mm tree
Date: Wed, 15 Apr 2009 15:52:08 -0700
Message-ID: <200904152252.n3FMq8ko019021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbZDOWzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 18:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg: use rcu_dereference to access mm->owner
has been added to the -mm tree.  Its filename is
     memcg-use-rcu_dereference-to-access-mm-owner.patch

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

memcg-use-rcu_dereference-to-access-mm-owner.patch

