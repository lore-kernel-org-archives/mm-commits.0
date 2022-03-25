Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4236EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354396AbiCYBeM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357527AbiCYBdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D14BF965
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9D561947
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EB1C340EC;
        Fri, 25 Mar 2022 01:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171896;
        bh=QVXHQhvB5nUF4YItS4FiaL+QI8FeZJ6AdMvs5KLF1Wc=;
        h=Date:To:From:Subject:From;
        b=wFnr0gbNDiNiqMcK7Mm1LIczB/sNtkEXhvfO1MdXfEtEspGbgrf9/mdoJdCmumUe4
         YZ6NjhErv/815QFlQ7cqgxo+4BPy49c4TaZZqckQQL/xV8vRxX8RIPUCZsTsueXWf/
         Thrsy4AohioY8P/m2apH2r7RPmXRd7xH0/dvM7rA=
Date:   Thu, 24 Mar 2022 18:31:35 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, osalvador@suse.de,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        anshuman.khandual@arm.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hwpoison-remove-obsolete-comment.patch removed from -mm tree
Message-Id: <20220325013136.41EB1C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove obsolete comment
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-obsolete-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/memory-failure.c: remove obsolete comment

With the introduction of mf_mutex, most of memory error handling process
is mutually exclusive, so the in-line comment about subtlety about
double-checking PageHWPoison is no more correct.  So remove it.

Link: https://lkml.kernel.org/r/20220125025601.3054511-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-obsolete-comment
+++ a/mm/memory-failure.c
@@ -2150,12 +2150,6 @@ static int __soft_offline_page(struct pa
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	/*
-	 * Check PageHWPoison again inside page lock because PageHWPoison
-	 * is set by memory_failure() outside page lock. Note that
-	 * memory_failure() also double-checks PageHWPoison inside page lock,
-	 * so there's no race between soft_offline_page() and memory_failure().
-	 */
 	lock_page(page);
 	if (!PageHuge(page))
 		wait_on_page_writeback(page);
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


