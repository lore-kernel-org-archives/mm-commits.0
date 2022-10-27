Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53251FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiJ0Uai (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiJ0Uah (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153065FC34
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B709DB827D2
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366AAC433D6;
        Thu, 27 Oct 2022 20:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666902633;
        bh=s4bI9s3YcofHQDJeewrofpn113ye2S7D4GZTDTa/BB4=;
        h=Date:To:From:Subject:From;
        b=WAARNdGqwtPz5YbTUj2hQnxIUFBEhz0cqR2l3ONbI9aGcWg34cj8IdIEmh//HnoQi
         2/A63Xtk5YHX9sxp68pH4xO18+m8gYIsnChGPZaINEPF6pXRfH7yuHRvpmq9ibLbxL
         y2ITOn7gh6S64zQ4RvnYyd3z/cNNs6F5QomY3GXk=
Date:   Thu, 27 Oct 2022 13:30:32 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        david@redhat.com, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-tracepoint-to-collapse_file.patch added to mm-unstable branch
Message-Id: <20221027203033.366AAC433D6@smtp.kernel.org>
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
Date: Wed, 26 Oct 2022 10:52:18 +0530

Currently, is_shmem is not being captured.  Capturing is_shmem is useful
as it can indicate if tmpfs is being used as a backing store instead of
persistent storage.  Add the tracepoint in collapse_file() named
"mm_khugepaged_collapse_file" for capturing is_shmem.

Link: https://lkml.kernel.org/r/20221026052218.148234-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -1702,12 +1702,12 @@ static int collapse_file(struct mm_struc
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *hpage;
-	pgoff_t index, end = start + HPAGE_PMD_NR;
+	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
-	int nr;
+	int nr = 0;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
@@ -2059,7 +2059,8 @@ out:
 		mem_cgroup_uncharge(page_folio(hpage));
 		put_page(hpage);
 	}
-	/* TODO: tracepoints */
+
+	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem, addr, file, nr, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are

mm-khugepaged-add-tracepoint-to-collapse_file.patch

