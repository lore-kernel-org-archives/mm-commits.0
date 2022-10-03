Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7B7C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJCVIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJCVGW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C75A4D248
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF553610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424FFC433D6;
        Mon,  3 Oct 2022 21:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831140;
        bh=iNfiQmWCIH3FdX3CyQS0yqG5QWJLoA8HVmc5fQwftww=;
        h=Date:To:From:Subject:From;
        b=eIT5ju1oRfSNtnepON7l3uC8nn8q+MHCXjdOKX3WXPmXA1xmf6D6wDl59mrQ7CTQU
         86VDREhjVW+zDIMzugClVwpyhU5hCfX/Ogq6TvTkSQbfwb3uiGe+eBI2aun3eMJETN
         ndPvdP8TwV2MhJUXEzaZfmIr2CDDS9Zx9d+3E1mY=
Date:   Mon, 03 Oct 2022 14:05:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] uprobes-use-new_folio-in-__replace_page.patch removed from -mm tree
Message-Id: <20221003210540.424FFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: uprobes: use new_folio in __replace_page()
has been removed from the -mm tree.  Its filename was
     uprobes-use-new_folio-in-__replace_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: uprobes: use new_folio in __replace_page()
Date: Fri, 2 Sep 2022 20:46:52 +0100

Saves several calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-57-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-use-new_folio-in-__replace_page
+++ a/kernel/events/uprobes.c
@@ -155,6 +155,7 @@ static int __replace_page(struct vm_area
 				struct page *old_page, struct page *new_page)
 {
 	struct folio *old_folio = page_folio(old_page);
+	struct folio *new_folio;
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, old_folio, vma, addr, 0);
 	int err;
@@ -164,8 +165,8 @@ static int __replace_page(struct vm_area
 				addr + PAGE_SIZE);
 
 	if (new_page) {
-		err = mem_cgroup_charge(page_folio(new_page), vma->vm_mm,
-					GFP_KERNEL);
+		new_folio = page_folio(new_page);
+		err = mem_cgroup_charge(new_folio, vma->vm_mm, GFP_KERNEL);
 		if (err)
 			return err;
 	}
@@ -180,9 +181,9 @@ static int __replace_page(struct vm_area
 	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
 
 	if (new_page) {
-		get_page(new_page);
+		folio_get(new_folio);
 		page_add_new_anon_rmap(new_page, vma, addr);
-		lru_cache_add_inactive_or_unevictable(new_page, vma);
+		folio_add_lru_vma(new_folio, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
 		dec_mm_counter(mm, MM_ANONPAGES);
_

Patches currently in -mm which might be from willy@infradead.org are


