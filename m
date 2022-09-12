Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AAAECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiILDcT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiILDa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9264B6244
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE01B80C6D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2831C433B5;
        Mon, 12 Sep 2022 03:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953370;
        bh=uQY83n7157iXooGrVOp5C5R3WZVFk/x6ln/Nvn7eJRE=;
        h=Date:To:From:Subject:From;
        b=poy6Pl5yBUQXdNJzVrcovhs6csSgqu8I/3bIhBGZbFPtGFHv6/+z6XeK04Kl4Iqt2
         W8h4luDHAbbChPLAT/uErU3+jMenAxtFP/eAUldcypWTrpuRvQ7I9gcvRxvXHicbMy
         iKZxXdRMLqTakaOm0T3onJ6BTLk6xIm49a174U3Y=
Date:   Sun, 11 Sep 2022 20:29:30 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch removed from -mm tree
Message-Id: <20220912032930.C2831C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: simplify reset_struct_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: simplify reset_struct_pages()
Date: Fri, 19 Aug 2022 11:55:32 +0800

We can choose to copy three contiguous tail pages' content to the first
three pages instead of copying one by one to simplify the code and reduce
code size from 229 bytes to 63 bytes.  The BUILD_BUG_ON() aims to avoid
out-of-bounds accesses.

Link: https://lkml.kernel.org/r/20220819035532.6189-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-simplify-reset_struct_pages
+++ a/mm/hugetlb_vmemmap.c
@@ -265,11 +265,10 @@ static void vmemmap_remap_pte(pte_t *pte
 
 static inline void reset_struct_pages(struct page *start)
 {
-	int i;
 	struct page *from = start + NR_RESET_STRUCT_PAGE;
 
-	for (i = 0; i < NR_RESET_STRUCT_PAGE; i++)
-		memcpy(start + i, from, sizeof(*from));
+	BUILD_BUG_ON(NR_RESET_STRUCT_PAGE * 2 > PAGE_SIZE / sizeof(struct page));
+	memcpy(start, from, sizeof(*from) * NR_RESET_STRUCT_PAGE);
 }
 
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-eliminate-memory-less-nodes-handling.patch

