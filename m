Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4257C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 607BA64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhBXUGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhBXUFy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3EB964F31;
        Wed, 24 Feb 2021 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197087;
        bh=c04nelTSFATbEmttuyWFPL753KSZH3WH9JphC+q50wg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E8HNuA8A6+YYmOpYnWWmw6qupGzOBLphP1S4+0REheTgGu67/nCoZJth7s7YFslyy
         7Do1jlQDsuqfEClFC155nuWEQBVWuXQvcWw8wFSFLx09eIsaXQU6UMg7d0qxyvY5B/
         PBAHo9XmhaU7YAwWQoJbnnbRifRydV87MTsynQn8=
Date:   Wed, 24 Feb 2021 12:04:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jarkko@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
        torvalds@linux-foundation.org, zhang.jia@linux.alibaba.com
Subject:  [patch 081/173] mm/mprotect.c: optimize error detection
 in do_mprotect_pkey()
Message-ID: <20210224200446.uerlj0CaI%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: mm/mprotect.c: optimize error detection in do_mprotect_pkey()

Obviously, the error variable detection of the if statement is
for the mprotect callback function, so it is also put into the
scope of calling callbck.

This is a cleanup which makes this site consistent with the rest of this
function's error handling.

Link: https://lkml.kernel.org/r/20210118133310.98375-1-tianjia.zhang@linux.alibaba.com
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
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
