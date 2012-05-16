From: akpm@linux-foundation.org
Subject: [merged] memcg-free-spare-array-to-avoid-memory-leak.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:55 -0700
Message-ID: <20120516184655.6AE02A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52447 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322Ab2EPSq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:56 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so125569yen.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: free spare array to avoid memory leak
has been removed from the -mm tree.  Its filename was
     memcg-free-spare-array-to-avoid-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -4507,6 +4507,12 @@ static void mem_cgroup_usage_unregister_
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

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

