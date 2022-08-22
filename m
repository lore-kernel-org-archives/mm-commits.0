Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885E7C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 21:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiHVVD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiHVVDz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 17:03:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E16F3DBEF
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 14:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB362CE1751
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 21:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B777FC433D6;
        Mon, 22 Aug 2022 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661202229;
        bh=Qpq3HzzE5F/EHCgG7k9XdXohInPKPLeMQ/RQFLdvWv4=;
        h=Date:To:From:Subject:From;
        b=W58hXj6g61Wk1vUbI6bzOuv18a6Jv+RJ5kOjUZScp5B8/5+ZnUSJ5+0OBk1rzq6FD
         aMGEb0tfpMqQe2Uv5Oq7CZOLtTi3rbRnHIVMevD87wiEhpQnWCj8e4dqB5gUC4q0T/
         LaQvEyb84q2VqvW8q1KWjvqv/5Tseq1Pl7T4rZIY=
Date:   Mon, 22 Aug 2022 14:03:49 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch added to mm-unstable branch
Message-Id: <20220822210349.B777FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unused local variable dst_entry in copy_hugetlb_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch

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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm/hugetlb: remove unused local variable dst_entry in copy_hugetlb_page_range()
Date: Mon, 22 Aug 2022 10:25:25 +0200

Commit a0e4f7b82610 ("mm/hugetlb: make detecting shared pte more
reliable") modifies copy_hugetlb_page_range() such that
huge_ptep_get(dst_pte) and the local variable dst_entry is not used
explicitly in this function.

Remove this unused local variable dst_entry in copy_hugetlb_page_range().
No functional change.

Link: https://lkml.kernel.org/r/20220822082525.26071-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-make-detecting-shared-pte-more-reliable-fix
+++ a/mm/hugetlb.c
@@ -4750,7 +4750,7 @@ int copy_hugetlb_page_range(struct mm_st
 			    struct vm_area_struct *dst_vma,
 			    struct vm_area_struct *src_vma)
 {
-	pte_t *src_pte, *dst_pte, entry, dst_entry;
+	pte_t *src_pte, *dst_pte, entry;
 	struct page *ptepage;
 	unsigned long addr;
 	bool cow = is_cow_mapping(src_vma->vm_flags);
@@ -4810,7 +4810,6 @@ int copy_hugetlb_page_range(struct mm_st
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		entry = huge_ptep_get(src_pte);
-		dst_entry = huge_ptep_get(dst_pte);
 again:
 		if (huge_pte_none(entry)) {
 			/*
@@ -4893,7 +4892,7 @@ again:
 					restore_reserve_on_error(h, dst_vma, addr,
 								new);
 					put_page(new);
-					/* dst_entry won't change as in child */
+					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
 				hugetlb_install_page(dst_vma, dst_pte, addr, new);
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch

