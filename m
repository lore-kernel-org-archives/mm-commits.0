Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846FDC6377B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6956121F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhGUTXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 15:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhGUTXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 15:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EC306120D;
        Wed, 21 Jul 2021 20:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626897825;
        bh=QXDxAlywQUveIofYObwZs4hKoebVuGFyu4DYG1AMCaY=;
        h=Date:From:To:Subject:From;
        b=e0ACm2EdawZD/Q84hBnQZrjGPxtaAJJpCr+haPIBYt7GV5xF8OsBeA93jD6LqK8ci
         ci28lm4nk2tpd22gfBRW/Gqmtg1vyCV2ipOx2LYepHNdbBSmxZKln0ilrnOPvdlQl+
         V+N/++ri9sPpHB1B0sm5tYUva3qlJO8W8/ES+DtU=
Date:   Wed, 21 Jul 2021 13:03:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, weiyongjun1@huawei.com,
        wangkefeng.wang@huawei.com, 0x7f454c46@gmail.com,
        chenwandun@huawei.com
Subject:  [alternative-merged]
 mm-mremap-fix-memory-account-on-do_munmap-failure.patch removed from -mm tree
Message-ID: <20210721200344.Pn2pO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix memory account on do_munmap() failure
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-memory-account-on-do_munmap-failure.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/mremap: fix memory account on do_munmap() failure

mremap will account the delta between new_len and old_len in
vma_to_resize, and then call move_vma when expanding an existing memory
mapping.  In function move_vma, there are two scenarios when calling
do_munmap:

1. move_page_tables from old_addr to new_addr success
2. move_page_tables from old_addr to new_addr fail

In first scenario, it should account old_len if do_munmap fail, because
the delta has already been accounted.

In second scenario, new_addr/new_len will assign to old_addr/old_len if
move_page_table fail, so do_munmap is try to unmap new_addr actually, if
do_munmap fail, it should account the new_len, because error code will be
return from move_vma, and delta will be unaccounted.  What'more, because
of new_len == old_len, so account old_len also is OK.

In summary, account old_len will be correct if do_munmap fail.

Link: https://lkml.kernel.org/r/20210717101942.120607-1-chenwandun@huawei.com
Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-memory-account-on-do_munmap-failure
+++ a/mm/mremap.c
@@ -686,7 +686,7 @@ static unsigned long move_vma(struct vm_
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
-			vm_acct_memory(new_len >> PAGE_SHIFT);
+			vm_acct_memory(old_len >> PAGE_SHIFT);
 		excess = 0;
 	}
 
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-vmalloc-fix-wrong-behavior-in-vread.patch

