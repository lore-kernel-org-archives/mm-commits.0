Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D06CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiGRAVq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiGRAUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C318214D09
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F29D60F32
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B622BC3411E;
        Mon, 18 Jul 2022 00:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103514;
        bh=rYSWAkVWwO1qwmradKgz60dmog+PYURC45Pl1Iz/jXg=;
        h=Date:To:From:Subject:From;
        b=D2hkTvcWzosYv8BrU1/T7xN6QkE6DzvehL9Dk+LvyYViGHgdyHqqUpD/+3pm25h8w
         4Jwn1tVe1suYxftt+YIZgbxokY0n7fO8kJHVYFQMMTBBSb7dN7wr3Yg6jgn3aC8dsp
         3r9TRU2dBXXhZGPeJrYiVt+JNxk7G0qbGiGyVVK4=
Date:   Sun, 17 Jul 2022 17:18:34 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch removed from -mm tree
Message-Id: <20220718001834.B622BC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: check pmd_present first in is_huge_zero_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: check pmd_present first in is_huge_zero_pmd
Date: Mon, 4 Jul 2022 21:21:55 +0800

When pmd is non-present, pmd_pfn returns an insane value. So we should
check pmd_present first to avoid acquiring such insane value and also
avoid touching possible cold huge_zero_pfn cache line when pmd isn't
present.

Link: https://lkml.kernel.org/r/20220704132201.14611-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd
+++ a/include/linux/huge_mm.h
@@ -273,7 +273,7 @@ static inline bool is_huge_zero_page(str
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd) && pmd_present(pmd);
+	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
 }
 
 static inline bool is_huge_zero_pud(pud_t pud)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

