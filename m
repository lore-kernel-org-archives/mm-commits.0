Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CF9C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7FB06124F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhKEUpB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhKEUo7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D1161352;
        Fri,  5 Nov 2021 20:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144939;
        bh=fBXL4EL1sBKDDtj6+h126HKRVsfx+U+pPEhhzlUTRp4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EdStPXyH+Fjx4fGrziLDi2zLuR0+72/ILO7krauKKyACZO593LcpNbwA8X4AkOpBA
         NUK9+lU6rFhZy6UHcw+OxLXO71SpK+zA4C/5nMgaIYkbiaPvy1+PP4PFPlhvcqQeio
         Agz1pNblDW/+nNXJttL3AgPfxys7TUTzTZg4EK/Q=
Date:   Fri, 05 Nov 2021 13:42:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        iamjoonsoo.kim@lge.com, jhubbard@nvidia.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 147/262] mm/page_isolation: guard against possible
 putback unisolated page
Message-ID: <20211105204219.IUM80dBhI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
