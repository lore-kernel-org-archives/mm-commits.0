Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2FDC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F6C61D12
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhF2Cmg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhF2Cmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2EE61D0F;
        Tue, 29 Jun 2021 02:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934408;
        bh=Q2J6fIF7Fx1vV2KgCzMuBG2Ho0/+a7Ul0BpXbApkgEo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BrQYJjOd0+g5spvqEWbMa9fiBt+Xp0qRlnBgjDjqara160/KWIWsfZB8atCNbNASc
         +7EyEvcTQ9vPuW/BmTHi1hySj6JeXh3L7mCeS4V8kUYj1S29eMxKadqFICDH8uCFiP
         ZFNkC5GCbJKXhUgWl41zh/DN4wlvZ1LN1hGPFboA=
Date:   Mon, 28 Jun 2021 19:40:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, vincent.whitchurch@axis.com
Subject:  [patch 131/192] mm, tracing: unify PFN format strings
Message-ID: <20210629024008.NZUrJISXo%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: mm, tracing: unify PFN format strings

Some trace event formats print PFNs as hex while others print them as
decimal.  This is rather annoying when attempting to grep through traces
to understand what's going on with a particular page.

 $ git grep -ho 'pfn=[0x%lu]\+' include/trace/events/ | sort | uniq -c
      11 pfn=0x%lx
      12 pfn=%lu
       2 pfn=%lx

Printing as hex is in the majority in the trace events, and all the normal
printks in mm/ also print PFNs as hex, so change all the PFN formats in
the trace events to use 0x%lx.

Link: https://lkml.kernel.org/r/20210602092608.1493-1-vincent.whitchurch@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h       |    4 ++--
 include/trace/events/filemap.h   |    2 +-
 include/trace/events/kmem.h      |   12 ++++++------
 include/trace/events/page_pool.h |    4 ++--
 include/trace/events/pagemap.h   |    4 ++--
 include/trace/events/vmscan.h    |    2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

--- a/include/trace/events/cma.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/cma.h
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%lu align=%u",
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
@@ -60,7 +60,7 @@ TRACE_EVENT(cma_release,
 		__entry->count = count;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%lu",
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
--- a/include/trace/events/filemap.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/filemap.h
@@ -36,7 +36,7 @@ DECLARE_EVENT_CLASS(mm_filemap_op_page_c
 			__entry->s_dev = page->mapping->host->i_rdev;
 	),
 
-	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu",
+	TP_printk("dev %d:%d ino %lx page=%p pfn=0x%lx ofs=%lu",
 		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
 		__entry->i_ino,
 		pfn_to_page(__entry->pfn),
--- a/include/trace/events/kmem.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/kmem.h
@@ -173,7 +173,7 @@ TRACE_EVENT(mm_page_free,
 		__entry->order		= order;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d",
+	TP_printk("page=%p pfn=0x%lx order=%d",
 			pfn_to_page(__entry->pfn),
 			__entry->pfn,
 			__entry->order)
@@ -193,7 +193,7 @@ TRACE_EVENT(mm_page_free_batched,
 		__entry->pfn		= page_to_pfn(page);
 	),
 
-	TP_printk("page=%p pfn=%lu order=0",
+	TP_printk("page=%p pfn=0x%lx order=0",
 			pfn_to_page(__entry->pfn),
 			__entry->pfn)
 );
@@ -219,7 +219,7 @@ TRACE_EVENT(mm_page_alloc,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d gfp_flags=%s",
 		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
@@ -245,7 +245,7 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
+	TP_printk("page=%p pfn=0x%lx order=%u migratetype=%d percpu_refill=%d",
 		__entry->pfn != -1UL ? pfn_to_page(__entry->pfn) : NULL,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
@@ -278,7 +278,7 @@ TRACE_EVENT(mm_page_pcpu_drain,
 		__entry->migratetype	= migratetype;
 	),
 
-	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
+	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d",
 		pfn_to_page(__entry->pfn), __entry->pfn,
 		__entry->order, __entry->migratetype)
 );
@@ -312,7 +312,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 					get_pageblock_migratetype(page));
 	),
 
-	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
+	TP_printk("page=%p pfn=0x%lx alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
 		pfn_to_page(__entry->pfn),
 		__entry->pfn,
 		__entry->alloc_order,
--- a/include/trace/events/pagemap.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/pagemap.h
@@ -46,7 +46,7 @@ TRACE_EVENT(mm_lru_insertion,
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
-	TP_printk("page=%p pfn=%lu lru=%d flags=%s%s%s%s%s%s",
+	TP_printk("page=%p pfn=0x%lx lru=%d flags=%s%s%s%s%s%s",
 			__entry->page,
 			__entry->pfn,
 			__entry->lru,
@@ -75,7 +75,7 @@ TRACE_EVENT(mm_lru_activate,
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
-	TP_printk("page=%p pfn=%lu", __entry->page, __entry->pfn)
+	TP_printk("page=%p pfn=0x%lx", __entry->page, __entry->pfn)
 
 );
 
--- a/include/trace/events/page_pool.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/page_pool.h
@@ -60,7 +60,7 @@ TRACE_EVENT(page_pool_state_release,
 		__entry->pfn		= page_to_pfn(page);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=%lu release=%u",
+	TP_printk("page_pool=%p page=%p pfn=0x%lx release=%u",
 		  __entry->pool, __entry->page, __entry->pfn, __entry->release)
 );
 
@@ -85,7 +85,7 @@ TRACE_EVENT(page_pool_state_hold,
 		__entry->pfn	= page_to_pfn(page);
 	),
 
-	TP_printk("page_pool=%p page=%p pfn=%lu hold=%u",
+	TP_printk("page_pool=%p page=%p pfn=0x%lx hold=%u",
 		  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
 );
 
--- a/include/trace/events/vmscan.h~mm-tracing-unify-pfn-format-strings
+++ a/include/trace/events/vmscan.h
@@ -330,7 +330,7 @@ TRACE_EVENT(mm_vmscan_writepage,
 						page_is_file_lru(page));
 	),
 
-	TP_printk("page=%p pfn=%lu flags=%s",
+	TP_printk("page=%p pfn=0x%lx flags=%s",
 		pfn_to_page(__entry->pfn),
 		__entry->pfn,
 		show_reclaim_flags(__entry->reclaim_flags))
_
