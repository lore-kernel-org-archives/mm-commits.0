From: akpm@linux-foundation.org
Subject: [patch 040/119] mm, page_ext: periodically reschedule
 during page_ext_init()
Date: Wed, 06 Sep 2017 16:20:48 -0700
Message-ID: <20170906232048.4GwEKrN_0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbdIFXUt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_ext: periodically reschedule during page_ext_init()

page_ext_init() can take long on large machines, so add a cond_resched()
point after each section is processed.  This will allow moving the init to
a later point at boot without triggering lockup reports.

Link: http://lkml.kernel.org/r/20170720134029.25268-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_ext.c~mm-page_ext-periodically-reschedule-during-page_ext_init mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-periodically-reschedule-during-page_ext_init
+++ a/mm/page_ext.c
@@ -406,6 +406,7 @@ void __init page_ext_init(void)
 				continue;
 			if (init_section_page_ext(pfn, nid))
 				goto oom;
+			cond_resched();
 		}
 	}
 	hotplug_memory_notifier(page_ext_callback, 0);
_
