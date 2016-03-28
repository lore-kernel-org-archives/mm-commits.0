From: akpm@linux-foundation.org
Subject: +
 mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior.patch
 added to -mm tree
Date: Mon, 28 Mar 2016 15:44:23 -0700
Message-ID: <56f9b3c7.Ohqw1DrUVWiqe5W+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbcC1WoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 18:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, js1304@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: fix tracepoint to mirror check function behavior
has been added to the -mm tree.  Its filename is
     mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm/page_isolation: fix tracepoint to mirror check function behavior

Page isolation has not failed if the fin pfn extends beyond the end pfn
and test_pages_isolated checks this correctly.  Fix the tracepoint to
report the same result as the actual check function.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/page_isolation.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/page_isolation.h~mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior include/trace/events/page_isolation.h
--- a/include/trace/events/page_isolation.h~mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior
+++ a/include/trace/events/page_isolation.h
@@ -29,7 +29,7 @@ TRACE_EVENT(test_pages_isolated,
 
 	TP_printk("start_pfn=0x%lx end_pfn=0x%lx fin_pfn=0x%lx ret=%s",
 		__entry->start_pfn, __entry->end_pfn, __entry->fin_pfn,
-		__entry->end_pfn == __entry->fin_pfn ? "success" : "fail")
+		__entry->end_pfn <= __entry->fin_pfn ? "success" : "fail")
 );
 
 #endif /* _TRACE_PAGE_ISOLATION_H */
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

mm-page_isolation-fix-tracepoint-to-mirror-check-function-behavior.patch

