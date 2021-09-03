Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132B0C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F327E6112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhICU7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233315AbhICU7l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FEB8610FB;
        Fri,  3 Sep 2021 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702721;
        bh=Rc7Z4w/z4JCgEjw4rDEHF6E4j9XPAMPUjiQj3FFuKWo=;
        h=Date:From:To:Subject:From;
        b=V9WFWtsxg79Ob/VTgQ+yxnpKunMTju9LR672Dr63X84YXl3x8p3usg07QzMIPRW86
         D7SwlUy1KlwQf774K8t8PVEVIy/uIwqXHFflHidTBlZy9mpSZ6uQ23lWQ8gwi8BhrT
         K6n2iqzJncP9d4eeEdCSBXFqHfIO1AEF6WetFOjc=
Date:   Fri, 03 Sep 2021 13:58:41 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, dima@arista.com, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com, weiyongjun1@huawei.com
Subject:  [merged]
 mm-mremap-fix-memory-account-on-do_munmap-failure.patch removed from -mm
 tree
Message-ID: <20210903205841.qjQz5qF-O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix memory account on do_munmap() failure
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-memory-account-on-do_munmap-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


