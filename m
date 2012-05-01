From: akpm@linux-foundation.org
Subject: + memcg-free-spare-array-to-avoid-memory-leak.patch added to -mm tree
Date: Tue, 01 May 2012 14:03:22 -0700
Message-ID: <20120501210322.99A1CA020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40322 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab2EAVDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 17:03:23 -0400
Received: by qabg24 with SMTP id g24so319849qab.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 14:03:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name


The patch titled
     Subject: memcg: free spare array to avoid memory leak
has been added to the -mm tree.  Its filename is
     memcg-free-spare-array-to-avoid-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: free spare array to avoid memory leak

When the last event is unregistered, there is no need to keep the spare
array anymore.  So free it to avoid memory leak.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memcontrol.c~memcg-free-spare-array-to-avoid-memory-leak mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-free-spare-array-to-avoid-memory-leak
+++ a/mm/memcontrol.c
@@ -4523,6 +4523,12 @@ static void mem_cgroup_usage_unregister_
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
+
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */
_
Subject: Subject: memcg: free spare array to avoid memory leak

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-free-spare-array-to-avoid-memory-leak.patch
memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

