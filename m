Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA37ECAAD2
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 19:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiH2T5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 15:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiH2T5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 15:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D2E910B0
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 12:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18EFB60E89
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 19:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67455C433B5;
        Mon, 29 Aug 2022 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803021;
        bh=neRiUZ7fGyo1lpLq97RPp3S8rSiFYQP1EjZM4hBsrSI=;
        h=Date:To:From:Subject:From;
        b=sYpZEXUvdHhzL9ordzPZw6NrzpU5QGpglOLgQz588QYwo+KCQQ+P42nM845uOIGbo
         Ex+SQgWdsn+eeqyYYnGZ6j/kCKZ0nyxRc5H0971H2yNHBFSYsgeIfPaOEJnvClHgHd
         uMvzZWXJJUjRJbY5gaO/CuA4MClafLr3H/DJwUuY=
Date:   Mon, 29 Aug 2022 12:57:00 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch removed from -mm tree
Message-Id: <20220829195701.67455C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: frontswap: invoke ops->init for online swap device in frontswap_register_ops
has been removed from the -mm tree.  Its filename was
     frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch

This patch was dropped because an updated version will be merged

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

mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

