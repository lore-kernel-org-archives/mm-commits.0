Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB49C43334
	for <mm-commits@archiver.kernel.org>; Thu,  2 Jun 2022 18:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiFBSaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiFBSaB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2022 14:30:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D833F1C2D7C
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 11:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99344B8211F
        for <mm-commits@vger.kernel.org>; Thu,  2 Jun 2022 18:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F0FC385A5;
        Thu,  2 Jun 2022 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654194598;
        bh=NJeIzQd0MZkDSPAqR0AvlbYCfiDrefxQcQj03suwS4Q=;
        h=Date:To:From:Subject:From;
        b=r6wQX8j/GHuHNWBqFNsuOcWosS5oAh1CrCWiBMt5VRtXu66ldlbMekzTuQ+SOEOh9
         nsf8HMKrood7X3l32ib+0MG+ScVynTwQHzRz3N6osSNcv3UeeFN0pnzcx3vmFXooDW
         6EXm1B6EXt4Qurdiq5CHj62HXL5dMPW2LU7wiUIE=
Date:   Thu, 02 Jun 2022 11:29:57 -0700
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-one-kernel-doc-comment.patch added to mm-hotfixes-unstable branch
Message-Id: <20220602182958.48F0FC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: fix one kernel-doc comment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-one-kernel-doc-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-one-kernel-doc-comment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-fix-one-kernel-doc-comment.patch

