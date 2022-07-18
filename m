Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6C2CCA487
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiGRARr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiGRARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FBC12A9D
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4470460F43
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5C1C3411E;
        Mon, 18 Jul 2022 00:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103420;
        bh=24RFkN2844SXIkEGuT+FwLt/Lvr0ke8ULtFnkme8g0A=;
        h=Date:To:From:Subject:From;
        b=pWbez3DB9LKPvbbeo/o/XQDdu8cKs4Fhz/K8uBfgSn0uNAffmrSfKGCk8COTC+7R8
         RTcRAiEyqx3WLul/vBaO5uFrVOyvyM7T1dUxsbl/4WJX6h9NpyMeVf7UOx1c4NWdeI
         9NOwhbkdPbcmfRuRHW53cjZP35ebjw2LzqY2dtvg=
Date:   Sun, 17 Jul 2022 17:17:00 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch removed from -mm tree
Message-Id: <20220718001700.9B5C1C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: better comments for anon vma check in hugepage_vma_revalidate
Date: Thu, 16 Jun 2022 10:48:36 -0700

The hugepage_vma_revalidate() needs to check if the vma is still anonymous
vma or not since the address may be unmapped then remapped to file before
khugepaged reaquired the mmap_lock.

The old comment is not quite helpful, elaborate this with better comment.

Link: https://lkml.kernel.org/r/20220616174840.1202070-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-better-comments-for-anon-vma-check-in-hugepage_vma_revalidate
+++ a/mm/khugepaged.c
@@ -958,7 +958,13 @@ static int hugepage_vma_revalidate(struc
 		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags))
 		return SCAN_VMA_CHECK;
-	/* Anon VMA expected */
+	/*
+	 * Anon VMA expected, the address may be unmapped then
+	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 *
+	 * hugepage_vma_check may return true for qualified file
+	 * vmas.
+	 */
 	if (!vma->anon_vma || !vma_is_anonymous(vma))
 		return SCAN_VMA_CHECK;
 	return 0;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

