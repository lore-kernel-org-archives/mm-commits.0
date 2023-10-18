Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E4FCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 23:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjJRXkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 19:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjJRXkH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 19:40:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A68120
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 16:40:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DDFC433C7;
        Wed, 18 Oct 2023 23:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697672403;
        bh=/laJBakJdwgo1R3FygaJq9Xw2hIMmCqBBnsMees+zHI=;
        h=Date:To:From:Subject:From;
        b=Pjq6rspNGS8yjZg0p+0X8gO7XF5x+8ZTIbtFVXLQ09yR36IcRdmeZhue8454BCpRk
         A9BYDnljPtAUeH9F5iwrzGzo3/ok6x4K4bYqxpiprsh1uHWl4U8OlAMNWCkam6oLeG
         AuF1SoTfWfA4GwuEQ2Xzp7c+FvNFKdmHBzvZhNDs=
Date:   Wed, 18 Oct 2023 16:40:03 -0700
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix.patch added to mm-unstable branch
Message-Id: <20231018234003.A7DDFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: collapse_pte_mapped_thp() folio conversion fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: collapse_pte_mapped_thp() folio conversion fix
Date: Wed, 18 Oct 2023 14:24:47 -0700

filemap_lock_folio() can return an ERR_PTR on failure.
find_lock_page()/pagecache_get_page() handles this internally, while
filemap_lock_folio() does not. Ensure this is checked for in the caller
after converting find_lock_page() to filemap_lock_folio().

Link: https://lkml.kernel.org/r/ZTBjv4jyQ5/zu5cw@fedora
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reported-by: syzbot+1e2648076cadf48ad9a1@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/ZTBjv4jyQ5/zu5cw@fedora
Tested-by: syzbot+1e2648076cadf48ad9a1@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix
+++ a/mm/khugepaged.c
@@ -1506,7 +1506,7 @@ int collapse_pte_mapped_thp(struct mm_st
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
-	if (!folio)
+	if (!folio || IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
 	if (folio_order(folio) != HPAGE_PMD_ORDER) {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch
mm-khugepaged-convert-hpage_collapse_scan_pmd-to-use-folios.patch
mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch
mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios-fix.patch

