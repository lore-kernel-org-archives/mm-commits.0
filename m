Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFBEECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiILAjk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILAjk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50E163A2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 510D76114D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B11C433C1;
        Mon, 12 Sep 2022 00:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943177;
        bh=4lGiiDoJUm4mTKx8/po6ABK7aZPEt9ZHV1Pngx7dWbs=;
        h=Date:To:From:Subject:From;
        b=o6UqNdxmd2wNoJDx8FbT+nsOJjqo5Q1FelvVKeEEkbDWf5MD7ILYZ9CLI+lcZ6cHf
         drYY9Gbdf2jlr3GFdHg4gCyDx+I6qr/wROc5S5EnEqukdBz9IhzNmWQRbRhmfJ7NsT
         HFIhUBCh0EJnjeHeVxqYoOBAXwmx2UKoknC0C/oU=
Date:   Sun, 11 Sep 2022 17:39:36 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch removed from -mm tree
Message-Id: <20220912003937.A6B11C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: remove unused local variable dst_entry in copy_hugetlb_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-detecting-shared-pte-more-reliable-fix.patch

This patch was dropped because it was folded into mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

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

mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
proc-make-config-proc_children-depend-on-proc_fs.patch

