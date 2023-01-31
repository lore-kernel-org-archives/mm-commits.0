Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE82C636CC
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 23:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjAaXOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 18:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjAaXOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 18:14:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9848E7A8D
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 15:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8992CCE217C
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 23:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F495C433D2;
        Tue, 31 Jan 2023 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675206869;
        bh=ah97Qd5cDJFz/kwZJ3gH8BRJsuqDvozUqrrql2UnmGE=;
        h=Date:To:From:Subject:From;
        b=I3NA0Hdzpb8t4FA+eVeOBmzTKxHBXsg5B2RBFbV2+gDigD93c3thtJSL81jXi0Dby
         naVd7C0YXcbL86hKdf9sRU10fYNj6TppbvJZb8orNHeJhzDgspCKliAoPK8S9jxx6Z
         P5lb3G9Pz0IBsfV1dGwUUZca3Akik0fN6IGPFO5s=
Date:   Tue, 31 Jan 2023 15:14:29 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        chenwandun@huawei.com, xialonglong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-remove-pr_debug-in-get_swap_pages.patch added to mm-unstable branch
Message-Id: <20230131231429.8F495C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: remove pr_debug in get_swap_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-remove-pr_debug-in-get_swap_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-remove-pr_debug-in-get_swap_pages.patch

This patch will later appear in the mm-unstable branch at
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
From: Longlong Xia <xialonglong1@huawei.com>
Subject: mm/swapfile: remove pr_debug in get_swap_pages()
Date: Tue, 31 Jan 2023 07:10:35 +0000

It's known that get_swap_pages() may fail to find available space under
some extreme case, but pr_debug() provides useless information.  Let's
remove it.

Link: https://lkml.kernel.org/r/20230131071035.1085968-1-xialonglong1@huawei.com
Signed-off-by: Longlong Xia <xialonglong1@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-remove-pr_debug-in-get_swap_pages
+++ a/mm/swapfile.c
@@ -1098,8 +1098,6 @@ start_over:
 		spin_unlock(&si->lock);
 		if (n_ret || size == SWAPFILE_CLUSTER)
 			goto check_out;
-		pr_debug("scan_swap_map of si %d failed to find offset\n",
-			si->type);
 		cond_resched();
 
 		spin_lock(&swap_avail_lock);
_

Patches currently in -mm which might be from xialonglong1@huawei.com are

mm-swapfile-add-cond_resched-in-get_swap_pages.patch
mm-swapfile-remove-pr_debug-in-get_swap_pages.patch

