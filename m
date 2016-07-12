From: akpm@linux-foundation.org
Subject: + mm-workingset-printk-missing-log-level-use-pr_info.patch added
 to -mm tree
Date: Tue, 12 Jul 2016 14:03:29 -0700
Message-ID: <57855b21.mnOqtS71M36ZvS9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcGLVDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: printk missing log level, use pr_info()
has been added to the -mm tree.  Its filename is
     mm-workingset-printk-missing-log-level-use-pr_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-printk-missing-log-level-use-pr_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-printk-missing-log-level-use-pr_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-workingset-printk-missing-log-level-use-pr_info.patch
exit-quieten-greatest-stack-depth-printk.patch

