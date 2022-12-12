Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C5C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 00:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiLLAFq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 19:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLAFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 19:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFBB766F
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 16:05:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A3EB80B25
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 00:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9DCC433EF;
        Mon, 12 Dec 2022 00:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670803540;
        bh=HDzNclwmEOSBiZsmyja3IjigBMW12hzVwHJ3pMA53VE=;
        h=Date:To:From:Subject:From;
        b=UoXgZZf/nvX7KjH6wYGq4BegF1EQ5w1qcWSbcawkG46z/NdTGnFlqAPNnvwnrWus7
         uMhx1TJnlbYlQEuXV4UdkOsSmH4MbDkl1u69AXLxOqvNXTU+eAWBKUR6CDm7S/0yXo
         7dr+BWOPtQUEDQ7QCdMQkLMrNYeKhkIk6aehHPMg=
Date:   Sun, 11 Dec 2022 16:05:39 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        david@redhat.com, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-add-tracepoint-to-collapse_file-v4.patch removed from -mm tree
Message-Id: <20221212000540.AD9DCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-khugepaged-add-tracepoint-to-collapse_file-v4
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-add-tracepoint-to-collapse_file-v4.patch

This patch was dropped because it was folded into mm-khugepaged-add-tracepoint-to-collapse_file.patch

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm-khugepaged-add-tracepoint-to-collapse_file-v4
Date: Sat, 3 Dec 2022 01:48:07 +0530

swap is_shmem and addr to save space, per Steven Rostedt

Link: https://lkml.kernel.org/r/20221202201807.182829-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-add-tracepoint-to-collapse_file-v4
+++ a/include/trace/events/huge_memory.h
@@ -207,13 +207,13 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 	TP_PROTO(struct mm_struct *mm, struct page *hpage, pgoff_t index,
 			bool is_shmem, unsigned long addr, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, hpage, index, is_shmem, addr, file, nr, result),
+	TP_ARGS(mm, hpage, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
 		__field(pgoff_t, index)
-		__field(bool, is_shmem)
 		__field(unsigned long, addr)
+		__field(bool, is_shmem)
 		__string(filename, file->f_path.dentry->d_iname)
 		__field(int, nr)
 		__field(int, result)
@@ -223,19 +223,19 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__entry->mm = mm;
 		__entry->hpfn = hpage ? page_to_pfn(hpage) : -1;
 		__entry->index = index;
-		__entry->is_shmem = is_shmem;
 		__entry->addr = addr;
+		__entry->is_shmem = is_shmem;
 		__assign_str(filename, file->f_path.dentry->d_iname);
 		__entry->nr = nr;
 		__entry->result = result;
 	),
 
-	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, is_shmem=%d, addr=%ld, filename=%s, nr=%d, result=%s",
+	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%ld, is_shmem=%d, filename=%s, nr=%d, result=%s",
 		__entry->mm,
 		__entry->hpfn,
 		__entry->index,
-		__entry->is_shmem,
 		__entry->addr,
+		__entry->is_shmem,
 		__get_str(filename),
 		__entry->nr,
 		__print_symbolic(__entry->result, SCAN_STATUS))
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are

mm-khugepaged-add-tracepoint-to-collapse_file.patch

