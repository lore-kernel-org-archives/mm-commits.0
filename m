Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1028C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiLLCOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiLLCNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62480DECE
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E68FB80B3C
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD332C433F0;
        Mon, 12 Dec 2022 02:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811223;
        bh=pJ+Tt04lpQJ6JgW20PricSLMSRF2uLXLLBabLurl4WY=;
        h=Date:To:From:Subject:From;
        b=BDqNAZrP4eouUfCIRZNkS3ffBPD/coTimF5DnPrHUoQ75HQmcNtQl00QxSXtp2Kfv
         O0tFLCPwaEBuj+ZJ0OIDK9ot5HkoPuH0gOAfJtIH5Fve4G1Wg7CPBMBGceFxPeXdqN
         OyIoPb46SgcsqbxLwI+ToSim8cUK2XbVGuWNFEFI=
Date:   Sun, 11 Dec 2022 18:13:43 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        david@redhat.com, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-add-tracepoint-to-collapse_file.patch removed from -mm tree
Message-Id: <20221212021343.BD332C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: add tracepoint to collapse_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-tracepoint-to-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/khugepaged: add tracepoint to collapse_file()
Date: Wed, 26 Oct 2022 10:52:18 +0530

"mm_khugepaged_collapse_file" for capturing is_shmem.
Currently, is_shmem is not being captured. Capturing is_shmem is useful
as it can indicate if tmpfs is being used as a backing store instead of
persistent storage. Add the tracepoint in collapse_file() named
"mm_khugepaged_collapse_file" for capturing is_shmem.

[gautammenghani201@gmail.com: swap is_shmem and addr to save space, per Steven Rostedt]
  Link: https://lkml.kernel.org/r/20221202201807.182829-1-gautammenghani201@gmail.com
Link: https://lkml.kernel.org/r/20221026052218.148234-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>	[tracing]
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   38 +++++++++++++++++++++++++++
 mm/khugepaged.c                    |    7 ++--
 2 files changed, 42 insertions(+), 3 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-tracepoint-to-collapse_file
+++ a/include/trace/events/huge_memory.h
@@ -203,5 +203,43 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_collapse_file,
+	TP_PROTO(struct mm_struct *mm, struct page *hpage, pgoff_t index,
+			bool is_shmem, unsigned long addr, struct file *file,
+			int nr, int result),
+	TP_ARGS(mm, hpage, index, addr, is_shmem, file, nr, result),
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, hpfn)
+		__field(pgoff_t, index)
+		__field(unsigned long, addr)
+		__field(bool, is_shmem)
+		__string(filename, file->f_path.dentry->d_iname)
+		__field(int, nr)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->hpfn = hpage ? page_to_pfn(hpage) : -1;
+		__entry->index = index;
+		__entry->addr = addr;
+		__entry->is_shmem = is_shmem;
+		__assign_str(filename, file->f_path.dentry->d_iname);
+		__entry->nr = nr;
+		__entry->result = result;
+	),
+
+	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%ld, is_shmem=%d, filename=%s, nr=%d, result=%s",
+		__entry->mm,
+		__entry->hpfn,
+		__entry->index,
+		__entry->addr,
+		__entry->is_shmem,
+		__get_str(filename),
+		__entry->nr,
+		__print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
--- a/mm/khugepaged.c~mm-khugepaged-add-tracepoint-to-collapse_file
+++ a/mm/khugepaged.c
@@ -1744,12 +1744,12 @@ static int collapse_file(struct mm_struc
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
@@ -2102,7 +2102,8 @@ out:
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


