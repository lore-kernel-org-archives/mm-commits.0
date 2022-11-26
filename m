Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A667C43217
	for <mm-commits@archiver.kernel.org>; Sat, 26 Nov 2022 00:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKZAyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKZAyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 19:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C68613FAA
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 16:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA3F60F84
        for <mm-commits@vger.kernel.org>; Sat, 26 Nov 2022 00:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF95AC433D6;
        Sat, 26 Nov 2022 00:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669424051;
        bh=2t5YFp37Go8b3qYK5zjs1DRaHtLFTZmpCzrIzqftWc8=;
        h=Date:To:From:Subject:From;
        b=PgA77JysVQwieaw/4ye7hFW/D71/HDUQiy1Tt1QBzlcFNbRJnJwQJA0PK/OiCA1mu
         Fwj0WQxHCtQMJwh0/8dAj0m7e/oA95nkoYFsOV2VoQK8IIEDYOo4RqW2LVdzOpBVee
         ytD7v7ZSaAmbQundamUK/NSI1aZuQJfURSXYyTdc=
Date:   Fri, 25 Nov 2022 16:54:10 -0800
To:     mm-commits@vger.kernel.org, pizhenwei@bytedance.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        mawupeng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-cleanup-in-unpoison_memory.patch added to mm-unstable branch
Message-Id: <20221126005410.EF95AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: cleanup in unpoison_memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failurec-cleanup-in-unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failurec-cleanup-in-unpoison_memory.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm/memory-failure.c: cleanup in unpoison_memory
Date: Fri, 25 Nov 2022 14:54:44 +0800

If freeit it true, the value of ret must be zero, there is no need to
check the value of freeit after label unlock_mutex.

We can drop variable freeit to do this cleanup.

Link: https://lkml.kernel.org/r/20221125065444.3462681-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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

mm-memory-failurec-cleanup-in-unpoison_memory.patch

