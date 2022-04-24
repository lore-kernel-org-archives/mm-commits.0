Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE902C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiDXUVp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiDXUVo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:21:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F86213137A
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC385B80E45
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DE1C385A9;
        Sun, 24 Apr 2022 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650831519;
        bh=wPqc3RZgZCbF5iveZL3F7TFWeM8VwJyDVvOgaQYOhKw=;
        h=Date:To:From:Subject:From;
        b=MihXah8+Id2N5tCTN1xo/1HpIaabLpgJfYJVzn0m+gAk0iWBsuceC97GS1Toxj9x6
         R7uolaNg51wQ+O2cfvvVxgDXcvRZjv6vEb1uLka7SlSTxG6li3MDOQApsxpPzhv4h5
         tozxRLmDY3GRSZpNWihA4lzhb/KcIO0By3USvPVk=
Date:   Sun, 24 Apr 2022 13:18:38 -0700
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-vma_is_anonymous.patch added to -mm tree
Message-Id: <20220424201839.87DE1C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: use vma_is_anonymous
has been added to the -mm tree.  Its filename is
     mm-khugepaged-use-vma_is_anonymous.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-use-vma_is_anonymous.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-use-vma_is_anonymous.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: mm/khugepaged: use vma_is_anonymous

Clean up the vma->vm_ops usage.  Use vma_is_anonymous instead of
vma->vm_ops to make it more understandable.

Link: https://lkml.kernel.org/r/20220424071642.3234971-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-vma_is_anonymous
+++ a/mm/khugepaged.c
@@ -466,7 +466,7 @@ static bool hugepage_vma_check(struct vm
 	if (file_thp_enabled(vma))
 		return true;
 
-	if (!vma->anon_vma || vma->vm_ops)
+	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return false;
 	if (vma_is_temporary_stack(vma))
 		return false;
@@ -982,7 +982,7 @@ static int hugepage_vma_revalidate(struc
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

mm-khugepaged-use-vma_is_anonymous.patch
ksm-count-ksm-merging-pages-for-each-process.patch
kernel-make-taskstats-available-from-all-net-namespaces.patch

