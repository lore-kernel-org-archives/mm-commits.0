Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461F5C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3385A610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347873AbhIBVzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347634AbhIBVzO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DCB610D2;
        Thu,  2 Sep 2021 21:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619655;
        bh=ruAREF9T8cIVcYOm7E4vitlBycpDBQe3B/hTSicIUjs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XiqYn4UmjYksFgexCYVraGBxnZwWjbD0eoFgV3lIvliV92sP06A61+/wU7g2og7xD
         zE+vzIhXWemBsqqvjaQwAUw7iGgE8YMxXugvv4kr6fxHwDUDCAYndHEGw5ymZjtnIA
         UyYNTuhshH2TBfASAijxPoaFjHGeLuR24biztr+k=
Date:   Thu, 02 Sep 2021 14:54:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 082/212] shmem: include header file to declare
 swap_info
Message-ID: <20210902215415.PSm8ek2oy%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: shmem: include header file to declare swap_info

It's bad to extern swap_info[] in .c.  Include corresponding header file
instead.

Link: https://lkml.kernel.org/r/20210812120350.49801-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-include-header-file-to-declare-swap_info
+++ a/mm/shmem.c
@@ -38,6 +38,7 @@
 #include <linux/hugetlb.h>
 #include <linux/frontswap.h>
 #include <linux/fs_parser.h>
+#include <linux/swapfile.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -1152,8 +1153,6 @@ static void shmem_evict_inode(struct ino
 	clear_inode(inode);
 }
 
-extern struct swap_info_struct *swap_info[];
-
 static int shmem_find_swap_entries(struct address_space *mapping,
 				   pgoff_t start, unsigned int nr_entries,
 				   struct page **entries, pgoff_t *indices,
_
