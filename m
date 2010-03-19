From: akpm@linux-foundation.org
Subject: + memcg-oom-notifier-update.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:03:06 -0700
Message-ID: <201003192303.o2JN36Vp017350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0CSXDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, davidel@xmailserver.org, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg-oom-notifier-update
has been added to the -mm tree.  Its filename is
     memcg-oom-notifier-update.patch

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
Subject: memcg-oom-notifier-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 - moved kmalloc to out of lock. Then, removed unnecessary label and goto.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Davide Libenzi <davidel@xmailserver.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-notifier-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-notifier-update
+++ a/mm/memcontrol.c
@@ -3605,15 +3605,13 @@ static int mem_cgroup_oom_register_event
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
 	int type = MEMFILE_TYPE(cft->private);
-	int ret = -ENOMEM;
 
 	BUG_ON(type != _OOM_TYPE);
-
-	mutex_lock(&memcg_oom_mutex);
-
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
 	if (!event)
-		goto unlock;
+		return -ENOMEM;
+
+	mutex_lock(&memcg_oom_mutex);
 
 	event->eventfd = eventfd;
 	list_add(&event->list, &memcg->oom_notify);
@@ -3621,11 +3619,9 @@ static int mem_cgroup_oom_register_event
 	/* already in OOM ? */
 	if (atomic_read(&memcg->oom_lock))
 		eventfd_signal(eventfd, 1);
-	ret = 0;
-unlock:
 	mutex_unlock(&memcg_oom_mutex);
 
-	return ret;
+	return 0;
 }
 
 static int mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-disable-move-charge-in-no-mmu-case.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

