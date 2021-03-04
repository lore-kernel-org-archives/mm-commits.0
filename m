Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6B8C43381
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282EF64EE1
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhCDA64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379070AbhCDAKX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0058B64F38;
        Thu,  4 Mar 2021 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816582;
        bh=Qa3tUFmtKZh8Qz+vutBBFhJqO2EEv5o/rtprUCVcDSw=;
        h=Date:From:To:Subject:From;
        b=LHfq2kpp7vtaFRLf2iBeKyJb3udcQo2zDTWZSkPumOy6pdyLDRKp9KB4T1idwXHUN
         onTJ2uwxkXeOE+4g1jAce6tV8vu7oZbMwrYQVGt4sytY3RVWW3hbxJdePpimuA6fn2
         PQ45kmIrkvWxD0p3w+HXSOtlQZYj08OYyejocNv0=
Date:   Wed, 03 Mar 2021 16:09:41 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-swapfile-minor-coding-style-tweaks.patch added to
 -mm tree
Message-ID: <20210304000941.SWJxjoX-1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-swapfile-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/swapfile: minor coding style tweaks

Add whitespace to fix coding style issues, improve code reading.

Link: https://lkml.kernel.org/r/1614223624-16055-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-minor-coding-style-tweaks
+++ a/mm/swapfile.c
@@ -2780,7 +2780,7 @@ static int swap_show(struct seq_file *sw
 	unsigned int bytes, inuse;
 
 	if (si == SEQ_START_TOKEN) {
-		seq_puts(swap,"Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
+		seq_puts(swap, "Filename\t\t\t\tType\t\tSize\t\tUsed\t\tPriority\n");
 		return 0;
 	}
 
@@ -3284,7 +3284,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 					 sizeof(long),
 					 GFP_KERNEL);
 
-	if (p->bdev &&(swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
+	if (p->bdev && (swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 		/*
 		 * When discard is enabled for swap with no particular
 		 * policy flagged, we set all swap discard flags here in
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-memremap-fixes-improper-spdx-comment-style.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch

