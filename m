Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EBEC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJCVRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJCVPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EF54E868
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD53ACE0E7C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3254BC433D7;
        Mon,  3 Oct 2022 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831404;
        bh=yQPyCslVNC2tx60DMlU7FB/7iJbduIFh/82ec7S0ri8=;
        h=Date:To:From:Subject:From;
        b=wYGJSuPLZqVkacKPgtMP2sWalHL4It+QpWduTNT57C5p5mFD+UaVSU4lbV1IEaXn7
         txkofg1g4EF6Llp5NqqV7++ZsGZ9WbIcdDzpppe4B+D+2z/Nf+3kcY1nOiR3rACJol
         DxdocRx4dJ7jrdA5hVs1l4L+Fikrw7aOOXbHdCwE=
Date:   Mon, 03 Oct 2022 14:10:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch removed from -mm tree
Message-Id: <20221003211004.3254BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: add tracepoint to hpage_collapse_scan_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: add tracepoint to hpage_collapse_scan_file()
Date: Thu, 22 Sep 2022 15:40:40 -0700

Add huge_memory:trace_mm_khugepaged_scan_file tracepoint to
hpage_collapse_scan_file() analogously to hpage_collapse_scan_pmd().

While this change is targeted at debugging MADV_COLLAPSE pathway, the
"mm_khugepaged" prefix is retained for symmetry with
huge_memory:trace_mm_khugepaged_scan_pmd, which retains it's legacy name
to prevent changing kernel ABI as much as possible.

Link: https://lkml.kernel.org/r/20220907144521.3115321-5-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220922224046.1143204-5-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   34 +++++++++++++++++++++++++++
 mm/khugepaged.c                    |    3 +-
 2 files changed, 36 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file
+++ a/include/trace/events/huge_memory.h
@@ -169,5 +169,39 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 		__entry->ret)
 );
 
+TRACE_EVENT(mm_khugepaged_scan_file,
+
+	TP_PROTO(struct mm_struct *mm, struct page *page, const char *filename,
+		 int present, int swap, int result),
+
+	TP_ARGS(mm, page, filename, present, swap, result),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, pfn)
+		__string(filename, filename)
+		__field(int, present)
+		__field(int, swap)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__assign_str(filename, filename);
+		__entry->present = present;
+		__entry->swap = swap;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, scan_pfn=0x%lx, filename=%s, present=%d, swap=%d, result=%s",
+		__entry->mm,
+		__entry->pfn,
+		__get_str(filename),
+		__entry->present,
+		__entry->swap,
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
--- a/mm/khugepaged.c~mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file
+++ a/mm/khugepaged.c
@@ -2157,7 +2157,8 @@ static int hpage_collapse_scan_file(stru
 		}
 	}
 
-	/* TODO: tracepoints */
+	trace_mm_khugepaged_scan_file(mm, page, file->f_path.dentry->d_iname,
+				      present, swap, result);
 	return result;
 }
 #else
_

Patches currently in -mm which might be from zokeefe@google.com are


