Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CC9ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 20:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiIIUdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 16:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiIIUcm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 16:32:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3A459BE
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 13:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 741CA61FF5
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 20:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72B9C433C1;
        Fri,  9 Sep 2022 20:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662755549;
        bh=g26YgQyoWp8NDpT6YGR208nrZkSAy+DgVllFGYzvRBI=;
        h=Date:To:From:Subject:From;
        b=QU4pv6lFoXKpGON50jyVhjJP5312wsJtOlq4ku8JcNokf4gtkJ8aIs9HOqhb5JO/w
         elr3/EPCaT7iBo+fMYapV4HPugRPrVPjvd1bH8UGeQluLlEYvVEhUkfceDMwHGbfWT
         xnkfhftU11h84sdEDvzErJQfKK2G9EcWNf7/Qia8=
Date:   Fri, 09 Sep 2022 13:32:29 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] revert-mm-mark-swap_lock-and-swap_active_head-static.patch removed from -mm tree
Message-Id: <20220909203229.C72B9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: mark swap_lock and swap_active_head static"
has been removed from the -mm tree.  Its filename was
     revert-mm-mark-swap_lock-and-swap_active_head-static.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: Revert "mm: mark swap_lock and swap_active_head static"
Date: Mon, 29 Aug 2022 21:22:58 +0800

Patch series "Delay the initializaton of zswap", v4.

In the initialization of zswap, about 18MB memory will be allocated for
zswap_pool.  Since not all users use zswap, the memory may be wasted. 
Save the memory for these users by delaying the initialization of zswap to
first enablement.  

This patch (of 5):

This reverts commit 633423a09cb5cfe61438283e1ce49c23cf4a0611.

swap_lock and swap_active_head will be used in the next patch, so export
them again.

Link: https://lkml.kernel.org/r/20220829132302.3367054-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 mm/swapfile.c            |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/swapfile.h~revert-mm-mark-swap_lock-and-swap_active_head-static
+++ a/include/linux/swapfile.h
@@ -6,6 +6,8 @@
  * these were static in swapfile.c but frontswap.c needs them and we don't
  * want to expose them to the dozens of source files that include swap.h
  */
+extern spinlock_t swap_lock;
+extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
 unsigned long arch_max_swapfile_size(void);
--- a/mm/swapfile.c~revert-mm-mark-swap_lock-and-swap_active_head-static
+++ a/mm/swapfile.c
@@ -51,7 +51,7 @@ static bool swap_count_continued(struct
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
 
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -77,7 +77,7 @@ static const char Unused_offset[] = "Unu
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-static PLIST_HEAD(swap_active_head);
+PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch
mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

