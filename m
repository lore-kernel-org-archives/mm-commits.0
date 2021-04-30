Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F274CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D733361462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3F4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3F4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA9F61463;
        Fri, 30 Apr 2021 05:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762142;
        bh=Jo+jYjLuKCde1tu6xch80s7EpfWHARAp6UsrZijywSM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sPbC8YBv4a1l9IBCOWJYntZ2SL1F3D2+ePKy0oBK2xmIBWxqWdVyNGaZSpuUibLO9
         y5uLHnX36BBzXF0QIVKB/2TNhTQbZU9OEqp+PezIFpXLzkqfY+TODcECIvSr6VfFJ/
         7WN+HIhrntS0Vck/qfk2AzoG12abwm4tmGlYQxoE=
Date:   Thu, 29 Apr 2021 22:55:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh1r4s3@mail.si-head.nl,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 049/178] mm/msync: exit early when the flags is an
 MS_ASYNC and start < vm_start
Message-ID: <20210430055541.k_Y51wMDK%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
