Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11814C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiHSFCU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiHSFCT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D3DC9EBB
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519EC6153F
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C2C433D6;
        Fri, 19 Aug 2022 05:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660885337;
        bh=FuGC7Eze7ysKlE3rjj53BRAqVvx3yeiqo1Kc2rvpwqU=;
        h=Date:To:From:Subject:From;
        b=vNlqv82sd1hQLj2r093sk0R5V8chtf7m3luX+IWlMqWvWpdREFKZj7TTDKn8XXwn0
         tipECQDq8z14nkLqMG0l7ymO/i5foVucO/CQYg6CSGKOmrdSdz5lqvi7P1Oi7+TKmu
         o+CEA5v2UwfhGgVfj0LNU+AsNtVBco+v+j9JzLzs=
Date:   Thu, 18 Aug 2022 22:02:16 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch added to mm-unstable branch
Message-Id: <20220819050217.9E6C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: simplify reset_struct_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb_vmemmap-simplify-reset_struct_pages.patch

