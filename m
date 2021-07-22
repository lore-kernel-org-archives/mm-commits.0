Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A6CC07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 04:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A017160C3D
	for <mm-commits@archiver.kernel.org>; Thu, 22 Jul 2021 04:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGVDr2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 23:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhGVDr1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 23:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 308DC61222;
        Thu, 22 Jul 2021 04:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626928082;
        bh=V9At4SJnZ7usl8qb6jnIR89wJhWD7u/4k3jJvLZm2Jw=;
        h=Date:From:To:Subject:From;
        b=uLRM5nUJB+NT2zIRU5AB56I0LXqY+8AFFCCrU3fwn5PO24rldqdfWbX7XT1FRqC3f
         aEinwro/h6iVZN3sgavThLG6Z5IjKJ71OGFCc+8DdtuOcbQi64yRzTRTYkrOqGJrS4
         xvbYNbururoGI/Hm+UecwsJnNI6q7TTCK1GJsaR4=
Date:   Wed, 21 Jul 2021 21:28:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, weiyongjun1@huawei.com,
        wangkefeng.wang@huawei.com, dima@arista.com, chenwandun@huawei.com
Subject:  + mm-mremap-fix-memory-account-on-do_munmap-failure.patch
 added to -mm tree
Message-ID: <20210722042801.K0a0v%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix memory account on do_munmap() failure
has been added to the -mm tree.  Its filename is
     mm-mremap-fix-memory-account-on-do_munmap-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-fix-memory-account-on-do_munmap-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-fix-memory-account-on-do_munmap-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Acked-by: Dmitry Safonov <dima@arista.com>
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

mm-mremap-fix-memory-account-on-do_munmap-failure.patch
mm-vmalloc-fix-wrong-behavior-in-vread.patch

