Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FD2C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD1A61165
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347322AbhIHDB5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347390AbhIHDBk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34ACB61100;
        Wed,  8 Sep 2021 03:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070033;
        bh=k0D6Llvti4CGdvXoX7LC2nA6KQX7y4PlB2tB4YaUi9k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WXm+79qaWjhZZKJBhzkXYxsrlAJv9T52lKscVhqgkhsZtcMDfLkH329NHRbfo7rb1
         FoUah9iBw2baCiej7Ro8fty9ecx/N1R+RANxhd7dgTotvEK8sUA2Xe3yRxm3az4FLm
         rls5Z/aHiNURNxlp1V/71PzMOw5pjzGP3sLd4oow=
Date:   Tue, 07 Sep 2021 20:00:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        qiuxi1@huawei.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 138/147] coredump: fix memleak in
 dump_vma_snapshot()
Message-ID: <20210908030032.ciB5RdV6g%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
