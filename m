Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B872FFA373D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 01:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJYBTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 21:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiJYBTO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 21:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31202FC06
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 17:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F33D616D5
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 00:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45D8C433D6;
        Tue, 25 Oct 2022 00:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666658578;
        bh=1jYUUeH/THx7km+moZ9vEKjJd1lz9HjI0i8UDiGwGYI=;
        h=Date:To:From:Subject:From;
        b=RXl6X7UCmSSdNAEVQ+YLVyIGOyRn7mE/0SH75k81p1s1F7WBmTG9v4tWLr6JX9Cm5
         7CfVIOhbNutQdSQleEif9tlMc1xXWSq0JaW/mKFbMvoijF5V2DZFZy9v9wmFLeI8ud
         aVM4ig6+kONJennuOmXX1OjpzLXWd+gyZR3vkeXc=
Date:   Mon, 24 Oct 2022 17:42:57 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, vbabka@suse.cz,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        kirill.shutemov@linux.intel.com, david@redhat.com,
        gautammenghani201@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-tracepoint-to-collapse_file.patch added to mm-unstable branch
Message-Id: <20221025004258.A45D8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add tracepoint to collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-tracepoint-to-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-tracepoint-to-collapse_file.patch

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

mm-khugepaged-add-tracepoint-to-collapse_file.patch

