Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E2AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiEJEWY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiEJEUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7072DAB4
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A048B81B10
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DFEC385C2;
        Tue, 10 May 2022 04:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156144;
        bh=VpDgzRWVUvz52AiBJnXvIONKAgqB3cznr6NsH5RuSAE=;
        h=Date:To:From:Subject:From;
        b=dxNtCLCvnOBn5txPmUG4Lt7L1TSVlbTE+KkZMWHZe/oRobpWk1kImcEenHcO6VogB
         gRLvmhhaOZQbMw1RGHk10ook+RCc4Y9Oq6ogV5zKNiB0XzxaWcmsUN2qx9HQYzFstj
         2Azvah7x9WYmSyiMvH6WU30wIKSF41i1zF3G0+rE=
Date:   Mon, 09 May 2022 21:15:43 -0700
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        peterx@redhat.com, naoya.horiguchi@nec.com, hughd@google.com,
        apopple@nvidia.com, zhanghongchen@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapops-make-is_pmd_migration_entry-more-strict.patch removed from -mm tree
Message-Id: <20220510041544.23DFEC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapops: make is_pmd_migration_entry more strict
has been removed from the -mm tree.  Its filename was
     mm-swapops-make-is_pmd_migration_entry-more-strict.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Hongchen Zhang <zhanghongchen@loongson.cn>
Subject: mm/swapops: make is_pmd_migration_entry more strict

A pmd migration entry should first be a swap pmd,so use is_swap_pmd(pmd)
instead of !pmd_present(pmd).

On the other hand, some architecture (MIPS for example) may misjudge a
pmd_none entry as a pmd migration entry.

Link: https://lkml.kernel.org/r/1651131333-6386-1-git-send-email-zhanghongchen@loongson.cn
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swapops.h~mm-swapops-make-is_pmd_migration_entry-more-strict
+++ a/include/linux/swapops.h
@@ -331,7 +331,7 @@ static inline pmd_t swp_entry_to_pmd(swp
 
 static inline int is_pmd_migration_entry(pmd_t pmd)
 {
-	return !pmd_present(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
+	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
 #else
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
_

Patches currently in -mm which might be from zhanghongchen@loongson.cn are


