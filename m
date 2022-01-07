Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D03C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jan 2022 23:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiAGXjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jan 2022 18:39:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58734 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiAGXjj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jan 2022 18:39:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92628CE2D37
        for <mm-commits@vger.kernel.org>; Fri,  7 Jan 2022 23:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4583C36AE5;
        Fri,  7 Jan 2022 23:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641598775;
        bh=eO22co47yzFPBiWtjhDJYJeXKKcdCKI7brpdQm18vvY=;
        h=Date:From:To:Subject:From;
        b=1ShyGfU6vW02c8iMdNzEWrPvPRlfM8VDlZpVVU9smNpArspWfyPgLVkex38hEWQYo
         A7564pmIFc/g7IJB+bmYTlqLfWFadoSS2FxHtaTVjhNfdxLgCtGmodcRbXWelZ3Zrk
         8jfrypTeB72Vf7egNgONWhRCypjJ1do0P1uVjAYU=
Date:   Fri, 07 Jan 2022 15:39:35 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, rostedt@goodmis.org
Subject:  + mm-thp-drop-unused-trace-events-hugepage_.patch added
 to -mm tree
Message-ID: <20220107233935.oC9tgKuLm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: drop unused trace events hugepage_[invalidate|splitting]
has been added to the -mm tree.  Its filename is
     mm-thp-drop-unused-trace-events-hugepage_.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-drop-unused-trace-events-hugepage_.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-drop-unused-trace-events-hugepage_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/thp.h |   36 -----------------------------------
 1 file changed, 36 deletions(-)

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
@@ -65,24 +47,6 @@ TRACE_EVENT(hugepage_update,
 
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
-
 #endif /* _TRACE_THP_H */
 
 /* This part must be outside protection */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
mm-thp-drop-unused-trace-events-hugepage_.patch

