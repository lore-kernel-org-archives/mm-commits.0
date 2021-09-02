Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D53C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C29B610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbhIBVzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347873AbhIBVzL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE57F610A2;
        Thu,  2 Sep 2021 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619653;
        bh=nDszfdZqRik/105UzHA3/WN0RkvdX966+iw/nlkM810=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zo3bOz9mVMKpj56O25yvqw+6ab3Pb3Kee0VeiytKbyGqkOAL/u/0wVRL3fUwdskoZ
         gi/f8yaw14SoPAVsi7Gdz/+030iqijZntZgVAriOyJqbOsMs5X0N6WakXFu7ZEuy1Q
         V24WjBAjRoNxoS+5B55r+/AUmkjojXbI0HY+XMgs=
Date:   Thu, 02 Sep 2021 14:54:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 081/212] shmem: remove unneeded function forward
 declaration
Message-ID: <20210902215412.EATI8TEIM%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: remove unneeded function forward declaration

The forward declaration for shmem_should_replace_page() and
shmem_replace_page() is unnecessary.  Remove them.

Link: https://lkml.kernel.org/r/20210812120350.49801-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/shmem.c~shmem-remove-unneeded-function-forward-declaration
+++ a/mm/shmem.c
@@ -135,9 +135,6 @@ static unsigned long shmem_default_max_i
 }
 #endif
 
-static bool shmem_should_replace_page(struct page *page, gfp_t gfp);
-static int shmem_replace_page(struct page **pagep, gfp_t gfp,
-				struct shmem_inode_info *info, pgoff_t index);
 static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 			     struct page **pagep, enum sgp_type sgp,
 			     gfp_t gfp, struct vm_area_struct *vma,
_
