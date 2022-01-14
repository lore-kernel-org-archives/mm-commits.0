Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2D1C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiANWI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AD2DB82630
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFFEC36AE9;
        Fri, 14 Jan 2022 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198137;
        bh=X8f+gyK//G9NkkmWg+k7VoiisPVxh9cYQA0c6j7PTjc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cwSwCBujZyMsabrH0xJtOOXfLhdLAQy+YrxaZJe73JUBjJGhBfwC/OhDY8CFeEqZj
         Sm/dkp1xry0US/UaE4jcooDkNfA3HboGc6LXubM5MCq422LBHx58FWbPJSTlvXTLIU
         FbDYcQoySkQmTJuPFqApkeF3posKlx0bfTDPNG6w=
Date:   Fri, 14 Jan 2022 14:08:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, kirill@shutemov.name, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org
Subject:  [patch 109/146] mm/thp: drop unused trace events
 hugepage_[invalidate|splitting]
Message-ID: <20220114220856.uc7z7U0Nn%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: drop unused trace events hugepage_[invalidate|splitting]

The trace events hugepage_[invalidate|splitting], were added via the
commit 9e813308a5c1 ("powerpc/thp: Add tracepoints to track hugepage
invalidate").  Afterwards their call sites i.e
trace_hugepage_[invalidate|splitting] were just dropped off, leaving these
trace points unused.

Link: https://lkml.kernel.org/r/1641546351-15109-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/thp.h |   35 -----------------------------------
 1 file changed, 35 deletions(-)

--- a/include/trace/events/thp.h~mm-thp-drop-unused-trace-events-hugepage_
+++ a/include/trace/events/thp.h
@@ -8,24 +8,6 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(hugepage_invalidate,
-
-	    TP_PROTO(unsigned long addr, unsigned long pte),
-	    TP_ARGS(addr, pte),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, addr)
-		    __field(unsigned long, pte)
-		    ),
-
-	    TP_fast_assign(
-		    __entry->addr = addr;
-		    __entry->pte = pte;
-		    ),
-
-	    TP_printk("hugepage invalidate at addr 0x%lx and pte = 0x%lx",
-		      __entry->addr, __entry->pte)
-);
-
 TRACE_EVENT(hugepage_set_pmd,
 
 	    TP_PROTO(unsigned long addr, unsigned long pmd),
@@ -65,23 +47,6 @@ TRACE_EVENT(hugepage_update,
 
 	    TP_printk("hugepage update at addr 0x%lx and pte = 0x%lx clr = 0x%lx, set = 0x%lx", __entry->addr, __entry->pte, __entry->clr, __entry->set)
 );
-TRACE_EVENT(hugepage_splitting,
-
-	    TP_PROTO(unsigned long addr, unsigned long pte),
-	    TP_ARGS(addr, pte),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, addr)
-		    __field(unsigned long, pte)
-		    ),
-
-	    TP_fast_assign(
-		    __entry->addr = addr;
-		    __entry->pte = pte;
-		    ),
-
-	    TP_printk("hugepage splitting at addr 0x%lx and pte = 0x%lx",
-		      __entry->addr, __entry->pte)
-);
 
 #endif /* _TRACE_THP_H */
 
_
