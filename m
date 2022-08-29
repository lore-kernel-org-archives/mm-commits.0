Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603DEECAAD8
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiH2UD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiH2UDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 16:03:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448A097D5C
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 13:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCEDB811F6
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 20:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B4FC433C1;
        Mon, 29 Aug 2022 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803415;
        bh=82YfoOJH2dZE9bLrWvzayq0Y3OwqpdX5e8aY8/93wh0=;
        h=Date:To:From:Subject:From;
        b=08XRODBmFQeAa0K9XDiSSYTgma3fU202fPi574Mpn2jWd9RPM3ifAebXhZvGvC3LA
         IO628srIYt5lehBe3+v+9qZHd09g1qyTHsjEf44KoA3CA9TEbKCIyxce5PZ64SJTNX
         aI4ovbiX8IIzRxv6JePT/uXqXrGX7jBfphCXJsgc=
Date:   Mon, 29 Aug 2022 13:03:34 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-frontswap-simplify-frontswap_register_ops.patch added to mm-unstable branch
Message-Id: <20220829200335.71B4FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "frontswap: simplify frontswap_register_ops"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-frontswap-simplify-frontswap_register_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-frontswap-simplify-frontswap_register_ops.patch

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
Subject: Revert "frontswap: simplify frontswap_register_ops"
Date: Mon, 29 Aug 2022 21:22:59 +0800

This reverts commit f328c1d16e4c764992895ac9c9425cea861b2ca0.

Since we plan to delay zswap initializaton, we need to invoke ops->init
for swap devices which are already online when registering backend.

Link: https://lkml.kernel.org/r/20220829132302.3367054-4-liushixin2@huawei.com
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

 mm/frontswap.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/mm/frontswap.c~revert-frontswap-simplify-frontswap_register_ops
+++ a/mm/frontswap.c
@@ -99,6 +99,25 @@ static inline void inc_frontswap_invalid
  */
 void frontswap_register_ops(struct frontswap_ops *ops)
 {
+	DECLARE_BITMAP(a, MAX_SWAPFILES);
+	DECLARE_BITMAP(b, MAX_SWAPFILES);
+	struct swap_info_struct *si;
+	unsigned int i;
+
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
+	for_each_set_bit(i, a, MAX_SWAPFILES)
+		ops->init(i);
+
 	/*
 	 * Setting frontswap_ops must happen after the ops->init() calls
 	 * above; cmpxchg implies smp_mb() which will ensure the init is
@@ -109,6 +128,28 @@ void frontswap_register_ops(struct front
 	} while (cmpxchg(&frontswap_ops, ops->next, ops) != ops->next);
 
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
+			if (!test_bit(i, a) && test_bit(i, b))
+				ops->init(i);
+			else if (test_bit(i, a) && !test_bit(i, b))
+				ops->invalidate_area(i);
+		}
+	}
 }
 
 /*
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

