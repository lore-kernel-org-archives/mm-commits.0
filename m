From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event.patch added to -mm tree
Date: Fri, 24 Feb 2012 11:43:57 -0800
Message-ID: <20120224194357.641C4A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56013 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2BXTn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 14:43:59 -0500
Received: by werb13 with SMTP id b13so100448wer.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 11:43:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org


The patch titled
     Subject: mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()

In the following code:

	if (type == _MEM)
		thresholds = &memcg->thresholds;
	else if (type == _MEMSWAP)
		thresholds = &memcg->memsw_thresholds;
	else
		BUG();

	BUG_ON(!thresholds);

The BUG_ON() seems redundant.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event
+++ a/mm/memcontrol.c
@@ -4443,12 +4443,6 @@ static void mem_cgroup_usage_unregister_
 	else
 		BUG();
 
-	/*
-	 * Something went wrong if we trying to unregister a threshold
-	 * if we don't have thresholds
-	 */
-	BUG_ON(!thresholds);
