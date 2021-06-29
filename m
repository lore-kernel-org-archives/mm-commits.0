Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B33DC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F6A61D0F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhF2ClQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2ClP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9C461D08;
        Tue, 29 Jun 2021 02:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934328;
        bh=CkOWozef2jF91yeqqpFa3EHOgqiOtWukGXtXq1y4KDY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ytRuykVSG7Tis1psbnqcbNvndZSOR0Xe7B7vGjq5cKZTHtGU6Qil5Nm49w1a+yg8S
         LYga99BqXmHB1DRV0zHe/8eIw53cZC2Y+7HNLLeNVRPh0AebWldQemrxuO9zDG1QEQ
         zjbDIChJk0BVSygOR+wk+r66Tvbg2yG1g873jWis=
Date:   Mon, 28 Jun 2021 19:38:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liu.xiang@zlingsmart.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 104/192] mm/memory.c: fix comment of
 finish_mkwrite_fault()
Message-ID: <20210629023847.252wPFTv5%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm/memory.c: fix comment of finish_mkwrite_fault()

Fix the return value in comment of finish_mkwrite_fault().

Link: https://lkml.kernel.org/r/20210513093931.15234-1-liu.xiang@zlingsmart.com
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-comment-of-finish_mkwrite_fault
+++ a/mm/memory.c
@@ -3049,7 +3049,7 @@ oom:
  * The function expects the page to be locked or other protection against
  * concurrent faults / writeback (such as DAX radix tree locks).
  *
- * Return: %VM_FAULT_WRITE on success, %0 when PTE got changed before
+ * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
 vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
_
