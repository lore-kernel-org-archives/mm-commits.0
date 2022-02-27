Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEDEC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 27 Feb 2022 21:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiB0V7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 16:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiB0V7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 16:59:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C665D03
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 13:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C16F56117F
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2404EC340F0;
        Sun, 27 Feb 2022 21:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645999144;
        bh=jK61R81V0FxToQP1qMQf+yT3uFcW3foCIr2ge07nuN0=;
        h=Date:To:From:Subject:From;
        b=w3+5S5GKqHOEghWd0oRmfkAQBlII0U+qcwwgHTxuVCXFYMUYgxE7Ho6lKl90Hcf5W
         S+lF46pnXi1o2TdLaS8U7aUNY5HRxeGgBljbcM2J9UNQTMscoRNGSZ8ss7Mrnytx1c
         bQBK/MXFI0c3gEQHWgCkXLPLaW87T2a9TY5x6mX8=
Date:   Sun, 27 Feb 2022 13:59:03 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        caoyixuan2019@email.szu.edu.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-fix-a-comment.patch added to -mm tree
Message-Id: <20220227215904.2404EC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix a comment
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-a-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-fix-a-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-fix-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/vmalloc.c: fix a comment

Link: https://lkml.kernel.org/r/20220227084544.4681-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-a-comment
+++ a/mm/vmalloc.c
@@ -2886,7 +2886,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
 			 * otherwise memory may be allocated in only one node,
-			 * but mempolcy want to alloc memory by interleaving.
+			 * but mempolicy want to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-delete-invalid-duplicate-code.patch
documentation-vm-page_ownerrst-fix-commends.patch
mm-page_ownerc-record-tgid.patch
tools-vm-page_owner_sortc-fix-the-instructions-for-use.patch
mm-vmallocc-fix-a-comment.patch

