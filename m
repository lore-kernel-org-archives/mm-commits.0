Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF77C47089
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 21:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiLEVGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 16:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiLEVFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 16:05:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F822B603
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 13:05:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC446141B
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 21:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B733CC433D7;
        Mon,  5 Dec 2022 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670274323;
        bh=tM2Zv3o8B9HJizyEILWK8BJvVFd1BwN9v4FXiX1uhHY=;
        h=Date:To:From:Subject:From;
        b=lnyY5FrX5Q2CKFAj56+PhPboMzH264lxcRZAG+iOHuU/R/h1wJLyOIbqhdfk9UeEW
         I8qZYLARLRM8LgIBN3+2f7xNlK9iUYJje+2rjx0ywbJMohYGgLZ50PIICquMIYgr7a
         xaWXsD0oQmfd7Q4stKtEjv2TXv7EZB9NuiJM/x0g=
Date:   Mon, 05 Dec 2022 13:05:22 -0800
To:     mm-commits@vger.kernel.org, shli@fusionio.com, riel@redhat.com,
        hughd@google.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-cond_resched-in-swapin_walk_pmd_entry.patch added to mm-unstable branch
Message-Id: <20221205210523.B733CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add cond_resched() in swapin_walk_pmd_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-cond_resched-in-swapin_walk_pmd_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-cond_resched-in-swapin_walk_pmd_entry.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add cond_resched() in swapin_walk_pmd_entry()
Date: Mon, 5 Dec 2022 22:03:27 +0800

When handling MADV_WILLNEED in madvise(), a soflockup may occurr in
swapin_walk_pmd_entry() if swapping in lots of memory on a slow device. 
Add a cond_resched() to avoid the possible softlockup.

Link: https://lkml.kernel.org/r/20221205140327.72304-1-wangkefeng.wang@huawei.com
Fixes: 1998cc048901 ("mm: make madvise(MADV_WILLNEED) support swap file prefetch")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-add-cond_resched-in-swapin_walk_pmd_entry
+++ a/mm/madvise.c
@@ -223,6 +223,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 			put_page(page);
 	}
 	swap_read_unplug(splug);
+	cond_resched();
 
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-cond_resched-in-swapin_walk_pmd_entry.patch

