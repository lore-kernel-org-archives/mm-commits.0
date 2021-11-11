Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAABC43219
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960FD61247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhKKCsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234396AbhKKCsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3A861108;
        Thu, 11 Nov 2021 02:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598733;
        bh=kbgL0SwUowNvwxbXycQ1qla3altSH9pM30NjGRQWHrY=;
        h=Date:From:To:Subject:From;
        b=ar0klxhfu0QmrH8NnwXFIjRTzi36QZ0+tSGEvMPBg7r4V10h/jO9Vg9sqpHmH71W1
         9jCSJso986BZWFXW+GACMynQ5pkcLR0ARIHh2vn1T0xd2ulAiKy8DohmnISm5NLOuO
         AO+XgKqmGI4KgM791TdcljSDDZzYPm4C1f1jY82Y=
Date:   Wed, 10 Nov 2021 18:45:33 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, iamjoonsoo.kim@lge.com, jhubbard@nvidia.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
 removed from -mm tree
Message-ID: <20211111024533.pkXiRhnl0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: guard against possible putback unisolated page
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-guard-against-possible-putback-unisolated-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_isolation: guard against possible putback unisolated page

Isolating a free page in an isolated pageblock is expected to always work
as watermarks don't apply here.  But if __isolate_free_page() failed, due
to condition changes, the page will be left on the free list.  And the
page will be put back to free list again via __putback_isolated_page(). 
This may trigger VM_BUG_ON_PAGE() on page->flags checking in
__free_one_page() if PageReported is set.  Or we will corrupt the free
list because list_add() will be called for pages already on another list. 
Add a VM_WARN_ON() to complain about this change.

Link: https://lkml.kernel.org/r/20210914114508.23725-1-linmiaohe@huawei.com
Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-guard-against-possible-putback-unisolated-page
+++ a/mm/page_isolation.c
@@ -94,8 +94,13 @@ static void unset_migratetype_isolate(st
 			buddy = page + (buddy_pfn - pfn);
 
 			if (!is_migrate_isolate_page(buddy)) {
-				__isolate_free_page(page, order);
-				isolated_page = true;
+				isolated_page = !!__isolate_free_page(page, order);
+				/*
+				 * Isolating a free page in an isolated pageblock
+				 * is expected to always work as watermarks don't
+				 * apply here.
+				 */
+				VM_WARN_ON(!isolated_page);
 			}
 		}
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


