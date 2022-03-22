Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD38DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbiCVVo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiCVVoE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754225F26C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21339B81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE339C340EE;
        Tue, 22 Mar 2022 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985353;
        bh=QkjuG4RlAp0lVQvcDkJiAAem/hBEFCOY6/rUVHq5FQw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=NmO3q/0inf88gph868xUVDbnQitySWqaAYp4AWjfrKb3r6uxFIreXSDTPKMMNC/pQ
         tH9+8eFcEEt1EI2TmHRIqss50ssLUJ3zU/pj6nZZ8MD9a0Q81P3NbWp99fbO9iI5sZ
         KoFZk4AZzSFt5YxP8hYR007ZEuNJh60qsD3DrXCA=
Date:   Tue, 22 Mar 2022 14:42:33 -0700
To:     linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 079/227] mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()
Message-Id: <20220322214233.BE339C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()

Use helper macro min and max to help simplify the code logic.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220224121134.35068-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree
+++ a/mm/memory.c
@@ -3350,12 +3350,8 @@ static inline void unmap_mapping_range_t
 	vma_interval_tree_foreach(vma, root, first_index, last_index) {
 		vba = vma->vm_pgoff;
 		vea = vba + vma_pages(vma) - 1;
-		zba = first_index;
-		if (zba < vba)
-			zba = vba;
-		zea = last_index;
-		if (zea > vea)
-			zea = vea;
+		zba = max(first_index, vba);
+		zea = min(last_index, vea);
 
 		unmap_mapping_range_vma(vma,
 			((zba - vba) << PAGE_SHIFT) + vma->vm_start,
_
