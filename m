Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404BFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A2660E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhICU5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350231AbhICU5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2C0610E8;
        Fri,  3 Sep 2021 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702608;
        bh=BLsjoWqPmj/DCEaWB5UHg2DRFXOa9ehn6w47WPMcR3k=;
        h=Date:From:To:Subject:From;
        b=kwKB4G8Fv67ZTRnN47jKa8RVUHIptTzT6b4GTRJ3jYe0jUF1nFyDRZWd0Ye9lcnde
         3cUGI4kYc+cHdbzG96DT00+LkTd1t2V170CSNHTh6pT2wklayY6xevdHxWHAUiwuxo
         hl09Ya+sKKImDdJ9iIpa67XFI9C/ALGbOXBMsPiw=
Date:   Fri, 03 Sep 2021 13:56:48 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 shmem-remove-unneeded-function-forward-declaration.patch removed from -mm
 tree
Message-ID: <20210903205648.gLmWwqq04%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove unneeded function forward declaration
has been removed from the -mm tree.  Its filename was
     shmem-remove-unneeded-function-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

