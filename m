Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00706ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiJ0UGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiJ0UGq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:06:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F4336DEC
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F95624C9
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66340C433C1;
        Thu, 27 Oct 2022 20:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901204;
        bh=FUElC1auLd/4vwMrCyqQvAmvtlQh2J0EgQvWPsUfWbg=;
        h=Date:To:From:Subject:From;
        b=IuppISr6v3+E2CLxvCRQ5BbMF3WTXxMRq5Z6J9kP72jcqirTOQ+0Hx3Djn8R+jn6a
         Mb5uqGWWGhI7ZC7hKMnTJT+tqqF22fyMmJxWNXc17g2OxP61o7mBy1l56y3REnr2x7
         uLQ4dOWbnuCB8U4LU7sKsRm87TILtl0tl7CWyEj8=
Date:   Thu, 27 Oct 2022 13:06:43 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-redundant-list_del.patch added to mm-unstable branch
Message-Id: <20221027200644.66340C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: remove redundant list_del()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remove-redundant-list_del.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-redundant-list_del.patch

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
Subject: mm: hugetlb_vmemmap: remove redundant list_del()
Date: Thu, 27 Oct 2022 11:36:41 +0800

The ->lru field will be assigned to a new value in __free_page().  So it
is unnecessary to delete it from the @list.  Just remove it to simplify
the code.

Link: https://lkml.kernel.org/r/20221027033641.66709-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-redundant-list_del
+++ a/mm/hugetlb_vmemmap.c
@@ -231,10 +231,8 @@ static void free_vmemmap_page_list(struc
 {
 	struct page *page, *next;
 
-	list_for_each_entry_safe(page, next, list, lru) {
-		list_del(&page->lru);
+	list_for_each_entry_safe(page, next, list, lru)
 		free_vmemmap_page(page);
-	}
 }
 
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-remove-redundant-list_del.patch

