From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-avoid-printk-iteration-under-rcu-fix.patch removed from -mm tree
Date: Thu, 30 Jan 2020 20:32:58 -0800
Message-ID: <20200131043258.OVgCGqieS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgAaEc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 23:32:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, shakeelb@google.com


The patch titled
     Subject: mm-oom-avoid-printk-iteration-under-rcu-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-avoid-printk-iteration-under-rcu-fix.patch

This patch was dropped because it was folded into mm-oom-avoid-printk-iteration-under-rcu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-avoid-printk-iteration-under-rcu-fix

make dump_tasks::list non-static

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom-avoid-printk-iteration-under-rcu-fix
+++ a/mm/oom_kill.c
@@ -399,7 +399,7 @@ static int add_candidate_task(struct tas
  */
 static void dump_tasks(struct oom_control *oc)
 {
-	static LIST_HEAD(list);
+	LIST_HEAD(list);
 	struct task_struct *p;
 	struct task_struct *t;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-oom-avoid-printk-iteration-under-rcu.patch
