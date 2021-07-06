Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E848FC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C4661C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhGFTNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231438AbhGFTNl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE6F61C6C;
        Tue,  6 Jul 2021 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598662;
        bh=n4dBvWFy2Z5rTBdLY6z9FZyESUHKkw7lmZ6rE8E9JpA=;
        h=Date:From:To:Subject:From;
        b=F594/wkDwXrnAineFD5hLA0c95gjYaFl0wMpWtyH19nmuxuET/HBs+m2VGRHgMHBQ
         NqOAcumoCAGS0MiLPzUuMLZ71kQkiNucoPVp2QcyKU5vMA+bzJ+R8Gqyk7Jzd96ntC
         qbvS1g5GhMSTLGUAjpFHJBrVN/w2eTEVgqy39bIA=
Date:   Tue, 06 Jul 2021 12:11:02 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-swap_slotsc-delete-meaningless-forward-declarations.patch removed from
 -mm tree
Message-ID: <20210706191102.QIA6h0B-A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: delete meaningless forward declarations
has been removed from the -mm tree.  Its filename was
     mm-swap_slotsc-delete-meaningless-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap_slots.c: delete meaningless forward declarations

deactivate_swap_slots_cache() and reactivate_swap_slots_cache() are only
called below their implementations.  So these forward declarations are
meaningless and should be removed.

Link: https://lkml.kernel.org/r/20210520134022.1370406-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/swap_slots.c~mm-swap_slotsc-delete-meaningless-forward-declarations
+++ a/mm/swap_slots.c
@@ -43,8 +43,6 @@ static DEFINE_MUTEX(swap_slots_cache_mut
 static DEFINE_MUTEX(swap_slots_cache_enable_mutex);
 
 static void __drain_swap_slots_cache(unsigned int type);
-static void deactivate_swap_slots_cache(void);
-static void reactivate_swap_slots_cache(void);
 
 #define use_swap_slot_cache (swap_slot_cache_active && swap_slot_cache_enabled)
 #define SLOTS_CACHE 0x1
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

