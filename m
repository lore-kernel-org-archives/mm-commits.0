Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97546C3525A
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 02:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbiAZC2O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:28:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55890 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiAZC2O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 21:28:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B11B6616B3
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 02:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D2C340E0;
        Wed, 26 Jan 2022 02:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643164093;
        bh=oHXKNjs3uKRmo4FvT8nWyE433IZHWpubxAJL0mih4sY=;
        h=Date:From:To:Subject:From;
        b=zJD6DcAIbtw1JlrL+ac369JzOPNgbZNDlAwYd3nazPtPcuBIewNrPQLwCXGwceFcf
         Q+AVmfDnssloMCUfbImzcMtXSHh1YMO++KAFDrJaZ3sRqlgLqiEdDA6NSR0x4kEIlM
         +WP7qZco1MXDLPI60ePij2oshEMOVr6Y7ZsXttCI=
Date:   Tue, 25 Jan 2022 18:28:12 -0800
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, dingtianhong@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, urezki@gmail.com,
        will@kernel.org, willy@infradead.org, yury.norov@gmail.com
Subject:  + vmap-dont-allow-invalid-pages.patch added to -mm tree
Message-ID: <20220126022812.awqjeyhDF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: vmap(): don't allow invalid pages
has been added to the -mm tree.  Its filename is
     vmap-dont-allow-invalid-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmap-dont-allow-invalid-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmap-dont-allow-invalid-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: mm/vmalloc.c: vmap(): don't allow invalid pages

vmap() takes struct page *pages as one of arguments, and user may provide
an invalid pointer which would lead to data abort at address translation
later.

Currently, kernel checks the pages against NULL.  In my case, however, the
address was not NULL, and was big enough so that the hardware generated
Address Size Abort on arm64.

Interestingly, this abort happens even if copy_from_kernel_nofault() is
used, which is quite inconvenient for debugging purposes.

This patch adds a pfn_valid() check into vmap() path, so that invalid
mapping will not be created.

Link: https://lkml.kernel.org/r/20220119012109.551931-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c~vmap-dont-allow-invalid-pages
+++ a/mm/vmalloc.c
@@ -479,6 +479,8 @@ static int vmap_pages_pte_range(pmd_t *p
 			return -EBUSY;
 		if (WARN_ON(!page))
 			return -ENOMEM;
+		if (WARN_ON(!pfn_valid(page_to_pfn(page))))
+			return -EINVAL;
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
_

Patches currently in -mm which might be from yury.norov@gmail.com are

vmap-dont-allow-invalid-pages.patch

