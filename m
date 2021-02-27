Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E873DC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C260364F2A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhB0CaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhB0CaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFD864F2B;
        Sat, 27 Feb 2021 02:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392988;
        bh=HytMLihCErJuLFYOBcMrcPQmRjoY2xUb7NRaWiuyWJQ=;
        h=Date:From:To:Subject:From;
        b=QKlv5Q/fZC4eqF0ldNYGywTiP2kkWvVcylSTpyhAGXyQi5THtERpJTdg9ESIWwp9m
         PrIFLHSZeU7ZgZgfERQNZ8XOvqtxShk7wx6pdOK+dgYKKu1ekxMMqhbdRVCyKBjIKi
         mIdw3C5nY4EEWgH+uGrnMsfCwgWKcp4prGfD53cE=
Date:   Fri, 26 Feb 2021 18:29:48 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch removed
 from -mm tree
Message-ID: <20210227022948.X_0ggKEfR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: stop counting mlocked pages when none vma is found
has been removed from the -mm tree.  Its filename was
     mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mlock: stop counting mlocked pages when none vma is found

There will be no vma satisfies addr < vm_end when find_vma() returns NULL.
Thus it's meaningless to traverse the vma list below because we can't
find any vma to count mlocked pages.  Stop counting mlocked pages in this
case to save some vma list traversal cycles.

Link: https://lkml.kernel.org/r/20210204110705.17586-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found
+++ a/mm/mlock.c
@@ -622,7 +622,7 @@ static unsigned long count_mm_mlocked_pa
 
 	vma = find_vma(mm, start);
 	if (vma == NULL)
-		vma = mm->mmap;
+		return 0;
 
 	for (; vma ; vma = vma->vm_next) {
 		if (start >= vma->vm_end)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


