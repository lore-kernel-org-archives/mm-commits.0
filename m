Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FAAC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiGRAV4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiGRAUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80273112
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379EAB80EE8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FD2C341CA;
        Mon, 18 Jul 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103520;
        bh=yo5ghIvjkyo+Mw8qg0Ob46fsvfOFRHbcv/UGyQqUDUc=;
        h=Date:To:From:Subject:From;
        b=aLK0sKgKZARIu8NahlYguJLCHrYbZhLF5h8sxPGaCFi7nUI3aadWYqR6LQmwBvJbK
         ufX033nZdKX/RqK8OpKYdzh8V36Rhq2OJX/oNna6eVO0SDaGsICG3oElj8gHf1Mp64
         +B3q6x+ceUf17QfhhFMvVkZTmzNdJXvPqids5V3s=
Date:   Sun, 17 Jul 2022 17:18:40 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch removed from -mm tree
Message-Id: <20220718001840.D2FD2C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use helper macro IS_ERR_OR_NULL in split_huge_pages_pid
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: use helper macro IS_ERR_OR_NULL in split_huge_pages_pid
Date: Mon, 4 Jul 2022 21:22:01 +0800

Use helper macro IS_ERR_OR_NULL to check the validity of page to simplify
the code. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220704132201.14611-17-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid
+++ a/mm/huge_memory.c
@@ -2958,9 +2958,7 @@ static int split_huge_pages_pid(int pid,
 		/* FOLL_DUMP to ignore special (like zero) pages */
 		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
-		if (IS_ERR(page))
-			continue;
-		if (!page || is_zone_device_page(page))
+		if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
 			continue;
 
 		if (!is_transparent_hugepage(page))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

