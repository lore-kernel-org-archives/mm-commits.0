Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7CCECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiH0WNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiH0WNh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:13:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DED356C8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5613B80A49
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B10C433C1;
        Sat, 27 Aug 2022 22:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661638413;
        bh=aEAtKh0xVaTwCiilEoZxjr51u/MPVfWqBH+dpPjFIqg=;
        h=Date:To:From:Subject:From;
        b=Gmb/YS4mX0SWReS3VsL5oYUvtyLNMtz+xkG/24YH+4FdO4dcIJYe0b24wvSujIwz5
         KrDYzQIsCjGDt587MFaj16WjS8X/LKlMDOcCUFQK7D2U/Dxr5MvtsLbfw6o8TduKxP
         eiSAoCX9NLvNBNz4RPewzRVqrgPinygfMxj+TOD4=
Date:   Sat, 27 Aug 2022 15:13:32 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch added to mm-unstable branch
Message-Id: <20220827221333.58B10C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: frontswap: invoke ops->init for online swap device in frontswap_register_ops
has been added to the -mm mm-unstable branch.  Its filename is
     frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: frontswap: invoke ops->init for online swap device in frontswap_register_ops
Date: Sat, 27 Aug 2022 18:45:57 +0800

Since we are supported to delay zswap initializaton, we need to invoke
ops->init for the swap device which is already online when register
backend.

This patch is a revert of f328c1d16e4c ("frontswap: simplify
frontswap_register_ops") and 633423a09cb5 ("mm: mark swap_lock and
swap_active_head static").

Link: https://lkml.kernel.org/r/20220827104600.1813214-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 +
 mm/frontswap.c           |   47 +++++++++++++++++++++++++++++++++++++
 mm/swapfile.c            |    4 +--
 3 files changed, 51 insertions(+), 2 deletions(-)

--- a/include/linux/swapfile.h~frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops
+++ a/include/linux/swapfile.h
@@ -6,6 +6,8 @@
  * these were static in swapfile.c but frontswap.c needs them and we don't
  * want to expose them to the dozens of source files that include swap.h
  */
+extern spinlock_t swap_lock;
+extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
 /* Maximum swapfile size supported for the arch (not inclusive). */
--- a/mm/frontswap.c~frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops
+++ a/mm/frontswap.c
@@ -96,11 +96,58 @@ static inline void inc_frontswap_invalid
  */
 int frontswap_register_ops(const struct frontswap_ops *ops)
 {
+	DECLARE_BITMAP(a, MAX_SWAPFILES);
+	DECLARE_BITMAP(b, MAX_SWAPFILES);
+	struct swap_info_struct *si;
+	unsigned int i;
+
 	if (frontswap_ops)
 		return -EINVAL;
 
+	bitmap_zero(a, MAX_SWAPFILES);
+	bitmap_zero(b, MAX_SWAPFILES);
+
+	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if (!WARN_ON(!si->frontswap_map))
+			__set_bit(si->type, a);
+	}
+	spin_unlock(&swap_lock);
+
+	/* the new ops needs to know the currently active swap devices */
+	for_each_set_bit(i, a, MAX_SWAPFILES) {
+		pr_err("init frontswap_ops\n");
+		ops->init(i);
+	}
+
 	frontswap_ops = ops;
 	static_branch_inc(&frontswap_enabled_key);
+
+	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if (si->frontswap_map)
+			__set_bit(si->type, b);
+	}
+	spin_unlock(&swap_lock);
+
+	/*
+	 * On the very unlikely chance that a swap device was added or
+	 * removed between setting the "a" list bits and the ops init
+	 * calls, we re-check and do init or invalidate for any changed
+	 * bits.
+	 */
+	if (unlikely(!bitmap_equal(a, b, MAX_SWAPFILES))) {
+		for (i = 0; i < MAX_SWAPFILES; i++) {
+			if (!test_bit(i, a) && test_bit(i, b)) {
+				pr_err("init frontswap_ops re\n");
+				ops->init(i);
+			} else if (test_bit(i, a) && !test_bit(i, b)) {
+				pr_err("inval frontswap_ops re\n");
+				ops->invalidate_area(i);
+			}
+		}
+	}
+
 	return 0;
 }
 
--- a/mm/swapfile.c~frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops
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

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch
frontswap-skip-frontswap_ops-init-if-zswap-init-failed.patch
frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

