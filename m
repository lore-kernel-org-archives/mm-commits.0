Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FA3C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCWVpw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCWVpw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:45:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93D090
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A90FB82242
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1C8C433D2;
        Thu, 23 Mar 2023 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679607948;
        bh=fK/lmoSbpuS4msEXJRCiG+lytt0RBsprVAtBHIB3t/Y=;
        h=Date:To:From:Subject:From;
        b=01K3FxQe0wW/m6nrjJOv8DnXK/4fWW9j7ljnHmmsbT+bS5fUY7pMqQJpIJHCWG/VC
         1bLC6xGMlmNE8dVarSTmC23WU+Hq/UKwCb3NIKy1Tjswz+nRbFpbuFuNxYQIOivkiE
         hUVtkKI/I3fZfopkRUg2Pm+/rhwUU8LzNTTpYYCo=
Date:   Thu, 23 Mar 2023 14:45:47 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, louhongxiang@huawei.com,
        linfeilong@huawei.com, haowenchao2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + trace-cma-remove-unnecessary-event-class-cma_alloc_class.patch added to mm-unstable branch
Message-Id: <20230323214547.DF1C8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: trace: cma: remove unnecessary event class cma_alloc_class
has been added to the -mm mm-unstable branch.  Its filename is
     trace-cma-remove-unnecessary-event-class-cma_alloc_class.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/trace-cma-remove-unnecessary-event-class-cma_alloc_class.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wenchao Hao <haowenchao2@huawei.com>
Subject: trace: cma: remove unnecessary event class cma_alloc_class
Date: Thu, 23 Mar 2023 19:41:36 +0800

After commit cb6c33d4dc09 ("cma: tracing: print alloc result in
trace_cma_alloc_finish"), cma_alloc_class has only one event which is
cma_alloc_busy_retry.  So we can remove the cma_alloc_class.

Link: https://lkml.kernel.org/r/20230323114136.177677-1-haowenchao2@huawei.com
Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Hongxiang Lou <louhongxiang@huawei.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   58 +++++++++++++++--------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

--- a/include/trace/events/cma.h~trace-cma-remove-unnecessary-event-class-cma_alloc_class
+++ a/include/trace/events/cma.h
@@ -8,37 +8,6 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-DECLARE_EVENT_CLASS(cma_alloc_class,
-
-	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned long count, unsigned int align),
-
-	TP_ARGS(name, pfn, page, count, align),
-
-	TP_STRUCT__entry(
-		__string(name, name)
-		__field(unsigned long, pfn)
-		__field(const struct page *, page)
-		__field(unsigned long, count)
-		__field(unsigned int, align)
-	),
-
-	TP_fast_assign(
-		__assign_str(name, name);
-		__entry->pfn = pfn;
-		__entry->page = page;
-		__entry->count = count;
-		__entry->align = align;
-	),
-
-	TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u",
-		  __get_str(name),
-		  __entry->pfn,
-		  __entry->page,
-		  __entry->count,
-		  __entry->align)
-);
-
 TRACE_EVENT(cma_release,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
@@ -125,12 +94,35 @@ TRACE_EVENT(cma_alloc_finish,
 		  __entry->errorno)
 );
 
-DEFINE_EVENT(cma_alloc_class, cma_alloc_busy_retry,
+TRACE_EVENT(cma_alloc_busy_retry,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
 		 unsigned long count, unsigned int align),
 
-	TP_ARGS(name, pfn, page, count, align)
+	TP_ARGS(name, pfn, page, count, align),
+
+	TP_STRUCT__entry(
+		__string(name, name)
+		__field(unsigned long, pfn)
+		__field(const struct page *, page)
+		__field(unsigned long, count)
+		__field(unsigned int, align)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->pfn = pfn;
+		__entry->page = page;
+		__entry->count = count;
+		__entry->align = align;
+	),
+
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u",
+		  __get_str(name),
+		  __entry->pfn,
+		  __entry->page,
+		  __entry->count,
+		  __entry->align)
 );
 
 #endif /* _TRACE_CMA_H */
_

Patches currently in -mm which might be from haowenchao2@huawei.com are

trace-cma-remove-unnecessary-event-class-cma_alloc_class.patch

