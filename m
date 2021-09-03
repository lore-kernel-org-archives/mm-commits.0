Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6DCC43217
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A83F60E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350253AbhICU5y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350304AbhICU5v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82989601FD;
        Fri,  3 Sep 2021 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702610;
        bh=VkQuieZoY5e8bNKoCZU+DDwT9b3KK7Vnuzc8ilBz/bU=;
        h=Date:From:To:Subject:From;
        b=Q0yj38GFRa503HNISorAi5fze2n9VCyqV1XheCpS+dTbDCFGd2mJSeLdV5yeTmziE
         JFGdKjZac+L7a94d59uSrD/PtySnKtdjw5+81QnZEvdi047Jm4e070i7Dl0mslAhi+
         UbRdDs/tt5ivrc7bUARH3OtHW+ERpnVNBxwd5z9I=
Date:   Fri, 03 Sep 2021 13:56:50 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 shmem-include-header-file-to-declare-swap_info.patch removed from -mm tree
Message-ID: <20210903205650.4HYQzrZoS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: include header file to declare swap_info
has been removed from the -mm tree.  Its filename was
     shmem-include-header-file-to-declare-swap_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

