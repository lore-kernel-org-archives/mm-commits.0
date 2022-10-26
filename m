Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D120C38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 01:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiJZBoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 21:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiJZBoA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 21:44:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E05DFB42
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 18:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B8D61C44
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 01:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBD7C433B5;
        Wed, 26 Oct 2022 01:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666748638;
        bh=OoFYNNISGR8FD9bDXQQNbwUSbPwgcNFWzVUZ9IWI4xs=;
        h=Date:To:From:Subject:From;
        b=b7ZIS0vaYt9+QnMbExLZdT+xWzNKyK0QdIxAfzFlaRE+Z+3zbTshw1JT1hzNCdAD6
         NFOd11VrPC7hg54HtmU/BSXe/FdVgQG9kQcOT+0PE+uQCBMkNEaNX/IroDZ9m3auLE
         YirgJ2OpkXJ+qZQtIwX0hK+whOTe3kfZlhaYZEU8=
Date:   Tue, 25 Oct 2022 18:43:57 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, vbabka@suse.cz,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        kirill.shutemov@linux.intel.com, david@redhat.com,
        gautammenghani201@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-khugepaged-add-tracepoint-to-collapse_file.patch removed from -mm tree
Message-Id: <20221026014358.6DBD7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: add tracepoint to collapse_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-tracepoint-to-collapse_file.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/khugepaged: add tracepoint to collapse_file()
Date: Mon, 24 Oct 2022 23:05:58 +0530

In mm/khugepaged.c, a TODO in the function collapse_file() asks to add
tracepoints.  Add the tracepoint named "mm_khugepaged_collapse_file".

Link: https://lkml.kernel.org/r/20221024173559.332324-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   38 +++++++++++++++++++++++++++
 mm/khugepaged.c                    |    4 ++
 2 files changed, 41 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-tracepoint-to-collapse_file
+++ a/include/trace/events/huge_memory.h
@@ -203,5 +203,43 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_collapse_file,
+	TP_PROTO(struct mm_struct *mm, struct page *hpage, pgoff_t index,
+			bool is_shmem, unsigned long addr, struct file *file,
+			int nr, int result),
+	TP_ARGS(mm, hpage, index, is_shmem, addr, file, nr, result),
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, hpfn)
+		__field(pgoff_t, index)
+		__field(bool, is_shmem)
+		__field(unsigned long, addr)
+		__string(filename, file->f_path.dentry->d_iname)
+		__field(int, nr)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->hpfn = hpage ? page_to_pfn(hpage) : -1;
+		__entry->index = index;
+		__entry->is_shmem = is_shmem;
+		__entry->addr = addr;
+		__assign_str(filename, file->f_path.dentry->d_iname);
+		__entry->nr = nr;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, is_shmem=%d, addr=%ld, filename=%s, nr=%d, result=%s",
+		__entry->mm,
+		__entry->hpfn,
+		__entry->index,
+		__entry->is_shmem,
+		__entry->addr,
+		__get_str(filename),
+		__entry->nr,
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
--- a/mm/khugepaged.c~mm-khugepaged-add-tracepoint-to-collapse_file
+++ a/mm/khugepaged.c
@@ -2059,7 +2059,9 @@ out:
 		mem_cgroup_uncharge(page_folio(hpage));
 		put_page(hpage);
 	}
-	/* TODO: tracepoints */
+
+	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem,
+		addr, file, nr, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are


