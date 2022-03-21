Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1F1C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Mar 2022 21:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiCUVRo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Mar 2022 17:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiCUVRo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2022 17:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4600D2A5A87
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 14:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8028261225
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 21:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59E9C340E8;
        Mon, 21 Mar 2022 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647897371;
        bh=MpwDPc6DBVOwzgAwm6dRhj2c5sFuvNRWfx290X1kLxI=;
        h=Date:To:From:Subject:From;
        b=Bkx6axEQVEJrcxjRWYIEynLQABjjeGXSnR+PThcD5gCpgTptPH1RqiprHsi01uDD5
         ep1T9tM9Wl1ainFDkhqij78jMdSo2yf3h1QjT8aB4iFaRxN1g4ojyWz0l7vlsU8Auc
         ao4+zIzOk6HK9XUJjW7PtwEn3wjU+mhCAiUostqk=
Date:   Mon, 21 Mar 2022 14:16:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        urezki@gmail.com, npiggin@gmail.com, dingtianhong@huawei.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        aklimov@redhat.com, yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] vmap-dont-allow-invalid-pages.patch removed from -mm tree
Message-Id: <20220321211611.C59E9C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: vmap(): don't allow invalid pages
has been removed from the -mm tree.  Its filename was
     vmap-dont-allow-invalid-pages.patch

This patch was dropped because an updated version will be merged

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
@@ -478,6 +478,8 @@ static int vmap_pages_pte_range(pmd_t *p
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


