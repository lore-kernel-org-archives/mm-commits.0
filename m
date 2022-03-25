Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FA2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354632AbiCYBel (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357356AbiCYBdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB03DA66
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E33A4B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E8DC340EC;
        Fri, 25 Mar 2022 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171925;
        bh=lMBfV0OefIGN7TOXuolDvvErmQDbK338igpGipkQnlI=;
        h=Date:To:From:Subject:From;
        b=F4v/W/sj0g0AtK+22J+WQ51cHPiYOlP6MLxtScFp1DPs5HPOkYPTVmHmLoVFqU55b
         hhcyC1Tpd2hhFC0c3OgAa7TiNyugB7rf/gtib1p8xovwQX+uMQRxL+1vUCBeADR2aT
         zlemXTo6y2oX4tBJfYk5iNxi+0MvmmoaE99DpEmY=
Date:   Thu, 24 Mar 2022 18:32:04 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-remove-unneeded-local-variable-follflags-v2.patch removed from -mm tree
Message-Id: <20220325013205.80E8DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unneeded local variable follflags
has been removed from the -mm tree.  Its filename was
     mm-remove-unneeded-local-variable-follflags-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove unneeded local variable follflags

We can pass FOLL_GET | FOLL_DUMP to follow_page directly to simplify the
code a bit in add_page_for_migration and split_huge_pages_pid.

Link: https://lkml.kernel.org/r/20220311072002.35575-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 mm/migrate.c     |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-remove-unneeded-local-variable-follflags-v2
+++ a/mm/huge_memory.c
@@ -2953,7 +2953,6 @@ static int split_huge_pages_pid(int pid,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = find_vma(mm, addr);
-		unsigned int follflags;
 		struct page *page;
 
 		if (!vma || addr < vma->vm_start)
@@ -2966,8 +2965,7 @@ static int split_huge_pages_pid(int pid,
 		}
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		follflags = FOLL_GET | FOLL_DUMP;
-		page = follow_page(vma, addr, follflags);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 		if (IS_ERR(page))
 			continue;
--- a/mm/migrate.c~mm-remove-unneeded-local-variable-follflags-v2
+++ a/mm/migrate.c
@@ -1611,7 +1611,6 @@ static int add_page_for_migration(struct
 {
 	struct vm_area_struct *vma;
 	struct page *page;
-	unsigned int follflags;
 	int err;
 
 	mmap_read_lock(mm);
@@ -1621,8 +1620,7 @@ static int add_page_for_migration(struct
 		goto out;
 
 	/* FOLL_DUMP to ignore special (like zero) pages */
-	follflags = FOLL_GET | FOLL_DUMP;
-	page = follow_page(vma, addr, follflags);
+	page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 	err = PTR_ERR(page);
 	if (IS_ERR(page))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

