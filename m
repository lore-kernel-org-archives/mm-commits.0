Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742E1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377879AbiATV1n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58630 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377877AbiATV1n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C30B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF40CC340E0;
        Thu, 20 Jan 2022 21:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714061;
        bh=KIv3mLgVMgm+UcrQo5ZwLC97Ww6h3cE36QEUspWx2Po=;
        h=Date:From:To:Subject:From;
        b=BCO0aw0Y2RfA71hiBZ2aXMJziMVMcLIyB06Q2lY8JC6ove/NzWiMwB/NSz/9pPzek
         zW8p2lkicPPsMkTKgma7EajecMcInDvkUJNDnUb5rZwKv0lg+hyiXLyyjCvgumvlCI
         OExn3HDwkBUNydJa2wCIOA7kS/g2gflTKtrBhThw=
Date:   Thu, 20 Jan 2022 13:27:40 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, kirill@shutemov.name,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org
Subject:  [merged] mm-thp-drop-unused-trace-events-hugepage_.patch
 removed from -mm tree
Message-ID: <20220120212740.vXCTr-Oyi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: drop unused trace events hugepage_[invalidate|splitting]
has been removed from the -mm tree.  Its filename was
     mm-thp-drop-unused-trace-events-hugepage_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from anshuman.khandual@arm.com are


