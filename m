Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0654C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiCVVpw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiCVVpm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3935E154
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDDFB614A2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D944C340EC;
        Tue, 22 Mar 2022 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985453;
        bh=sq91+5Li+9XYqSTLeVxMzaSRvaiLl3o2S1cnLE6YEvY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=yzYU1uJHEeHkSqKsXHaM994oYK3rj3OYSg9+9WrhT8mKGrY2vL9W1F+evskHFhuWB
         6s3/hPT5vEfwMQHZq8XoMLMRE56nkaTtbZJqU7njxTlInLtuIkaCdhyhCpNIRjTVmZ
         6KmU600+DSh0G/aSuXtMopDNPEQifhsiJ0mYzVM0=
Date:   Tue, 22 Mar 2022 14:44:12 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 112/227] mm/memory-failure.c: minor clean up for memory_failure_dev_pagemap
Message-Id: <20220322214413.3D944C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
