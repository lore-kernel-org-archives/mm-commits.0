From: akpm@linux-foundation.org
Subject: + mm-page_ext-periodically-reschedule-during-page_ext_init.patch
 added to -mm tree
Date: Fri, 21 Jul 2017 13:07:27 -0700
Message-ID: <59725eff.L3s0R3stYNpLHVBz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUUH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 16:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_ext: periodically reschedule during page_ext_init()
has been added to the -mm tree.  Its filename is
     mm-page_ext-periodically-reschedule-during-page_ext_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-periodically-reschedule-during-page_ext_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-periodically-reschedule-during-page_ext_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_ext: periodically reschedule during page_ext_init()

page_ext_init() can take long on large machines, so add a cond_resched()
point after each section is processed.  This will allow moving the init to
a later point at boot without triggering lockup reports.

Link: http://lkml.kernel.org/r/20170720134029.25268-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-make-init_pages_in_zone-faster.patch
mm-page_ext-periodically-reschedule-during-page_ext_init.patch
mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch
mm-page_ext-move-page_ext_init-after-page_alloc_init_late.patch

