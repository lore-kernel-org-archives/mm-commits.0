Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76711C6FA82
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 19:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiIYTOC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 15:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiIYTNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 15:13:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591202A256
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 12:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CA92CE0DF9
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 19:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94084C433C1;
        Sun, 25 Sep 2022 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664133216;
        bh=JsG1UoPewQbOMOEhKqcW19F3ClkHu3/IFAyP5OD8vi8=;
        h=Date:To:From:Subject:From;
        b=ipCA+IkY4rsC6KGlwkss29P4OAbNAphwlF0Rry9DGTJqT6QC7zmoqnYSdhH53otvP
         qPLw31UYp9EY6QKlEapOwNxwRldRx0vAamyC2Pk30phWeE5b2OBnzHpwjbZjEjl2ot
         HuCKC86ieraEVfJt5azd4iWJBhV2sy+LDQc1GZ80=
Date:   Sun, 25 Sep 2022 12:13:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch added to mm-unstable branch
Message-Id: <20220925191336.94084C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add tracepoint to hpage_collapse_scan_file()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch

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
@@ -2159,7 +2159,8 @@ static int hpage_collapse_scan_file(stru
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

mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch
mm-madvise-madv_collapse-return-eagain-when-page-cannot-be-isolated.patch
selftests-vm-retry-on-eagain-for-madv_collapse-selftest.patch
mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

