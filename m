From: akpm@linux-foundation.org
Subject: + mm-page_alloc-warn-about-empty-nodemask.patch added to -mm tree
Date: Tue, 20 Sep 2016 13:58:14 -0700
Message-ID: <57e1a2e6.KVkZYZqR+rVthzHz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49575 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbcITU6P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 16:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, jallen@linux.vnet.ibm.com, mhocko@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: warn about empty nodemask
has been added to the -mm tree.  Its filename is
     mm-page_alloc-warn-about-empty-nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-warn-about-empty-nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-warn-about-empty-nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: mm, page_alloc: warn about empty nodemask

Warn about allocating with an empty nodemask, it would be easier to
understand than oom messages.  The check is added in the slow path.

Link: http://lkml.kernel.org/r/1473208886.12692.2.camel@TP420
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: n-horiguchi@ah.jp.nec.com said:
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-warn-about-empty-nodemask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn-about-empty-nodemask
+++ a/mm/page_alloc.c
@@ -3521,6 +3521,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	if (page)
 		goto got_pg;
 
+	if (ac->nodemask && nodes_empty(*ac->nodemask)) {
+		pr_warn("nodemask is empty\n");
+		gfp_mask &= ~__GFP_NOWARN;
+		goto nopage;
+	}
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. Don't try
_

Patches currently in -mm which might be from zhong@linux.vnet.ibm.com are

mm-page_alloc-warn-about-empty-nodemask.patch

