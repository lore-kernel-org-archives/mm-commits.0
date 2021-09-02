Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE72C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8640610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347872AbhIBVzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347864AbhIBVzI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDB08610CF;
        Thu,  2 Sep 2021 21:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619650;
        bh=/MQ8C4QQS2r4dgkv3/zwphGk3GZGrnF5mbY7ROdGfhk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OfVYfZtFSHhWn+V+k2aBy7oCUlsjLqrW8xdwdXQB+XL1YyL4jgne4A2ln/ZmG4dyN
         6e/vc+EDBPEZTTdezkqSXvYEH9lL9CleL9O/CP05LdFYQQznaPeHYiuXagrKdpnkLb
         cTzQ99CF+cPavnWEPS+dSabjdQB0+UUCx6TlN9bc=
Date:   Thu, 02 Sep 2021 14:54:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 080/212] shmem: remove unneeded header file
Message-ID: <20210902215409.4UIF-GpVl%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: remove unneeded header file

mfill_atomic_install_pte() is introduced to install pte and update mmu
cache since commit bf6ebd97aba0 ("userfaultfd/shmem: modify
shmem_mfill_atomic_pte to use install_pte()").  So we should remove
tlbflush.h as update_mmu_cache() is not called here now.

Link: https://lkml.kernel.org/r/20210812120350.49801-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~shmem-remove-unneeded-header-file
+++ a/mm/shmem.c
@@ -39,8 +39,6 @@
 #include <linux/frontswap.h>
 #include <linux/fs_parser.h>
 
-#include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
-
 static struct vfsmount *shm_mnt;
 
 #ifdef CONFIG_SHMEM
_
