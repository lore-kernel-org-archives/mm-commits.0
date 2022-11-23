Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120CCC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiKWCxO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbiKWCxJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:53:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B516E3D0A
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 999D2619F6
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42E5C433C1;
        Wed, 23 Nov 2022 02:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171988;
        bh=VKwlQgiwHRCGlsgKPPv4DvVUNqnApNEUvxlJPolD95g=;
        h=Date:To:From:Subject:From;
        b=zdS/DLWDFSQ0HyLwCyQflAKKf+7B4BgC4Y62r8SQpXos8hzJ5+qHcU0/Mn/TzP4bM
         p6RJR0uuTE9qSpd3xiuWPJc5pTt9MRosWP+gcUq/4yGW4TLFZuGVPOn+/yw1yAGvkp
         cj/riuA9LS/dlXlRq4AJxklwgM6Yp8Jfy8qbC1V8=
Date:   Tue, 22 Nov 2022 18:53:07 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        david@redhat.com, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch removed from -mm tree
Message-Id: <20221123025307.E42E5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: refactor mm_khugepaged_scan_file tracepoint to remove filename from function call
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/khugepaged: refactor mm_khugepaged_scan_file tracepoint to remove filename from function call
Date: Wed, 26 Oct 2022 10:15:24 +0530

Refactor the mm_khugepaged_scan_file tracepoint to move filename
dereference to the tracepoint definition, to maintain consistency with
other tracepoints[1].

[1]:lore.kernel.org/lkml/20221024111621.3ba17e2c@gandalf.local.home/

Link: https://lkml.kernel.org/r/20221026044524.54793-1-gautammenghani201@gmail.com
Fixes: d41fd2016ed07 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    8 ++++----
 mm/khugepaged.c                    |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call
+++ a/include/trace/events/huge_memory.h
@@ -171,15 +171,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, const char *filename,
+	TP_PROTO(struct mm_struct *mm, struct page *page, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, page, filename, present, swap, result),
+	TP_ARGS(mm, page, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, pfn)
-		__string(filename, filename)
+		__string(filename, file->f_path.dentry->d_iname)
 		__field(int, present)
 		__field(int, swap)
 		__field(int, result)
@@ -188,7 +188,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->pfn = page ? page_to_pfn(page) : -1;
-		__assign_str(filename, filename);
+		__assign_str(filename, file->f_path.dentry->d_iname);
 		__entry->present = present;
 		__entry->swap = swap;
 		__entry->result = result;
--- a/mm/khugepaged.c~mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call
+++ a/mm/khugepaged.c
@@ -2153,8 +2153,7 @@ static int hpage_collapse_scan_file(stru
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, page, file->f_path.dentry->d_iname,
-				      present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, page, file, present, swap, result);
 	return result;
 }
 #else
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are

mm-khugepaged-add-tracepoint-to-collapse_file.patch

