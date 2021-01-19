Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5B2C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC5723107
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbhASUAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392176AbhASUAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:00:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF7023104;
        Tue, 19 Jan 2021 20:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611086403;
        bh=2BugEwhofgwIrUFBm/W7olnjtj9Dx/nnQ8HxgzBmx5w=;
        h=Date:From:To:Subject:From;
        b=S3QgosvvRBXeuG+ndvqBauovpcnb101tnZNtaolqUEBJYWJ+pEKvy3Ehk3t0gZJb2
         khgbhed/ZhPS7AlvnsTepcaJWpw5uo3+ycd6tSdZ1z3htC9nwBXkylnHP/aRtend+4
         FZw9q0W2heSpj8kY4pRY8qO05uu19bvu8eRBp5uw=
Date:   Tue, 19 Jan 2021 12:00:02 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com, zhang.jia@linux.alibaba.com
Subject:  +
 mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch added to
 -mm tree
Message-ID: <20210119200002.dsPO1K-pu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: optimize error detection in do_mprotect_pkey()
has been added to the -mm tree.  Its filename is
     mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: mm/mprotect.c: optimize error detection in do_mprotect_pkey()

Obviously, the error variable detection of the if statement is
for the mprotect callback function, so it is also put into the
scope of calling callbck.

Link: https://lkml.kernel.org/r/20210118133310.98375-1-tianjia.zhang@linux.alibaba.com
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-optimizing-error-condition-detection-in-do_mprotect_pkey
+++ a/mm/mprotect.c
@@ -617,10 +617,11 @@ static int do_mprotect_pkey(unsigned lon
 		if (tmp > end)
 			tmp = end;
 
-		if (vma->vm_ops && vma->vm_ops->mprotect)
+		if (vma->vm_ops && vma->vm_ops->mprotect) {
 			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
-		if (error)
-			goto out;
+			if (error)
+				goto out;
+		}
 
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
_

Patches currently in -mm which might be from tianjia.zhang@linux.alibaba.com are

mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch

