Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC32C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BAF22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709184;
	bh=uf34le0lMERcMyPp3i9Zus4yT1PxSAJl4jOPRxlRHkU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vW8m1mdnlXp4t0jp7VHKqflKXnaP0H8w6RmC4YwiS3a97qOcxM/ZAt08wF8wASVaM
	 1vj3wLNWqF8mYSPKIEz8ZtdKCbI1PSafg5AwysXFQ9WeZn0roPDKBeYRNZ5e9+53mX
	 evMRQfug1oKjyDrnlwZVEJO1Gd9lN3w+xhTliu0A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbgJNU7o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbgJNU7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C60B2068E;
        Wed, 14 Oct 2020 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709183;
        bh=uf34le0lMERcMyPp3i9Zus4yT1PxSAJl4jOPRxlRHkU=;
        h=Date:From:To:Subject:From;
        b=KSVF+velc5FwoZfC/os4a/gj3tP17uNtXmVzQnprgOISl5+ziK57uypAkFcfgfI0T
         so/Km3RKOnly49wnuQ8RxqfdVvZJCcaRu3ExNhNSvJHxtUQlBa48Rgm6FG2uADMsGn
         pUe2ZoLQMnjf2EVY5oxRgOsynKYrYqqLPswaE8OI=
Date:   Wed, 14 Oct 2020 13:59:42 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-swap=5Fslotsc-remove-always-zero-and-unused-return-value-?=
 =?US-ASCII?Q?of-enable=5Fswap=5Fslots=5Fcache.patch?= removed from -mm
 tree
Message-ID: <20201014205942.tBI9dIUlO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()

enable_swap_slots_cache() always return zero and its return value is just
ignored by the caller.  So make enable_swap_slots_cache() void.

Link: https://lkml.kernel.org/r/20200924113554.50614-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    2 +-
 mm/swap_slots.c            |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/swap_slots.h~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/include/linux/swap_slots.h
@@ -23,7 +23,7 @@ struct swap_slots_cache {
 
 void disable_swap_slots_cache_lock(void);
 void reenable_swap_slots_cache_unlock(void);
-int enable_swap_slots_cache(void);
+void enable_swap_slots_cache(void);
 int free_swap_slot(swp_entry_t entry);
 
 extern bool swap_slot_cache_enabled;
--- a/mm/swap_slots.c~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -237,7 +237,7 @@ static int free_slot_cache(unsigned int
 	return 0;
 }
 
-int enable_swap_slots_cache(void)
+void enable_swap_slots_cache(void)
 {
 	mutex_lock(&swap_slots_cache_enable_mutex);
 	if (!swap_slot_cache_initialized) {
@@ -255,7 +255,6 @@ int enable_swap_slots_cache(void)
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
-	return 0;
 }
 
 /* called with swap slot cache's alloc lock held */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

