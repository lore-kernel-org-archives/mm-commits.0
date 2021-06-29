Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DEAC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9467C61D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhF2Cje (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhF2Cje (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C1161D08;
        Tue, 29 Jun 2021 02:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934227;
        bh=25qhnWFcYyfeFagkTltMEHXHoANLGXZdm/0ppDG0rNs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UzGPYJSKIpzXIBivIvfd40mLVToh6QNNvmWbPPFK4utsQMOvqyQ04JbKUcz8Z21aJ
         OeYPrGmUuoslxVcaYYhWR6EnkZP6zOEBtEkUfb+sJp2WGAoPWe53JsrY+qYnaUekSS
         Vy5hms0Ix9mTUpSZlHCVVUHQDHEsnFSEG029z/Lk=
Date:   Mon, 28 Jun 2021 19:37:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 073/192] mm/swap_slots.c: delete meaningless
 forward declarations
Message-ID: <20210629023706.g_1VjJOdV%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
