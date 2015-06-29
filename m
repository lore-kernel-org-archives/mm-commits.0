From: akpm@linux-foundation.org
Subject: [merged] oom-print-points-as-unsigned-int.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:38:55 -0700
Message-ID: <5591acdf.sBHSGvoxj2VYj2pH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbbF2Ui4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: print points as unsigned int
has been removed from the -mm tree.  Its filename was
     oom-print-points-as-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: mm/oom_kill.c: print points as unsigned int

In oom_kill_process(), the variable 'points' is unsigned int.  Print it as
such.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-print-points-as-unsigned-int mm/oom_kill.c
--- a/mm/oom_kill.c~oom-print-points-as-unsigned-int
+++ a/mm/oom_kill.c
@@ -517,7 +517,7 @@ void oom_kill_process(struct task_struct
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	task_lock(p);
-	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
+	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
_

Patches currently in -mm which might be from long.wanglong@huawei.com are

origin.patch

