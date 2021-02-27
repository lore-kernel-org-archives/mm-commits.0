Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E25C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24DD264F3A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhB0CbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhB0Caj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB7E164F36;
        Sat, 27 Feb 2021 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393004;
        bh=9/C6PeCrCoLZ+0io1FNiAgJ5NbzN5lXib43xGpLCECU=;
        h=Date:From:To:Subject:From;
        b=ybCoVMZc+PBgPkDI/Nq25FAId+CHY7b6iZtPvtOxigeTQSIowTSGLANhIyGu6UeW5
         uuyw9qAKFT4vGcqzDsnrjWMM6KCWkdOJMpD3DoVWxwMF9vzhD4FJ1/kJvgKx1Y+NGS
         MUhYc/67joH+VHYyE0U7udGTUtCiFrwveSuQRD9w=
Date:   Fri, 26 Feb 2021 18:30:03 -0800
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sjenning@redhat.com,
        sjennings@variantweb.net, vitaly.wool@konsulko.com,
        weijie.yang@samsung.com
Subject:  [merged] mm-zswap-clean-up-confusing-comment.patch
 removed from -mm tree
Message-ID: <20210227023003.uBSW0Tdnl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: clean up confusing comment
has been removed from the -mm tree.  Its filename was
     mm-zswap-clean-up-confusing-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: zswap: clean up confusing comment

Correct wording and change one duplicated word (it) to "it is".

Link: https://lkml.kernel.org/r/20201221042848.13980-1-rdunlap@infradead.org
Fixes: 0ab0abcf5115 ("mm/zswap: refactor the get/put routines")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-clean-up-confusing-comment
+++ a/mm/zswap.c
@@ -1022,10 +1022,10 @@ static int zswap_writeback_entry(struct
 
 	/*
 	* if we get here due to ZSWAP_SWAPCACHE_EXIST
-	* a load may happening concurrently
-	* it is safe and okay to not free the entry
+	* a load may be happening concurrently.
+	* it is safe and okay to not free the entry.
 	* if we free the entry in the following put
-	* it it either okay to return !0
+	* it is also okay to return !0
 	*/
 fail:
 	spin_lock(&tree->lock);
_

Patches currently in -mm which might be from rdunlap@infradead.org are


