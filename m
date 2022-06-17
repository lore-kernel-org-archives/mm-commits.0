Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70657C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379410AbiFQCMR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiFQCMO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E11C64BD9
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B3A61C5E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E63C34114;
        Fri, 17 Jun 2022 02:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431933;
        bh=EM99rVaBzPV/bysDleQWIb/ntkLzzh9h7n5YQ1AxwZU=;
        h=Date:To:From:Subject:From;
        b=Vtnehc7ydCBkIfLupaqVBI/h2Wc2s1UTrvAyIQKK4TyugpOWfewant+Mqs+w+7ZBI
         HRK7FhWO7aUaR9EHUkKOoHbyH9CTHToUjNnqUJchqUQ2cDvk03WG7wfMrloA9mx3YJ
         oenLm09qRcmidJUuwT8KifBGoOtkApcwUA/ouILE=
Date:   Thu, 16 Jun 2022 19:12:12 -0700
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-one-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20220617021213.44E63C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_isolation.c: fix one kernel-doc comment
has been removed from the -mm tree.  Its filename was
     mm-fix-one-kernel-doc-comment.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/page_isolation.c: fix one kernel-doc comment
Date: Thu, 2 Jun 2022 14:21:16 +0800

Remove one warning found by running scripts/kernel-doc, which is caused by
using 'make W=1':

mm/page_isolation.c:304: warning: Function parameter or member
'skip_isolation' not described in 'isolate_single_pageblock'

Link: https://lkml.kernel.org/r/20220602062116.61199-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_isolation.c~mm-fix-one-kernel-doc-comment
+++ a/mm/page_isolation.c
@@ -286,6 +286,8 @@ __first_valid_page(unsigned long pfn, un
  * @flags:			isolation flags
  * @gfp_flags:			GFP flags used for migrating pages
  * @isolate_before:	isolate the pageblock before the boundary_pfn
+ * @skip_isolation:	the flag to skip the pageblock isolation in second
+ *			isolate_single_pageblock()
  *
  * Free and in-use pages can be as big as MAX_ORDER-1 and contain more than one
  * pageblock. When not all pageblocks within a page are isolated at the same
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


