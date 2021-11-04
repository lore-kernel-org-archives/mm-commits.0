Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE8EC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC746124F
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhKDWNc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232289AbhKDWNa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Nov 2021 18:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E65F61220;
        Thu,  4 Nov 2021 22:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636063852;
        bh=huiEVRGmrDnKeU4E2Iy3uVeVU+FwHPw6h25Zr2kjwao=;
        h=Date:From:To:Subject:From;
        b=Epaa+9/BXPf5ouR/5umxiOu5EAf4KiP8+2e02J/x2KnODqBmTkP+16TlepR13TCnJ
         4HpzZGkT5kl3DiD/L0lJzcJsPZLfOxq5wuUeemNIaqrtK1rS4++OhR5RDy7dnnF3Uk
         uHFkOf2Y4jcq6QGM75KhYxNI7ZV0fR5r9w3Mjszw=
Date:   Thu, 04 Nov 2021 15:10:51 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  [to-be-updated]
 mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch removed
 from -mm tree
Message-ID: <20211104221051.GtJWmpSoK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: combine two atomic ops in zs_pool_dec_isolated()
has been removed from the -mm tree.  Its filename was
     mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zsmalloc.c: combine two atomic ops in zs_pool_dec_isolated()

atomic_long_dec_and_test() is equivalent to atomic_long_dec() and
atomic_long_read() == 0.  Use it to make code more succinct.

Link: https://lkml.kernel.org/r/20210624123930.1769093-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated
+++ a/mm/zsmalloc.c
@@ -1828,14 +1828,13 @@ static void putback_zspage_deferred(stru
 static inline void zs_pool_dec_isolated(struct zs_pool *pool)
 {
 	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
-	atomic_long_dec(&pool->isolated_pages);
 	/*
 	 * Checking pool->destroying must happen after atomic_long_dec()
 	 * for pool->isolated_pages above. Paired with the smp_mb() in
 	 * zs_unregister_migration().
 	 */
 	smp_mb__after_atomic();
-	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
+	if (atomic_long_dec_and_test(&pool->isolated_pages) && pool->destroying)
 		wake_up_all(&pool->migration_wait);
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
mm-page_allocc-simplify-the-code-by-using-macro-k.patch
mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch
mm-page_allocc-use-helper-function-zone_spans_pfn.patch
mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch

