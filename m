Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD41C43219
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7F8611EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348026AbhIIVGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232891AbhIIVG3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BCFF611C4;
        Thu,  9 Sep 2021 21:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221519;
        bh=RYtG5j1/39b42veNYyCSl5WBgYF2LVYowO9o6Orz/NE=;
        h=Date:From:To:Subject:From;
        b=PLTC8C5jv/i2UNLD3C4u6hJ0bUGDa0H483v0J6O+0556foxkH4jccAgwVe5vBLUv2
         X5ZVsjLFEPjl9sdU5rOrqZ6ZO4Ktr1eVdVyQxfjoJJHLEMUqHLuFdkfbVfF4Mvd1wF
         pFOExEfYeOY9qHNvWSM9e1Xxwp4JiSE2vPWN0VbQ=
Date:   Thu, 09 Sep 2021 14:05:19 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jannh@google.com,
        mm-commits@vger.kernel.org, qiuxi1@huawei.com,
        viro@zeniv.linux.org.uk
Subject:  [merged] coredump-fix-memleak-in-dump_vma_snapshot.patch
 removed from -mm tree
Message-ID: <20210909210519.-v4dDKYRs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix memleak in dump_vma_snapshot()
has been removed from the -mm tree.  Its filename was
     coredump-fix-memleak-in-dump_vma_snapshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: QiuXi <qiuxi1@huawei.com>
Subject: coredump: fix memleak in dump_vma_snapshot()

dump_vma_snapshot() allocs memory for *vma_meta, when dump_vma_snapshot()
returns -EFAULT, the memory will be leaked, so we free it correctly.

Link: https://lkml.kernel.org/r/20210810020441.62806-1-qiuxi1@huawei.com
Fixes: a07279c9a8cd7 ("binfmt_elf, binfmt_elf_fdpic: use a VMA list snapshot")
Signed-off-by: QiuXi <qiuxi1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/coredump.c~coredump-fix-memleak-in-dump_vma_snapshot
+++ a/fs/coredump.c
@@ -1134,8 +1134,10 @@ int dump_vma_snapshot(struct coredump_pa
 
 	mmap_write_unlock(mm);
 
-	if (WARN_ON(i != *vma_count))
+	if (WARN_ON(i != *vma_count)) {
+		kvfree(*vma_meta);
 		return -EFAULT;
+	}
 
 	*vma_data_size_ptr = vma_data_size;
 	return 0;
_

Patches currently in -mm which might be from qiuxi1@huawei.com are


