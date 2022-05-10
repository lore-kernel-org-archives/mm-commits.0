Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21989C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbiEJEUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiEJESQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D18243106
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3233B81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EA2C385C2;
        Tue, 10 May 2022 04:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156055;
        bh=RnmmPBG+mZQk+iA8ODA/T9hHBbT7GtEtoR5Rl+oV+9c=;
        h=Date:To:From:Subject:From;
        b=dQVILGUhHUr4LaolWKqzsQesTCTBhORqk0+rZYE2rT87wYDw6kNJnJ/qprZqoeHzB
         LpiC1Uio7SUwyyPhioeNhiMtXkauKjF61cWGntCJBZyOMZRjjagPPYZ303ARwOmazv
         gCVNekIVlXubDLzSzjuQc5Hlwruk/xpVTYb538RM=
Date:   Mon, 09 May 2022 21:14:14 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        xu.xin16@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-vma_is_anonymous.patch removed from -mm tree
Message-Id: <20220510041415.70EA2C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: use vma_is_anonymous
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-vma_is_anonymous.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/khugepaged: use vma_is_anonymous

Clean up the vma->vm_ops usage.  Use vma_is_anonymous instead of
vma->vm_ops to make it more understandable.

Link: https://lkml.kernel.org/r/20220424071642.3234971-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-vma_is_anonymous
+++ a/mm/khugepaged.c
@@ -466,7 +466,7 @@ static bool hugepage_vma_check(struct vm
 			S_ISREG(inode->i_mode);
 	}
 
-	if (!vma->anon_vma || vma->vm_ops)
+	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return false;
 	if (vma_is_temporary_stack(vma))
 		return false;
@@ -972,7 +972,7 @@ static int hugepage_vma_revalidate(struc
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
 	/* Anon VMA expected */
-	if (!vma->anon_vma || vma->vm_ops)
+	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return SCAN_VMA_CHECK;
 	return 0;
 }
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


