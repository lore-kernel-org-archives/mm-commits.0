Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385B1C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0989B2072D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598305549;
	bh=1TSmP/1m1hdoBQ3NHqr993xqRk1p/8/mlB3QJBm5g5E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wfk9axt8FADDStJbgPnLIDJswPycD+TZmMMj0fTze8qYkD96p7CU17qKtDsVxZfkz
	 WnAXbudsi89aHZg/9l2146kEEresTURSUiwo/9UlIFIEpKPuZeAMbynQTmzsD14lyK
	 218jfw9G1bBp6jPQ//gSFpiM0ck0ow0nFL8REa34=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHXVps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgHXVps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:45:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E733920702;
        Mon, 24 Aug 2020 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598305548;
        bh=1TSmP/1m1hdoBQ3NHqr993xqRk1p/8/mlB3QJBm5g5E=;
        h=Date:From:To:Subject:From;
        b=KYGZTHfrb4wt7p75m4qCj6EpURkjm8K0qsPMynwUjRBi0M5MZB1+Gc1gf7yMaG45f
         sHHvwG0Wk8WZpNA4qGvnSM6rT5rmA0FRTgytd8rboam7/lDbAPHD2Osn/K8FR6lw8q
         BLwmg6SV2UykItJjV4XCTHs1OVkvs1kzeZeMKtSs=
Date:   Mon, 24 Aug 2020 14:45:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 mm-mempool-add-else-to-split-mutually-exclusive-case.patch removed from -mm
 tree
Message-ID: <20200824214547.6gpH9Y2rU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: Add 'else' to split mutually exclusive case
has been removed from the -mm tree.  Its filename was
     mm-mempool-add-else-to-split-mutually-exclusive-case.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempool: Add 'else' to split mutually exclusive case

Add else to split mutually exclusive cases and to avoid some unnecessary
check.

akpm: doesn't affect code generation but it's a little cleaner.

[joe@perches.com: style: braces should be added to the first test]
  Link: https://lkml.kernel.org/r/37bbda0e0d94d3324210fa807f4061a9e9bd66bc.camel@perches.comLink: https://lkml.kernel.org/r/20200824115354.7879-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case
+++ a/mm/mempool.c
@@ -57,12 +57,12 @@ static void __check_element(mempool_t *p
 
 static void check_element(mempool_t *pool, void *element)
 {
-	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+	if (pool->free == mempool_free_slab ||
+	    pool->free == mempool_kfree) {
+		/* Mempools backed by slab allocator */
 		__check_element(pool, element, ksize(element));
-
-	/* Mempools backed by page allocator */
-	if (pool->free == mempool_free_pages) {
+	} else if (pool->free == mempool_free_pages) {
+		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

