From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
 added to -mm tree
Date: Tue, 06 Aug 2013 14:04:19 -0700
Message-ID: <520164d3.bOoRPvhOwCA2EJvw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3HFVEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, guohanjun@huawei.com, wujianguo@huawei.com

Subject: + mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch added to -mm tree
To: wujianguo@huawei.com,guohanjun@huawei.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:04:19 -0700


The patch titled
     Subject: mm/mempolicy: return NULL if node is NUMA_NO_NODE in get_task_policy
has been added to the -mm tree.  Its filename is
     mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/mempolicy: return NULL if node is NUMA_NO_NODE in get_task_policy

If node == NUMA_NO_NODE, pol is NULL, we should return NULL instead of
do "if (!pol->mode)" check.

[akpm@linux-foundation.org: reorganise code]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy
+++ a/mm/mempolicy.c
@@ -123,16 +123,19 @@ static struct mempolicy preferred_node_p
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
-	int node;
 
 	if (!pol) {
-		node = numa_node_id();
-		if (node != NUMA_NO_NODE)
-			pol = &preferred_node_policy[node];
+		int node = numa_node_id();
 
-		/* preferred_node_policy is not initialised early in boot */
-		if (!pol->mode)
-			pol = NULL;
+		if (node != NUMA_NO_NODE) {
+			pol = &preferred_node_policy[node];
+			/*
+			 * preferred_node_policy is not initialised early in
+			 * boot
+			 */
+			if (!pol->mode)
+				pol = NULL;
+		}
 	}
 
 	return pol;
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch

