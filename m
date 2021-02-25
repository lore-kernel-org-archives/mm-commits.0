Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7FAC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1734764F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhBYT2D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234308AbhBYTZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B7064F78;
        Thu, 25 Feb 2021 19:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280503;
        bh=E92laFKK8HDajPBioHdRf/Z0ofTeEkTnrmvwt4I3wr0=;
        h=Date:From:To:Subject:From;
        b=dUFbNPQEJTyroQ991nlzkVgmyNiW3IURanO6YC3gr4l1Xn9i/R4l8WC06isnz/dTa
         CqiDoHpCV8e7ulWQL7DzpdepGgoe4+R2UxRGnECAyp0hoqakRantRUz/tDuF7fcK76
         QYDiMlbyKp7kpVmfgkEHTUv+wJpmpKMLnEFdbARQ=
Date:   Thu, 25 Feb 2021 11:15:02 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, jarkko@kernel.org,
        mm-commits@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
        zhang.jia@linux.alibaba.com
Subject:  [merged]
 mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch removed
 from -mm tree
Message-ID: <20210225191502.r6Bvio8uP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: optimize error detection in do_mprotect_pkey()
has been removed from the -mm tree.  Its filename was
     mm-optimizing-error-condition-detection-in-do_mprotect_pkey.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from tianjia.zhang@linux.alibaba.com are


