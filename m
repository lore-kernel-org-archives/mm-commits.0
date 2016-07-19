From: akpm@linux-foundation.org
Subject: [merged] mm-workingset-printk-missing-log-level-use-pr_info.patch removed from -mm tree
Date: Tue, 19 Jul 2016 11:10:39 -0700
Message-ID: <578e6d1f.HCsSeGzykIk6usXy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbcGSSKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: printk missing log level, use pr_info()
has been removed from the -mm tree.  Its filename was
     mm-workingset-printk-missing-log-level-use-pr_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: mm: workingset: printk missing log level, use pr_info()

commit 612e44939c3c ("mm: workingset: eviction buckets for bigmem/lowbit
machines") added a printk without a log level. Quieten it by using
pr_info().

Link: http://lkml.kernel.org/r/1466982072-29836-2-git-send-email-anton@ozlabs.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-printk-missing-log-level-use-pr_info mm/workingset.c
--- a/mm/workingset.c~mm-workingset-printk-missing-log-level-use-pr_info
+++ a/mm/workingset.c
@@ -491,7 +491,7 @@ static int __init workingset_init(void)
 	max_order = fls_long(totalram_pages - 1);
 	if (max_order > timestamp_bits)
 		bucket_order = max_order - timestamp_bits;
-	printk("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
+	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
 	       timestamp_bits, max_order, bucket_order);
 
 	ret = list_lru_init_key(&workingset_shadow_nodes, &shadow_nodes_key);
_

Patches currently in -mm which might be from anton@samba.org are

exit-quieten-greatest-stack-depth-printk.patch

