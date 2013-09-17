From: akpm@linux-foundation.org
Subject: +
 kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch added to -mm tree
Date: Tue, 17 Sep 2013 15:39:19 -0700
Message-ID: <5238da17.m0H1ACwQwmF0rk1H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IQWjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 18:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bsingharora@gmail.com, gang.chen@asianux.com

Subject: + kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch added to -mm tree
To: gang.chen@asianux.com,bsingharora@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 15:39:19 -0700


The patch titled
     Subject: kernel/taskstats.c: add nla_nest_cancel() for failure processing between nla_nest_start() and nla_nest_end()
has been added to the -mm tree.  Its filename is
     kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/taskstats.c: add nla_nest_cancel() for failure processing between nla_nest_start() and nla_nest_end()

When failure occurs between nla_nest_start() and nla_nest_end(), we should
call nla_nest_cancel() to clean up related things.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/taskstats.c~kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end kernel/taskstats.c
--- a/kernel/taskstats.c~kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end
+++ a/kernel/taskstats.c
@@ -404,11 +404,15 @@ static struct taskstats *mk_reply(struct
 	if (!na)
 		goto err;
 
-	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
+	if (nla_put(skb, type, sizeof(pid), &pid) < 0) {
+		nla_nest_cancel(skb, na);
 		goto err;
+	}
 	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
-	if (!ret)
+	if (!ret) {
+		nla_nest_cancel(skb, na);
 		goto err;
+	}
 	nla_nest_end(skb, na);
 
 	return nla_data(ret);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch

