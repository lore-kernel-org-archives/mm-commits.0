Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69817C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BD5610CE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347635AbhIBVzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347861AbhIBVzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CBEA610A1;
        Thu,  2 Sep 2021 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619647;
        bh=MRgfTOnKe1iM+kzmxuqh6K/si61oIg6yCBTzNjSF/Sg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1Z1V6X8knUkxSeyR87KKLXw5+amvOM9QT2OmGP+6+FlAxxNXJ2nFhgUTg3y36o99t
         zoIABToTD+etJwvfBSgGKxPYlJr3LRSStMkMQeWKFSzLRsZAop8OtZ9G5mcd8aIyy1
         3xRVwqKYZvPCSJonTy6JkgNG1ZYQRB2Hdf856eC4=
Date:   Thu, 02 Sep 2021 14:54:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 079/212] shmem: remove unneeded variable ret
Message-ID: <20210902215406.k7Ga9eGxC%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: remove unneeded variable ret

Patch series "Cleanups for shmem".

This series contains cleanups to remove unneeded variable, header file,
function forward declaration and so on.  More details can be found in the
respective changelogs.


This patch (of 4):

The local variable ret is always equal to -ENOMEM and never touched.  So
remove it and return -ENOMEM directly to simplify the code.

Link: https://lkml.kernel.org/r/20210812120350.49801-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210812120350.49801-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-remove-unneeded-variable-ret
+++ a/mm/shmem.c
@@ -3616,7 +3616,6 @@ static int shmem_fill_super(struct super
 	struct shmem_options *ctx = fc->fs_private;
 	struct inode *inode;
 	struct shmem_sb_info *sbinfo;
-	int err = -ENOMEM;
 
 	/* Round up to L1_CACHE_BYTES to resist false sharing */
 	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
@@ -3694,7 +3693,7 @@ static int shmem_fill_super(struct super
 
 failed:
 	shmem_put_super(sb);
-	return err;
+	return -ENOMEM;
 }
 
 static int shmem_get_tree(struct fs_context *fc)
_
