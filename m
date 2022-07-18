Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF932C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 22:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiGRWtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Jul 2022 18:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiGRWtX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2022 18:49:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932101FCE6
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 15:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07FC9CE179B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 22:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265FCC341C0;
        Mon, 18 Jul 2022 22:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658184559;
        bh=ShFUwQnUC4aGweQHo7kS1HMyOUSKEeGsZVk8oeSnsiM=;
        h=Date:To:From:Subject:From;
        b=FbMD5ZAwdko2McFongvdiw/U9u9Nwn1gEXyNivyv9P/4IYeHKyV1MMzc6yuHvQyGT
         5W4uva8eOoeWWgIox5oh4AFbLrOy47ovFRBjGb5R20OB6pAI/AD7P4skLD3QsD7AEp
         5e4CfxgK06YRx2+dUzZUxNJvMiSh0z87lRp4pnB8=
Date:   Mon, 18 Jul 2022 15:49:18 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch added to mm-unstable branch
Message-Id: <20220718224919.265FCC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unneeded PageAnon check in restore_exclusive_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove unneeded PageAnon check in restore_exclusive_pte()
Date: Sat, 16 Jul 2022 16:18:16 +0800

When code reaches here, the page must be !PageAnon.  There's no need to
check PageAnon again.  Remove it.

Link: https://lkml.kernel.org/r/20220716081816.10752-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte
+++ a/mm/memory.c
@@ -753,7 +753,7 @@ static void restore_exclusive_pte(struct
 		 * Currently device exclusive access only supports anonymous
 		 * memory so the entry shouldn't point to a filebacked page.
 		 */
-		WARN_ON_ONCE(!PageAnon(page));
+		WARN_ON_ONCE(1);
 
 	set_pte_at(vma->vm_mm, address, ptep, pte);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch
mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch

