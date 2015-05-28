From: akpm@linux-foundation.org
Subject: + oom-print-points-as-unsigned-int.patch added to -mm tree
Date: Thu, 28 May 2015 13:35:45 -0700
Message-ID: <55677c21.7QoKBPPuKoa6TxvI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbE1Ufp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 16:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: print points as unsigned int
has been added to the -mm tree.  Its filename is
     oom-print-points-as-unsigned-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-print-points-as-unsigned-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-print-points-as-unsigned-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

oom-print-points-as-unsigned-int.patch
kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch
linux-next.patch

