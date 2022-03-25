Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB5DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357397AbiCYBd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357429AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E9BF01E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08D4EB82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA3C340EC;
        Fri, 25 Mar 2022 01:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171864;
        bh=1QltJkviaMqRMvEk6xWjjf0655R1Z1rNlFo1MLD4Lmc=;
        h=Date:To:From:Subject:From;
        b=NyNmmAMvSsN4fPOEMLnDPjIc0HPTuSrFyIrSWOuOVsV/jqe6tqDiV1kxOLPrd8W2j
         aA9CQetZoFhRmP+nrlQhtWdRRkMEfbEtECkokRJutrDYlEci1l684MfszekA+CcUq3
         jR06pJeIdVpexi+MqFnuvTYr2Wb9mnHYJkUo31Js=
Date:   Thu, 24 Mar 2022 18:31:04 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch removed from -mm tree
Message-Id: <20220325013104.B5EA3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use helper macro min and max in unmap_mapping_range_tree()
has been removed from the -mm tree.  Its filename was
     mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

