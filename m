Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF9BC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKIBjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiKIBip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AA765E70
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE53C61820
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E179C433D7;
        Wed,  9 Nov 2022 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957921;
        bh=qPFREPQokC79BeGAPDZzbt1B8WminWRWaLt/pNeqO6M=;
        h=Date:To:From:Subject:From;
        b=VkTF0zC38+OOt0FEHASVLUkB/tSmeuSv9xKP/0MRwSRc69hKy6iNLDbWS/YrpOKWm
         0ymZrF1OAmTeobYVMyP2bNe7fRYFn/HYyMUq53mm31j5RU3id6sa2q47dNq4qR3J98
         0ZEaWxox8DG7zkjlHbm0gk0LYJxTHTWciJXoFK6Q=
Date:   Tue, 08 Nov 2022 17:38:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch removed from -mm tree
Message-Id: <20221109013841.4E179C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: rename page_not_mapped() to folio_not_mapped()
has been removed from the -mm tree.  Its filename was
     mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: rmap: rename page_not_mapped() to folio_not_mapped()
Date: Tue, 27 Sep 2022 14:38:26 +0800

Since commit 2f031c6f042c ("mm/rmap: Convert rmap_walk() to take a
folio"), page_not_mapped() takes folio as parameter, rename it to be
consistent.

Link: https://lkml.kernel.org/r/20220927063826.159590-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-rename-page_not_mapped-to-folio_not_mapped
+++ a/mm/rmap.c
@@ -1801,7 +1801,7 @@ static bool invalid_migration_vma(struct
 	return vma_is_temporary_stack(vma);
 }
 
-static int page_not_mapped(struct folio *folio)
+static int folio_not_mapped(struct folio *folio)
 {
 	return !folio_mapped(folio);
 }
@@ -1822,7 +1822,7 @@ void try_to_unmap(struct folio *folio, e
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
@@ -2150,7 +2150,7 @@ void try_to_migrate(struct folio *folio,
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_migrate_one,
 		.arg = (void *)flags,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 
@@ -2297,7 +2297,7 @@ static bool folio_make_device_exclusive(
 	};
 	struct rmap_walk_control rwc = {
 		.rmap_one = page_make_device_exclusive_one,
-		.done = page_not_mapped,
+		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
 		.arg = &args,
 	};
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


