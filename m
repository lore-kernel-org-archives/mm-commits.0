Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7960BC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4313560F38
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhHKE2o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Aug 2021 00:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhHKE2o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Aug 2021 00:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8ED60F22;
        Wed, 11 Aug 2021 04:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628656100;
        bh=Sg+UQEQQ3wB/YCvUP56dqkHMkHmTcllHuVPKlLlRbLk=;
        h=Date:From:To:Subject:From;
        b=DC4+myqbHOaUuQBzrA593eta7PkkP1QpetKPnLN9XBAEZ1RTw/VkeL/cFQpoAq4Wr
         sc5TV2w/RdUVAVtuxxuPfukBKYrYtxTmTu/OZBXAiE8Fkh1MrSItDHSrtKNwnXsOMH
         +l/Z+O7/Z801LJQnnTpLQcOJU5j2Ix1uZY2HS7vI=
Date:   Tue, 10 Aug 2021 21:28:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jannh@google.com, gregkh@linuxfoundation.org, qiuxi1@huawei.com
Subject:  + coredump-fix-memleak-in-dump_vma_snapshot.patch added to
 -mm tree
Message-ID: <20210811042818.Gqfyn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix memleak in dump_vma_snapshot()
has been added to the -mm tree.  Its filename is
     coredump-fix-memleak-in-dump_vma_snapshot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coredump-fix-memleak-in-dump_vma_snapshot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coredump-fix-memleak-in-dump_vma_snapshot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

coredump-fix-memleak-in-dump_vma_snapshot.patch

