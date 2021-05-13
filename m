Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE3EC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914D1613C2
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhEMTLw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhEMTLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B31613E6;
        Thu, 13 May 2021 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620933031;
        bh=/n7XUl718fXvM2QjTvi6kKKWX6R+CwR0d2oooOaF/VM=;
        h=Date:From:To:Subject:From;
        b=vzGlca4auPWqNvWLk4p0nUC2fV4psJhwd9o6KyYcKtbmHCtGa5xTy76xk4Sd3Efy1
         /AtKofz6p4PhpyMLAwYZYJZWeQ93JtAhaDPWZsrbeyR4BoRvTjIZ1En6njBXohxNJM
         gNv3wrFvqiyXYvcZEIpmk/aXyTrb/SO5GiTG7pp0=
Date:   Thu, 13 May 2021 12:10:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.xiang@zlingsmart.com,
        mm-commits@vger.kernel.org
Subject:  + mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch
 added to -mm tree
Message-ID: <20210513191031.gsBwu94rE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix comment of finish_mkwrite_fault()
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3035,7 +3035,7 @@ oom:
  * The function expects the page to be locked or other protection against
  * concurrent faults / writeback (such as DAX radix tree locks).
  *
- * Return: %VM_FAULT_WRITE on success, %0 when PTE got changed before
+ * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
 vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
_

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are

mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch

