Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C49FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiJ0UgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbiJ0Uf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:35:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F029253A7C
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D746624EB
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8FCC433D6;
        Thu, 27 Oct 2022 20:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666902953;
        bh=ixjw/IeXcqyfu1Eq5vrMYDxQaKtmOyQ2+dlyO+0HRfI=;
        h=Date:To:From:Subject:From;
        b=WFozm8P2NJHfQvzCSl5QH/IrqmhF8imUfcxdR9SpAA7GqF4feJp/7DXDywN7tSRFG
         hV/5F7M/3W9VbD+TteA6VTi0/7wxhlv8padLqlSnXZISg1nS9mRKBk/vT8gJ7BJjJM
         eYgQshw57s2sO3zuM7KdPw0OKyZJlkgZrScVyOyw=
Date:   Thu, 27 Oct 2022 13:35:52 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, rostedt@goodmis.org, mhiramat@kernel.org,
        david@redhat.com, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch added to mm-unstable branch
Message-Id: <20221027203553.AD8FCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: refactor mm_khugepaged_scan_file tracepoint to remove filename from function call
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch

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
Subject: mm/khugepaged: refactor mm_khugepaged_scan_file tracepoint to remove filename from function call
Date: Wed, 26 Oct 2022 10:15:24 +0530

Refactor the mm_khugepaged_scan_file tracepoint to move filename
dereference to the tracepoint definition, for maintaing consistency with
other tracepoints[1].

[1]:lore.kernel.org/lkml/20221024111621.3ba17e2c@gandalf.local.home/

Link: https://lkml.kernel.org/r/20221026044524.54793-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -2158,8 +2158,7 @@ static int hpage_collapse_scan_file(stru
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
mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call.patch

