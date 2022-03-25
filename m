Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B950DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357385AbiCYBeO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357543AbiCYBdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020FBF003
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D0EB826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567FFC340EC;
        Fri, 25 Mar 2022 01:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171899;
        bh=+QrMRPRB1Orv6pzC9Qg7yoxsb5wOW4ySRhAsiQQetgw=;
        h=Date:To:From:Subject:From;
        b=oyt0VT84d0ggnqTztodzEALT7mYmn1/OOGF8fkbHhpd+iEnyi4NSutDwGhgK2EYzX
         1vSbaOpVVeNF4ubB9Sfkapzu4+hd0gWE7NyZVPzGWdcD4uOl0WKJpGyX265/i47YLj
         FAO/uyVHDbnCTGHp7SZuugLwLecwlBDrOh85Ta5c=
Date:   Thu, 24 Mar 2022 18:31:38 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch removed from -mm tree
Message-Id: <20220325013139.567FFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap

Patch series "A few cleanup and fixup patches for memory failure", v3.

This series contains a few patches to simplify the code logic, remove
unneeded variable and remove obsolete comment.  Also we fix race changing
page more robustly in memory_failure.  More details can be found in the
respective changelogs.  


This patch (of 8):

The flags always has MF_ACTION_REQUIRED and MF_MUST_KILL set.  So we do
not need to check these flags again.

Link: https://lkml.kernel.org/r/20220218090118.1105-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220218090118.1105-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap
+++ a/mm/memory-failure.c
@@ -1640,7 +1640,7 @@ static int memory_failure_dev_pagemap(un
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs(page, &tokill, true);
 
 	list_for_each_entry(tk, &tokill, nd)
 		if (tk->size_shift)
@@ -1655,7 +1655,7 @@ static int memory_failure_dev_pagemap(un
 		start = (page->index << PAGE_SHIFT) & ~(size - 1);
 		unmap_mapping_range(page->mapping, start, size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, false, pfn, flags);
+	kill_procs(&tokill, true, false, pfn, flags);
 	rc = 0;
 unlock:
 	dax_unlock_page(page, cookie);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

