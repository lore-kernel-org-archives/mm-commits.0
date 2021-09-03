Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485A2C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34898610F7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbhICU5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350253AbhICU5r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE3B610E5;
        Fri,  3 Sep 2021 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702606;
        bh=goLk+VybLEYEIodX+yMV9remJgP1dityHH8ZnvBXyxw=;
        h=Date:From:To:Subject:From;
        b=X8Q16eqinBIW63WkYzsYwG0XGlOggKBqfoW/FIi+X4oq8u6vdOPL44vfJ3MBs8oUZ
         Q6AScxBbMcvyGD6nMDeV6S91qbJZv6Z1bOjTdefKNkg1TDEbN1xRTsATqPo9GwZCfz
         Bm9yTZOGqgKxPWLHtp65sOrJDpPOC4LiP1LJdMKQ=
Date:   Fri, 03 Sep 2021 13:56:46 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] shmem-remove-unneeded-header-file.patch removed
 from -mm tree
Message-ID: <20210903205646.TLuAr9c9a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove unneeded header file
has been removed from the -mm tree.  Its filename was
     shmem-remove-unneeded-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

