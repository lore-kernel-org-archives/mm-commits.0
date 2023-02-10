Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F194DC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjBJA4Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjBJAzB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987EE74302
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E3761B7A
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A450C433D2;
        Fri, 10 Feb 2023 00:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990445;
        bh=0sh9mGL2J0PqTVP5AU7dmba3OyeQXrLhz6hGLvKUggw=;
        h=Date:To:From:Subject:From;
        b=SB0EFN8pEgYnTLTxHb2QrX10Rm07WMWOzWoSC3i9p7UqKuxvwkPdcygUeQjPGzIw9
         OA08yRGzQs9ApAKgXJPpIRpeNNZjYYVkBVWzOmsgBttiie58Ser1ZJi+cenPf9N0VG
         2Z5pMUbMxR7bXPVIRFQoR2uv0rv/T3mzaU4kGaTE=
Date:   Thu, 09 Feb 2023 16:54:05 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        chenwandun@huawei.com, xialonglong1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-remove-pr_debug-in-get_swap_pages.patch removed from -mm tree
Message-Id: <20230210005405.8A450C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile: remove pr_debug in get_swap_pages()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-remove-pr_debug-in-get_swap_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


