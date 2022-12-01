Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE28C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiLAALv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiLAAKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61DE900D5
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68DBE61E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B36C43470;
        Thu,  1 Dec 2022 00:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852998;
        bh=Szjm73vIFDgTaMGgEtYm3xFIhTMh0M+fwaZOWPgeTxQ=;
        h=Date:To:From:Subject:From;
        b=Fy/UtxpxB9jImHPf6/2q0vKjoKDnaqA4sp5utbwU1x7jMFFrfwvXfs9TCNf3yYrkg
         vAYAFqMctS6Of0WP5eUmb9XMh69LpG/kuX2IbOHm86bkWfaU2j0TWqWgqiPRWgGLy0
         fLIZPd/gYTXzATZet9EMsywBTqlvL/j2oqsZQVxc=
Date:   Wed, 30 Nov 2022 16:03:17 -0800
To:     mm-commits@vger.kernel.org, pizhenwei@bytedance.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        mawupeng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-cleanup-in-unpoison_memory.patch removed from -mm tree
Message-Id: <20221201000318.82B36C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: cleanup in unpoison_memory
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-cleanup-in-unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm/memory-failure.c: cleanup in unpoison_memory
Date: Fri, 25 Nov 2022 14:54:44 +0800

If freeit is true, the value of ret must be zero, there is no need to
check the value of freeit after label unlock_mutex.

We can drop variable freeit to do this cleanup.

Link: https://lkml.kernel.org/r/20221125065444.3462681-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-cleanup-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2338,7 +2338,6 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int ret = -EBUSY;
-	int freeit = 0;
 	unsigned long count = 1;
 	bool huge = false;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -2413,10 +2412,9 @@ int unpoison_memory(unsigned long pfn)
 				goto unlock_mutex;
 			}
 		}
-		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
-		if (freeit) {
+		if (TestClearPageHWPoison(p)) {
 			put_page(page);
 			ret = 0;
 		}
@@ -2424,7 +2422,7 @@ int unpoison_memory(unsigned long pfn)
 
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
-	if (!ret || freeit) {
+	if (!ret) {
 		if (!huge)
 			num_poisoned_pages_sub(pfn, 1);
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
_

Patches currently in -mm which might be from mawupeng1@huawei.com are


