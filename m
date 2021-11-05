Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17CCC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0DA4611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhKEUlo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0016056B;
        Fri,  5 Nov 2021 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144743;
        bh=kjdyWl6bfgEGl5f491e/pYQgwifhEzyB6NH8Q0LTYHo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H3Fp7F0cggfptGIjCRflLkByF630/2Zs0To0wwU92GG5Uw81sqKWjwemk6pRpuUMf
         vM0C85M9cBTKXiQqjNgRsVrWUKPXjdkSFUb0wqdE+RtGvnbhdeekjG4QDNZ6wloODB
         AzjckXuyg0eH3XpJ5dbI6nSP5SFtD57nyhTr1gcs=
Date:   Fri, 05 Nov 2021 13:39:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liu.song11@zte.com.cn, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 084/262] mm/mprotect.c: avoid repeated assignment
 in do_mprotect_pkey()
Message-ID: <20211105203903.w6-SbZ0O3%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu Song <liu.song11@zte.com.cn>
Subject: mm/mprotect.c: avoid repeated assignment in do_mprotect_pkey()

After adjustment, the repeated assignment of "prev" is avoided, and the
readability of the code is improved.

Link: https://lkml.kernel.org/r/20211012152444.4127-1-fishland@aliyun.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotectc-avoid-repeated-assignment-in-do_mprotect_pkey
+++ a/mm/mprotect.c
@@ -563,7 +563,7 @@ static int do_mprotect_pkey(unsigned lon
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
-	prev = vma->vm_prev;
+
 	if (unlikely(grows & PROT_GROWSDOWN)) {
 		if (vma->vm_start >= end)
 			goto out;
@@ -581,8 +581,11 @@ static int do_mprotect_pkey(unsigned lon
 				goto out;
 		}
 	}
+
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = vma->vm_prev;
 
 	for (nstart = start ; ; ) {
 		unsigned long mask_off_old_flags;
_
