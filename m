Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11A5C43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDCF61480
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhD3F6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhD3F6O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B312F61463;
        Fri, 30 Apr 2021 05:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762246;
        bh=/xM8eLzspVULrZur3k2gb6Wc7jsARly6Fyr248R6luM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=um/OvsAkGMooR5N04FGjwKCJrYOqVL3nGgTKCR5RHUXrftrQZ+4pNZ+3X1OfNa61d
         WR0Xbd4cshyDc1wXEJeoNYbhAd8Pv5rGQNJReTF6HZFET+E6B/9vWXWOFknVzyQrQz
         11d+V0J2oWYegY5oZU4el4JK3gY8EBLEASAI2qlc=
Date:   Thu, 29 Apr 2021 22:57:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ovidiu.panait@windriver.com,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 083/178] mm, tracing: improve rss_stat tracepoint
 message
Message-ID: <20210430055726.X4a12DrVM%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: mm, tracing: improve rss_stat tracepoint message

Adjust the rss_stat tracepoint to print the name of the resident page type
that got updated (e.g. MM_ANONPAGES/MM_FILEPAGES), rather than the numeric
index corresponding to it (the __entry->member value):

Before this patch:
------------------
rss_stat: mm_id=1216113068 curr=0 member=1 size=28672B
rss_stat: mm_id=1216113068 curr=0 member=1 size=0B
rss_stat: mm_id=534402304 curr=1 member=0 size=188416B
rss_stat: mm_id=534402304 curr=1 member=1 size=40960B

After this patch:
-----------------
rss_stat: mm_id=1726253524 curr=1 type=MM_ANONPAGES size=40960B
rss_stat: mm_id=1726253524 curr=1 type=MM_FILEPAGES size=663552B
rss_stat: mm_id=1726253524 curr=1 type=MM_ANONPAGES size=65536B
rss_stat: mm_id=1726253524 curr=1 type=MM_FILEPAGES size=647168B

Use TRACE_DEFINE_ENUM()/__print_symbolic() logic to map the enum values to
the strings they represent, so that userspace tools can also parse the raw
data correctly.

Link: https://lkml.kernel.org/r/20210310162305.4862-1-ovidiu.panait@windriver.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/include/trace/events/kmem.h~mm-tracing-improve-rss_stat-tracepoint-message
+++ a/include/trace/events/kmem.h
@@ -343,6 +343,26 @@ static unsigned int __maybe_unused mm_pt
 #define __PTR_TO_HASHVAL
 #endif
 
+#define TRACE_MM_PAGES		\
+	EM(MM_FILEPAGES)	\
+	EM(MM_ANONPAGES)	\
+	EM(MM_SWAPENTS)		\
+	EMe(MM_SHMEMPAGES)
+
+#undef EM
+#undef EMe
+
+#define EM(a)	TRACE_DEFINE_ENUM(a);
+#define EMe(a)	TRACE_DEFINE_ENUM(a);
+
+TRACE_MM_PAGES
+
+#undef EM
+#undef EMe
+
+#define EM(a)	{ a, #a },
+#define EMe(a)	{ a, #a }
+
 TRACE_EVENT(rss_stat,
 
 	TP_PROTO(struct mm_struct *mm,
@@ -365,10 +385,10 @@ TRACE_EVENT(rss_stat,
 		__entry->size = (count << PAGE_SHIFT);
 	),
 
-	TP_printk("mm_id=%u curr=%d member=%d size=%ldB",
+	TP_printk("mm_id=%u curr=%d type=%s size=%ldB",
 		__entry->mm_id,
 		__entry->curr,
-		__entry->member,
+		__print_symbolic(__entry->member, TRACE_MM_PAGES),
 		__entry->size)
 	);
 #endif /* _TRACE_KMEM_H */
_
