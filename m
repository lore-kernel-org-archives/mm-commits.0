Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60EFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC3E61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWlo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhEHWlm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CAE961402;
        Sat,  8 May 2021 22:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513640;
        bh=BOfY913Grfd1rKG26DHYljIhs6NS6o0kKRog/O5WWWI=;
        h=Date:From:To:Subject:From;
        b=F3HCA29Q5MGCl1MTGvatNQLlnMpk/aO0TkJdoUc/1c2//ya+2xX84EbQkhGQJmhM8
         PT6f6oMsxfAuKXp5ajW0u3ZYCUnMBx2QmpnbB+RgPHWDt19V0TmEYUkG9wgSGEG91h
         wPzwqKno0I7mriPFiurxzVCTCfk5lMEHjvtDCL3Q=
Date:   Sat, 08 May 2021 15:40:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sh1r4s3@mail.si-head.nl, vbabka@suse.cz
Subject:  [merged]
 mm-msync-exit-early-when-the-flags-is-an-ms_async-and-start-vm_start.patch
 removed from -mm tree
Message-ID: <20210508224040.DNZ2Qp8xO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/msync: exit early when the flags is an MS_ASYNC and start < vm_start
has been removed from the -mm tree.  Its filename was
     mm-msync-exit-early-when-the-flags-is-an-ms_async-and-start-vm_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nikita Ermakov <sh1r4s3@mail.si-head.nl>
Subject: mm/msync: exit early when the flags is an MS_ASYNC and start < vm_start

If an unmapped region was found and the flag is MS_ASYNC (without
MS_INVALIDATE) there is nothing to do and the result would be always
-ENOMEM, so return immediately.

Link: https://lkml.kernel.org/r/20201025092901.56399-1-sh1r4s3@mail.si-head.nl
Signed-off-by: Nikita Ermakov <sh1r4s3@mail.si-head.nl>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/msync.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/msync.c~mm-msync-exit-early-when-the-flags-is-an-ms_async-and-start-vm_start
+++ a/mm/msync.c
@@ -55,7 +55,9 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		goto out;
 	/*
 	 * If the interval [start,end) covers some unmapped address ranges,
-	 * just ignore them, but return -ENOMEM at the end.
+	 * just ignore them, but return -ENOMEM at the end. Besides, if the
+	 * flag is MS_ASYNC (w/o MS_INVALIDATE) the result would be -ENOMEM
+	 * anyway and there is nothing left to do, so return immediately.
 	 */
 	mmap_read_lock(mm);
 	vma = find_vma(mm, start);
@@ -69,6 +71,8 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 			goto out_unlock;
 		/* Here start < vma->vm_end. */
 		if (start < vma->vm_start) {
+			if (flags == MS_ASYNC)
+				goto out_unlock;
 			start = vma->vm_start;
 			if (start >= end)
 				goto out_unlock;
_

Patches currently in -mm which might be from sh1r4s3@mail.si-head.nl are


